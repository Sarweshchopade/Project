import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageUserPage extends StatelessWidget {
  const ManageUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage User', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal[700],
      ),
      body: const Center(child: Text('User management (admin)')),
    );
  }
}