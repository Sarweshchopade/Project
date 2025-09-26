import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class WalletPage extends StatefulWidget {
  final String role;
  const WalletPage({super.key, required this.role});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final String baseUrl = 'http://localhost:4000';
  late Future<_WalletSummary> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadSummary();
  }

  Future<_WalletSummary> _loadSummary() async {
    final r = await http.get(Uri.parse('$baseUrl/credits'));
    if (r.statusCode != 200) throw Exception('Failed to load credits');
    final List<dynamic> data = jsonDecode(r.body);
    double total = 0;
    int count = 0;
    for (final e in data) {
      final amt = (e['amount'] is num) ? (e['amount'] as num).toDouble() : double.tryParse('${e['amount']}') ?? 0;
      total += amt;
      count++;
    }
    return _WalletSummary(total: total, count: count);
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.role.toLowerCase();
    return Scaffold(
      appBar: AppBar(title: Text('Wallet', style: GoogleFonts.poppins()), backgroundColor: Colors.teal[700]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<_WalletSummary>(
          future: _future,
          builder: (context, s) {
            if (s.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (s.hasError) return Center(child: Text('Error: ${s.error}', style: GoogleFonts.poppins()));
            final sum = s.data!;
            // Role-specific presentation but using same backend summary
            switch (role) {
              case 'buyer':
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Buyer Wallet', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Card(child: ListTile(title: Text('Total credits (system)', style: GoogleFonts.poppins()), trailing: Text(sum.total.toStringAsFixed(2)))),
                    const SizedBox(height: 12),
                    Text('Total credit items: ${sum.count}', style: GoogleFonts.poppins()),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: () {}, child: const Text('Buy Credits')),
                  ],
                );
              case 'seller':
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seller Wallet', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Card(child: ListTile(title: Text('Total credits (system)', style: GoogleFonts.poppins()), trailing: Text(sum.total.toStringAsFixed(2)))),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: () {}, child: const Text('List Credits for Sale')),
                  ],
                );
              case 'community':
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Community Wallet', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Card(child: ListTile(title: Text('Total credits (system)', style: GoogleFonts.poppins()), trailing: Text(sum.total.toStringAsFixed(2)))),
                    const SizedBox(height: 12),
                    ElevatedButton(onPressed: () {}, child: const Text('Allocate Credits')),
                  ],
                );
              default:
                return Center(child: Text('Wallet (role unknown)', style: GoogleFonts.poppins()));
            }
          },
        ),
      ),
    );
  }
}

class _WalletSummary {
  final double total;
  final int count;
  _WalletSummary({required this.total, required this.count});
}