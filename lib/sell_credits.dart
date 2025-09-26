import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SellCreditsPage extends StatelessWidget {
  const SellCreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell Credits', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal[700],
      ),
      body: const Center(child: Text('Sell credits UI / marketplace placeholder')),
    );
  }
}
