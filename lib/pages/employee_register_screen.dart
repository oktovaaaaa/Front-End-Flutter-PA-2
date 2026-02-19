import 'package:flutter/material.dart';
import '../services/api.dart';
import '../services/password_policy.dart';

class EmployeeRegisterScreen extends StatefulWidget {
  final String inviteToken;
  const EmployeeRegisterScreen({super.key, required this.inviteToken});

  @override
  State<EmployeeRegisterScreen> createState() => _EmployeeRegisterScreenState();
}

class _EmployeeRegisterScreenState extends State<EmployeeRegisterScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  bool busy = false;
  String msg = "";

  Future<void> submit() async {
    final pw = passCtrl.text;
    final pwErr = PasswordPolicy.validate(pw);
    if (pwErr != null) {
      setState(() => msg = pwErr);
      return;
    }

    setState(() {
      busy = true;
      msg = "";
    });

    try {
      final res = await Api.registerEmployee(
        inviteToken: widget.inviteToken,
        fullName: nameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        password: pw,
      );

      setState(() {
        msg = "Register sukses. Status masih PENDING.\n$res";
      });
    } catch (e) {
      setState(() => msg = "Gagal: $e");
    } finally {
      setState(() => busy = false);
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register Karyawan")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Invite token: ${widget.inviteToken}", maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 12),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Nama lengkap", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: "No HP", border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password (min 8, ada besar/kecil/angka/simbol)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: busy ? null : submit, child: const Text("Register Karyawan")),
            const SizedBox(height: 12),
            Text(msg),
          ],
        ),
      ),
    );
  }
}
