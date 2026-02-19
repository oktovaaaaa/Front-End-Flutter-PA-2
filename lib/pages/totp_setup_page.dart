import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/api.dart';

class TotpSetupPage extends StatefulWidget {
  final String email;
  final String otpauth; // otpauth URL dari backend
  final String afterMessage;

  const TotpSetupPage({
    super.key,
    required this.email,
    required this.otpauth,
    required this.afterMessage,
  });

  @override
  State<TotpSetupPage> createState() => _TotpSetupPageState();
}

class _TotpSetupPageState extends State<TotpSetupPage> {
  final codeCtrl = TextEditingController();
  bool busy = false;
  String msg = "";

  @override
  void dispose() {
    codeCtrl.dispose();
    super.dispose();
  }

  Future<void> verify() async {
    final code = codeCtrl.text.trim();
    if (code.isEmpty) {
      setState(() => msg = "Kode TOTP wajib diisi");
      return;
    }

    setState(() {
      busy = true;
      msg = "Memverifikasi...";
    });

    try {
      // pastikan method ini ada di services/api.dart kamu.
      // biasanya endpoint: POST /api/v1/auth/totp/verify
      final res = await Api.verifyTotp(
        email: widget.email,
        code: code,
      );

      if (!mounted) return;
      setState(() {
        msg = "TOTP sukses ✅\n$res";
      });

      // TODO: setelah sukses, kamu mau arahkan kemana:
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
    } catch (e) {
      setState(() => msg = "Gagal: $e");
    } finally {
      setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setup TOTP")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(widget.afterMessage),
            const SizedBox(height: 12),

            const Text("Scan QR ini di Google Authenticator / Authy"),
            const SizedBox(height: 12),

            QrImageView(
              data: widget.otpauth,
              size: 220,
            ),

            const SizedBox(height: 10),
            SelectableText(widget.otpauth),

            const SizedBox(height: 16),
            TextField(
              controller: codeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Masukkan kode 6 digit",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: busy ? null : verify,
                child: const Text("Verifikasi TOTP"),
              ),
            ),

            const SizedBox(height: 12),
            Text(msg),
          ],
        ),
      ),
    );
  }
}
