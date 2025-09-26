import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ValidationCreditsPage extends StatelessWidget {
  const ValidationCreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validation of Credits', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal[700],
      ),
      body: const Center(child: Text('Screen for validating credits (admin/NCCR)')),
    );
  }
}