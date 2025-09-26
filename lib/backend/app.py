from flask import Flask, request, jsonify
from flask_cors import CORS
from werkzeug.security import generate_password_hash, check_password_hash
from pymongo import MongoClient
from flask_jwt_extended import (
    JWTManager, create_access_token, jwt_required, get_jwt_identity
)
import datetime

app = Flask(__name__)
CORS(app)

app.config['JWT_SECRET_KEY'] = 'your_secret_key_here'  # Use a secure key
jwt = JWTManager(app)

# MongoDB setup
client = MongoClient('mongodb://localhost:27017/')
db = client['blue_carbon']
users_collection = db['carbonProject']  # ✅ Corrected name

# 📝 Signup
@app.route('/signup', methods=['POST'])
def signup():
    data = request.get_json()
    email = data['email']
    password = generate_password_hash(data['password'])
    role = data['role']

    if users_collection.find_one({'email': email}):
        return jsonify({'msg': 'User already exists'}), 409

    users_collection.insert_one({'email': email, 'password': password, 'role': role})
    return jsonify({'msg': 'Signup successful'}), 201

# 🔐 Login
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data['email']
    password = data['password']

    user = users_collection.find_one({'email': email})
    login_ok = False
    if user:
        stored_pw = user.get('password', '')
        try:
            # Normal case: stored password is a werkzeug hash
            if check_password_hash(stored_pw, password):
                login_ok = True
        except ValueError:
            # This happens when the stored hash has an unexpected/empty method
            # Possible causes: password stored in plaintext, or corrupted hash.
            # For convenience during migration: if the stored value equals the
            # provided password, assume it was plaintext and re-hash it.
            if stored_pw == password:
                new_hash = generate_password_hash(password)
                users_collection.update_one({'_id': user['_id']}, {'$set': {'password': new_hash}})
                login_ok = True
            else:
                # Log for debugging (keep minimal in production)
                print(f"Invalid password hash for user {email}: '{stored_pw[:20]}...'")

    if user and login_ok:
        access_token = create_access_token(
            identity={'email': email, 'role': user['role']},
            expires_delta=datetime.timedelta(hours=1)
        )
        return jsonify({'token': access_token, 'role': user['role']}), 200
    else:
        return jsonify({'msg': 'Invalid credentials'}), 401

# 🔒 Protected Profile
@app.route('/profile', methods=['GET'])
@jwt_required()
def profile():
    identity = get_jwt_identity()
    return jsonify({'email': identity['email'], 'role': identity['role']}), 200

if __name__ == '__main__':
    app.run(debug=True)