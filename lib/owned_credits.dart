import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class OwnedCreditsPage extends StatefulWidget {
  final String? userId;
  const OwnedCreditsPage({super.key, this.userId});

  @override
  State<OwnedCreditsPage> createState() => _OwnedCreditsPageState();
}

class _OwnedCreditsPageState extends State<OwnedCreditsPage> {
  final String baseUrl = 'http://localhost:4000';
  late Future<List<_Credit>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadOwned();
  }

  Future<List<_Credit>> _loadOwned() async {
    final uri = widget.userId != null
        ? Uri.parse('$baseUrl/credits/${widget.userId}')
        : Uri.parse('$baseUrl/credits');
    final r = await http.get(uri);
    if (r.statusCode != 200) throw Exception('Failed to load credits: ${r.statusCode}');
    final List<dynamic> data = jsonDecode(r.body);
    return data.map((e) {
      return _Credit(
        id: e['_id']?.toString() ?? '',
        amount: (e['amount'] is num) ? (e['amount'] as num).toDouble() : double.tryParse('${e['amount']}') ?? 0.0,
        project: e['project'] is Map ? (e['project']['title'] ?? e['project']['location'] ?? 'Area') : (e['project']?.toString() ?? 'Area'),
        txHash: e['txHash']?.toString() ?? '',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owned Credits', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal[700],
      ),
      body: FutureBuilder<List<_Credit>>(
        future: _future,
        builder: (context, s) {
          if (s.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (s.hasError) return Center(child: Text('Error: ${s.error}', style: GoogleFonts.poppins()));
          final list = s.data ?? [];
          if (list.isEmpty) return Center(child: Text('No owned credits', style: GoogleFonts.poppins()));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (ctx, i) {
              final c = list[i];
              return Card(
                child: ListTile(
                  title: Text(c.project, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  subtitle: Text('Tx: ${c.txHash}', style: GoogleFonts.poppins(fontSize: 12)),
                  trailing: Text(c.amount.toStringAsFixed(2), style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: list.length,
          );
        },
      ),
    );
  }
}

class _Credit {
  final String id;
  final double amount;
  final String project;
  final String txHash;
  _Credit({required this.id, required this.amount, required this.project, required this.txHash});
}