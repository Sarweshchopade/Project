// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/contact_card.dart';
import 'package:project/dashboard.dart'; // 👈 Make sure this file exists

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'buyer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FDFB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🌿 Horizontal Taskbar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                color: const Color(0xFFe0f2f1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 🍃 Logo + Title
                    Row(
                      children: [
                        const Icon(Icons.eco, color: Colors.green, size: 28),
                        const SizedBox(width: 8),
                        Text(
                          'Blue Carbon MRV',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal[900],
                          ),
                        ),
                      ],
                    ),

                    // 🧭 Navigation Links
                    Row(
                      children: [
                        navItem('Home'),
                        navItem('About'),
                        navItem('FAQ'),
                      ],
                    ),

                    // 🔐 Auth Buttons (optional)
                    const SizedBox(),
                  ],
                ),
              ),

              // 🌟 Hero Section
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Animate(
                  effects: [
                    FadeEffect(duration: 1000.ms),
                    SlideEffect(begin: const Offset(0, -0.2)),
                  ],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 📝 Welcome Text
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: Text(
                            'WELCOME \nTO \nBLUE CARBON MRV',
                            style: GoogleFonts.poppins(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[800],
                            ),
                          ),
                        ),
                      ),

                      // 🔐 Login/Signup Container
                      Container(
                        width: 300,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFe0f2f1),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Role',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedRole,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'buyer',
                                  child: Text('Buyer'),
                                ),
                                DropdownMenuItem(
                                  value: 'seller',
                                  child: Text('Seller'),
                                ),
                                DropdownMenuItem(
                                  value: 'community',
                                  child: Text('Community User'),
                                ),
                                DropdownMenuItem(
                                  value: 'nccr',
                                  child: Text('NCCR Officer'),
                                ),
                              ],
                              onChanged: (initialValue) {
                                if (initialValue != null) {
                                  setState(() => _selectedRole = initialValue);
                                }
                              },
                            ),
                            const SizedBox(height: 16),

                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email ID',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),

                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    final email = _emailController.text.trim();
                                    final password = _passwordController.text
                                        .trim();

                                    if (email.isNotEmpty &&
                                        password.isNotEmpty) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DashboardPage(
                                            role: _selectedRole,
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please enter email and password',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text('Login'),
                                ),
                                OutlinedButton(
                                  onPressed: () => _showSignupDialog(context),
                                  child: const Text('Signup'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 🪴 Carbon Credit Info Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Animate(
                  effects: [
                    FadeEffect(duration: 800.ms),
                    SlideEffect(begin: const Offset(0, 0.2)),
                  ],
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'What is a Carbon Credit?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[800],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Carbon credits are tradable certificates that represent the removal or reduction of one metric ton of CO₂ from the atmosphere. \nBuying them helps offset emissions and supports eco-restoration.',
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '🌱 Benefits of Buying Carbon Credits:',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green[700],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '• Support climate action\n• Promote coastal restoration\n• Offset your carbon footprint\n• Encourage transparency via blockchain',
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Transform.translate(
                            offset: const Offset(-10, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/carbon_credit.png',
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const ContactCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.teal[700]),
      ),
    );
  }

  void _showSignupDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    String selectedRole = 'buyer';

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create an Account',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return DropdownButtonFormField<String>(
                            value: selectedRole,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'buyer',
                                child: Text('Buyer'),
                              ),
                              DropdownMenuItem(
                                value: 'seller',
                                child: Text('Seller'),
                              ),
                              DropdownMenuItem(
                                value: 'community',
                                child: Text('Community User'),
                              ),
                              DropdownMenuItem(
                                value: 'nccr',
                                child: Text('NCCR Officer'),
                              ),
                            ],
                            onChanged: (v) {
                              if (v != null) setState(() => selectedRole = v);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();

                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please fill all fields'),
                                  ),
                                );
                                return;
                              }

                              // Close dialog
                              Navigator.of(context, rootNavigator: true).pop();

                              // Show confirmation/snackbar - replace with actual signup call as needed
                              Future.delayed(
                                const Duration(milliseconds: 200),
                                () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Signup requested for $email as $selectedRole',
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text('Create Account'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
