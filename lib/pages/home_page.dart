// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import '../services/api.dart';
import 'admin_tools_page.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  final dynamic user;
  const HomePage({super.key, required this.user});

  Future<void> _logout(BuildContext context) async {
    await Api.logout();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const StartPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = (user?["role"] ?? "").toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Halo, ${user?["full_name"] ?? "-"}"),
            Text("Role: $role"),
            const SizedBox(height: 16),
            if (role == "ADMIN" || role == "OWNER")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminToolsPage()),
                  ),
                  child: const Text("Admin Tools (Invite + Approve)"),
                ),
              ),
            const SizedBox(height: 8),
            const Text("Absensi dan face recognition kita kerjakan belakangan."),
          ],
        ),
      ),
    );
  }
}
