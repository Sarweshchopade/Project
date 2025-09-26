import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/available_credits.dart';
import 'package:project/owned_credits.dart';
import 'package:project/credit_entry.dart';
import 'package:project/sell_credits.dart';
import 'package:project/wallet_page.dart';
import 'package:project/request_credits.dart';
import 'package:project/verified_credits.dart';
import 'package:project/rejected_credits.dart';
import 'package:project/validation_credits.dart';
import 'package:project/active_communities.dart';
import 'package:project/manage_user.dart';

class DashboardPage extends StatelessWidget {
  final String role;
  const DashboardPage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final features = _getFeatures(role);

    return Scaffold(
      appBar: AppBar(
        title: Text('$role Dashboard', style: GoogleFonts.poppins()),
        backgroundColor: Colors.teal[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  'Welcome, $role',
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
              ),
            ),
            // Horizontal scrollable feature tabs
            SizedBox(
              height: 170,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: features.length,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 220,
                    child: _featureCard(context, features[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFeatures(String role) {
    switch (role.toLowerCase()) {
      case 'buyer':
        return [
          {'title': 'Available Credits', 'icon': Icons.credit_card},
          {'title': 'Owned Credits', 'icon': Icons.verified},
          {'title': 'Wallet', 'icon': Icons.account_balance_wallet},
        ];
      case 'seller':
        return [
          {'title': 'Credit Entry', 'icon': Icons.edit},
          {'title': 'Rejected Credits', 'icon': Icons.cancel},
          {'title': 'Selled Credits', 'icon': Icons.sell},
          {'title': 'Wallet', 'icon': Icons.account_balance_wallet},
        ];
      case 'community':
        return [
          {'title': 'Credit Entry', 'icon': Icons.edit},
          {'title': 'Verified Credits', 'icon': Icons.check_circle},
          {'title': 'Rejected Credits', 'icon': Icons.cancel},
          {'title': 'Available Credits', 'icon': Icons.credit_card},
          {'title': 'Owned Credits', 'icon': Icons.verified},
          {'title': 'Wallet', 'icon': Icons.account_balance_wallet},
        ];
      case 'nccr':
        return [
          {'title': 'Validation of Credits', 'icon': Icons.fact_check},
          {'title': 'Active Communities', 'icon': Icons.groups},
          {'title': 'Manage User', 'icon': Icons.person_rounded},
        ];
      default:
        return [
          {'title': 'Unknown Role', 'icon': Icons.error_outline},
        ];
    }
  }

  Widget _featureCard(BuildContext context, Map<String, dynamic> feature) {
    return Animate(
      effects: [
        FadeEffect(duration: 600.ms),
        ScaleEffect(begin: const Offset(0.95, 0.95)),
      ],
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: () {
            final title = (feature['title'] as String).toLowerCase();
            Widget? page;
            switch (title) {
              case 'available credits':
                page = const AvailableCreditsPage();
                break;
              case 'owned credits':
                page = const OwnedCreditsPage();
                break;
              case 'credit entry':
                page = const CreditEntryPage();
                break;
              case 'selled credits':
                page = const SellCreditsPage();
                break;
              case 'wallet':
                page = WalletPage(role: role);
                break;
              case 'request for credits':
              case 'request for credit':
                page = const RequestCreditsPage();
                break;
              case 'verified credits':
                page = const VerifiedCreditsPage();
                break;
              case 'rejected credits':
                page = const RejectedCreditsPage();
                break;
              case 'validation of credits':
                page = const ValidationCreditsPage();
                break;
              case 'active communities':
                page = const ActiveCommunitiesPage();
                break;
              case 'manage user':
                page = const ManageUserPage();
                break;
            }
            if (page != null) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(feature['icon'], size: 40, color: Colors.teal[700]),
                const SizedBox(height: 12),
                Text(
                  feature['title'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
