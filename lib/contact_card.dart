import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({super.key});

  // 🔗 Social Media Links
  final String instagramUrl = 'https://www.instagram.com/bluecarbonmrv';
  final String facebookUrl = 'https://www.facebook.com/bluecarbonmrv';
  final String linkedinUrl = 'https://www.linkedin.com/company/bluecarbonmrv';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(32),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Us',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800],
              ),
            ),
            const SizedBox(height: 16),

            // 📞 Customer Care
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  '+91 98765 43210',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 🌐 Social Media
            Text(
              'Follow us on:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                socialIcon(Icons.camera_alt, instagramUrl),
                const SizedBox(width: 16),
                socialIcon(Icons.facebook, facebookUrl),
                const SizedBox(width: 16),
                socialIcon(Icons.business, linkedinUrl),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget socialIcon(IconData icon, String url) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      },
      child: CircleAvatar(
        backgroundColor: Colors.teal[100],
        child: Icon(icon, color: Colors.teal[800]),
      ),
    );
  }
}