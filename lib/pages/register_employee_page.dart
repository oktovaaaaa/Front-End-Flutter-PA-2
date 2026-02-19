// lib/pages/register_employee_page.dart
import 'package:flutter/material.dart';
import '../services/api.dart';
import 'totp_setup_page.dart';

class RegisterEmployeePage extends StatefulWidget {
  const RegisterEmployeePage({super.key});

  @override
  State<RegisterEmployeePage> createState() => _RegisterEmployeePageState();
}

class _RegisterEmployeePageState extends State<RegisterEmployeePage> {
  final _invite = TextEditingController();
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  String _status = "";
  bool _busy = false;

  @override
  void dispose() {
    _invite.dispose();
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _status = "Mengirim...";
    });

    try {
      final res = await Api.registerEmployee(
        inviteToken: _invite.text.trim(),
        fullName: _fullName.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        password: _password.text,
      );

      final otpauth = res["otpauth"]?.toString() ?? "";
      if (otpauth.isEmpty) throw Exception("otpauth kosong");

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TotpSetupPage(
            email: _email.text.trim(),
            otpauth: otpauth,
            afterMessage: "Karyawan berhasil register. Setup TOTP. Setelah itu tunggu admin approve untuk bisa login.",
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _busy = false;
        _status = "Gagal: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Karyawan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _invite, decoration: const InputDecoration(labelText: "Invite token (dari admin)", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _fullName, decoration: const InputDecoration(labelText: "Nama lengkap", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _email, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _phone, decoration: const InputDecoration(labelText: "No HP", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _busy ? null : _submit,
                child: const Text("Register Karyawan"),
              ),
            ),
            const SizedBox(height: 12),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
