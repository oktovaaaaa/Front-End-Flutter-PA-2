// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/device_id.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _totp = TextEditingController();

  final _device = DeviceIdService();

  String _status = "";
  bool _busy = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _totp.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _busy = true;
      _status = "Login...";
    });

    try {
      final deviceId = await _device.getOrCreate();
      final res = await Api.login(
        email: _email.text.trim(),
        password: _password.text,
        totpCode: _totp.text.trim(),
        deviceId: deviceId,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(user: res["user"])),
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
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: _totp, decoration: const InputDecoration(labelText: "Kode TOTP (6 digit)", border: OutlineInputBorder()), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _busy ? null : _login,
                child: const Text("Login"),
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
