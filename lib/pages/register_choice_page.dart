import 'package:flutter/material.dart';
import 'register_admin_page.dart';
import 'employee_scan_screen.dart';

class RegisterChoicePage extends StatelessWidget {
  const RegisterChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterAdminPage()),
                ),
                child: const Text("Register sebagai Admin"),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EmployeeScanScreen()),
                ),
                child: const Text("Register sebagai Karyawan (Scan Barcode)"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
