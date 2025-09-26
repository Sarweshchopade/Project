import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RejectedCreditsPage extends StatelessWidget {
  const RejectedCreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rejected Credits', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal[700],
      ),
      body: const Center(child: Text('Rejected credit requests and reasons')),
    );
  }
}