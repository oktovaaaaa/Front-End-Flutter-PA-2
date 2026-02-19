import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'employee_register_screen.dart';

class EmployeeScanScreen extends StatefulWidget {
  const EmployeeScanScreen({super.key});

  @override
  State<EmployeeScanScreen> createState() => _EmployeeScanScreenState();
}

class _EmployeeScanScreenState extends State<EmployeeScanScreen> {
  bool _locked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Barcode Undangan")),
      body: MobileScanner(
        onDetect: (capture) {
          if (_locked) return;
          final codes = capture.barcodes;
          if (codes.isEmpty) return;

          final raw = codes.first.rawValue;
          if (raw == null || raw.trim().isEmpty) return;

          _locked = true;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => EmployeeRegisterScreen(inviteToken: raw.trim()),
            ),
          );
        },
      ),
    );
  }
}
