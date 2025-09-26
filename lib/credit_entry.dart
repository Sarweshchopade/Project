import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CreditEntryPage extends StatefulWidget {
  const CreditEntryPage({super.key});

  @override
  State<CreditEntryPage> createState() => _CreditEntryPageState();
}

class _CreditEntryPageState extends State<CreditEntryPage> {
  final String baseUrl = 'http://localhost:4000';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _location = TextEditingController();
  final TextEditingController _amount = TextEditingController();
  bool _loading = false;
  String? _result;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _result = null; });
    try {
      // Try creating a project first
      final pResp = await http.post(
        Uri.parse('$baseUrl/projects'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': _title.text.trim(), 'location': _location.text.trim()}),
      );
      if (pResp.statusCode != 201 && pResp.statusCode != 200) {
        // If project creation failed, still attempt to inform user
        setState(() { _result = 'Project creation returned ${pResp.statusCode}'; });
      } else {
        final proj = jsonDecode(pResp.body);
        final projectId = proj['_id'] ?? proj['id'] ?? '';
        // Optionally call credits/mint if backend permits (may require auth)
        final cResp = await http.post(
          Uri.parse('$baseUrl/credits/mint'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'project': projectId, 'amount': double.tryParse(_amount.text.trim()) ?? 0}),
        );
        if (cResp.statusCode == 201 || cResp.statusCode == 200) {
          setState(() { _result = 'Credit entry created'; });
        } else {
          setState(() { _result = 'Project created, credit mint returned ${cResp.statusCode}'; });
        }
      }
    } catch (e) {
      setState(() { _result = 'Error: $e'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _location.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit Entry', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(children: [
                TextFormField(
                  controller: _title,
                  decoration: const InputDecoration(labelText: 'Project / Area Title', border: OutlineInputBorder()),
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _location,
                  decoration: const InputDecoration(labelText: 'Location', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amount,
                  decoration: const InputDecoration(labelText: 'Credit amount', border: OutlineInputBorder()),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (v) => (double.tryParse(v ?? '') == null) ? 'Enter valid number' : null,
                ),
                const SizedBox(height: 16),
                _loading
                    ? const CircularProgressIndicator()
                    : Row(
                        children: [
                          ElevatedButton(onPressed: _submit, child: const Text('Submit')),
                          const SizedBox(width: 12),
                          TextButton(onPressed: () { _formKey.currentState?.reset(); }, child: const Text('Reset')),
                        ],
                      ),
                if (_result != null) ...[
                  const SizedBox(height: 12),
                  Text(_result!, style: GoogleFonts.poppins()),
                ],
              ]),
            ),
          ],
        ),
      ),
    );
  }
}