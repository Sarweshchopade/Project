import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AvailableCreditsPage extends StatefulWidget {
  const AvailableCreditsPage({super.key});

  @override
  State<AvailableCreditsPage> createState() => _AvailableCreditsPageState();
}

class _AvailableCreditsPageState extends State<AvailableCreditsPage> {
  // Use the Node/Express backend (blue-carbon-backend) which listens on port 4000 by default
  // The Flask app (port 5000) does not provide the /credits endpoint, so use 4000.
  final String baseUrl = 'http://localhost:4000';
  late Future<List<CreditItem>> _creditsFuture;

  @override
  void initState() {
    super.initState();
    _creditsFuture = _fetchCredits();
  }

  Future<List<CreditItem>> _fetchCredits() async {
    final resp = await http.get(Uri.parse('$baseUrl/credits'));
    if (resp.statusCode != 200) throw Exception('Failed to load credits');
    final List<dynamic> data = jsonDecode(resp.body);

    // For each credit, attempt to fetch project details if project is an id string
    final List<CreditItem> credits = [];
    for (final c in data) {
      final projectField = c['project'];
      Map<String, dynamic>? projectObj;

      if (projectField is Map) {
        projectObj = Map<String, dynamic>.from(projectField);
      } else if (projectField is String && projectField.isNotEmpty) {
        // try fetch project details
        try {
          final pResp = await http.get(
            Uri.parse('$baseUrl/projects/$projectField'),
          );
          if (pResp.statusCode == 200) {
            projectObj = jsonDecode(pResp.body) as Map<String, dynamic>;
          }
        } catch (_) {
          projectObj = null;
        }
      }

      credits.add(
        CreditItem(
          id: c['_id'] ?? c['id'] ?? '',
          amount: (c['amount'] ?? 0).toDouble(),
          txHash: c['txHash'] ?? '',
          mintedAt: c['mintedAt'] ?? c['createdAt'],
          projectTitle: projectObj != null
              ? (projectObj['title'] ??
                    projectObj['location'] ??
                    'Unknown Area')
              : 'Unknown Area',
        ),
      );
    }

    return credits;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Credits', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal[700],
      ),
      body: FutureBuilder<List<CreditItem>>(
        future: _creditsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final credits = snapshot.data ?? [];
          if (credits.isEmpty) {
            return const Center(child: Text('No credits found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: credits.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final c = credits[i];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.projectTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Value',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            '${c.amount}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (c.txHash.isNotEmpty)
                        Text(
                          'Tx: ${c.txHash}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      if (c.mintedAt != null)
                        Text(
                          'Minted: ${c.mintedAt}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CreditItem {
  final String id;
  final double amount;
  final String txHash;
  final String? mintedAt;
  final String projectTitle;

  CreditItem({
    required this.id,
    required this.amount,
    required this.txHash,
    required this.mintedAt,
    required this.projectTitle,
  });
}
