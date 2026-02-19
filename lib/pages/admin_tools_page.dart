// lib/pages/admin_tools_page.dart
import 'package:flutter/material.dart';
import '../services/api.dart';

class AdminToolsPage extends StatefulWidget {
  const AdminToolsPage({super.key});

  @override
  State<AdminToolsPage> createState() => _AdminToolsPageState();
}

class _AdminToolsPageState extends State<AdminToolsPage> {
  String _inviteToken = "";
  String _status = "";
  bool _busy = false;

  List<dynamic> _pending = [];

  Future<void> _generateInvite() async {
    setState(() {
      _busy = true;
      _status = "Generate invite...";
    });

    try {
      final res = await Api.adminGenerateInvite(minutesValid: 60);
      setState(() {
        _busy = false;
        _inviteToken = res["token"].toString();
        _status = "Invite dibuat (valid 60 menit).";
      });
    } catch (e) {
      setState(() {
        _busy = false;
        _status = "Gagal: $e";
      });
    }
  }

  Future<void> _loadPending() async {
    setState(() {
      _busy = true;
      _status = "Load pending...";
    });

    try {
      final res = await Api.adminPendingEmployees();
      setState(() {
        _busy = false;
        _pending = (res["data"] as List<dynamic>);
        _status = "Pending loaded: ${_pending.length}";
      });
    } catch (e) {
      setState(() {
        _busy = false;
        _status = "Gagal: $e";
      });
    }
  }

  Future<void> _approve(int id) async {
    setState(() {
      _busy = true;
      _status = "Approve...";
    });

    try {
      await Api.adminApproveEmployee(id);
      await _loadPending();
    } catch (e) {
      setState(() {
        _busy = false;
        _status = "Gagal: $e";
      });
    }
  }

  Future<void> _reject(int id) async {
    setState(() {
      _busy = true;
      _status = "Reject...";
    });

    try {
      await Api.adminRejectEmployee(id);
      await _loadPending();
    } catch (e) {
      setState(() {
        _busy = false;
        _status = "Gagal: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPending();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Tools")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _busy ? null : _generateInvite,
                child: const Text("Generate Invite Token"),
              ),
            ),
            const SizedBox(height: 8),
            if (_inviteToken.isNotEmpty) SelectableText("Invite token: $_inviteToken"),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _busy ? null : _loadPending,
                    child: const Text("Refresh Pending"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _pending.length,
                itemBuilder: (context, i) {
                  final u = _pending[i] as Map<String, dynamic>;
                  final id = (u["id"] as num).toInt();
                  final name = u["full_name"]?.toString() ?? "-";
                  final email = u["email"]?.toString() ?? "-";
                  return Card(
                    child: ListTile(
                      title: Text(name),
                      subtitle: Text(email),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: _busy ? null : () => _approve(id),
                            child: const Text("Approve"),
                          ),
                          TextButton(
                            onPressed: _busy ? null : () => _reject(id),
                            child: const Text("Reject"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
