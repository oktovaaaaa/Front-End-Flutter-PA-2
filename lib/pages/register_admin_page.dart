// lib/pages/register_admin_page.dart
import 'package:flutter/material.dart';
import '../services/api.dart';
import 'totp_setup_page.dart';

class RegisterAdminPage extends StatefulWidget {
  const RegisterAdminPage({super.key});

  @override
  State<RegisterAdminPage> createState() => _RegisterAdminPageState();
}

class _RegisterAdminPageState extends State<RegisterAdminPage> {
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();

  final _companyName = TextEditingController();
  final _companyEmail = TextEditingController();
  final _companyPhone = TextEditingController();
  final _companyAddr = TextEditingController();

  String _status = "";
  bool _busy = false;

  @override
  void dispose() {
    _fullName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _companyName.dispose();
    _companyEmail.dispose();
    _companyPhone.dispose();
    _companyAddr.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _status = "Mengirim...";
    });

    try {
      final res = await Api.registerAdmin(
        fullName: _fullName.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        password: _password.text,
        companyName: _companyName.text.trim(),
        companyEmail: _companyEmail.text.trim(),
        companyPhone: _companyPhone.text.trim(),
        companyAddress: _companyAddr.text.trim(),
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
            afterMessage: "Admin berhasil register. Sekarang setup TOTP.",
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
      appBar: AppBar(title: const Text("Register Admin")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _fullName, decoration: const InputDecoration(labelText: "Nama lengkap", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _email, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _phone, decoration: const InputDecoration(labelText: "No HP", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
            const SizedBox(height: 16),

            const Align(alignment: Alignment.centerLeft, child: Text("Data Perusahaan")),
            const SizedBox(height: 8),
            TextField(controller: _companyName, decoration: const InputDecoration(labelText: "Nama perusahaan", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _companyEmail, decoration: const InputDecoration(labelText: "Email perusahaan", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _companyPhone, decoration: const InputDecoration(labelText: "Telp perusahaan", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _companyAddr, decoration: const InputDecoration(labelText: "Alamat perusahaan", border: OutlineInputBorder())),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _busy ? null : _submit,
                child: const Text("Register Admin"),
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
