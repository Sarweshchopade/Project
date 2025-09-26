import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RequestCreditsPage extends StatefulWidget {
  const RequestCreditsPage({super.key});

  @override
  State<RequestCreditsPage> createState() => _RequestCreditsPageState();
}

class _RequestCreditsPageState extends State<RequestCreditsPage> {
  final String baseUrl = 'http://localhost:4000';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reason = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  bool _loading = false;
  String? _msg;

  Future<void> _sendRequest() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _msg = null; });
    try {
      final r = await http.post(
        Uri.parse('$baseUrl/requests'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': double.tryParse(_amount.text.trim()) ?? 0, 'reason': _reason.text.trim()}),
      );
      if (r.statusCode == 201 || r.statusCode == 200) {
        setState(() { _msg = 'Request submitted'; });
      } else {
        setState(() { _msg = 'Server returned ${r.statusCode}'; });
      }
    } catch (e) {
      setState(() { _msg = 'Error: $e'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  void dispose() {
    _reason.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Request Credits', style: GoogleFonts.poppins()), backgroundColor: Colors.teal[700]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _amount,
                decoration: const InputDecoration(labelText: 'Amount', border: OutlineInputBorder()),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) => (double.tryParse(v ?? '') == null) ? 'Enter number' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _reason,
                decoration: const InputDecoration(labelText: 'Reason', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              _loading ? const CircularProgressIndicator() : ElevatedButton(onPressed: _sendRequest, child: const Text('Submit')),
              if (_msg != null) ...[ const SizedBox(height: 12), Text(_msg!, style: GoogleFonts.poppins()) ],
            ]),
          ),
        ]),
      ),
    );
  }
}