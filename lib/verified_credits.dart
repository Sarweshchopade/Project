import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifiedCreditsPage extends StatelessWidget {
  const VerifiedCreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verified Credits', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal[700],
      ),
      body: const Center(child: Text('List of verified credits')),
    );
  }
}