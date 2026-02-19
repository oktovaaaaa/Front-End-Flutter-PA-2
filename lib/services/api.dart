// lib/services/api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
static const String baseUrl = "http://172.20.10.2:8080";
  static String? token;

  static Map<String, String> _headers({bool auth = false}) {
    final h = <String, String>{"Content-Type": "application/json"};
    if (auth && token != null && token!.isNotEmpty) {
      h["Authorization"] = "Bearer $token";
    }
    return h;
  }

  static Map<String, dynamic> _decode(http.Response res) {
    final body = res.body.trim();
    if (body.isEmpty) return {"message": ""};
    final data = jsonDecode(body);
    if (data is Map<String, dynamic>) return data;
    return {"data": data};
  }

  static Exception _err(String label, http.Response res) {
    try {
      final data = _decode(res);
      return Exception("$label (${res.statusCode}): $data");
    } catch (_) {
      return Exception("$label (${res.statusCode}): ${res.body}");
    }
  }

  // =========================
  // AUTH: ADMIN REGISTER
  // =========================
  static Future<Map<String, dynamic>> registerAdmin({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String companyName,
    required String companyEmail,
    required String companyPhone,
    required String companyAddress,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/v1/auth/admin/register"),
      headers: _headers(),
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "password": password,
        "company_name": companyName,
        "company_email": companyEmail,
        "company_phone": companyPhone,
        "company_address": companyAddress,
      }),
    );

    if (res.statusCode != 200) throw _err("registerAdmin", res);
    return _decode(res);
  }

  // =========================
  // AUTH: EMPLOYEE REGISTER
  // =========================
  static Future<Map<String, dynamic>> registerEmployee({
    required String inviteToken,
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/v1/auth/employee/register"),
      headers: _headers(),
      body: jsonEncode({
        "invite_token": inviteToken,
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "password": password,
      }),
    );

    if (res.statusCode != 200) throw _err("registerEmployee", res);
    return _decode(res);
  }

  // =========================
  // AUTH: VERIFY TOTP SETUP
  // =========================
  // setelah admin register, verifikasi kode TOTP (setup)
  static Future<Map<String, dynamic>> verifyTotp({
    required String email,
    required String code,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/v1/auth/totp/verify"),
      headers: _headers(),
      body: jsonEncode({
        "email": email,
        "code": code,
      }),
    );

    if (res.statusCode != 200) throw _err("verifyTotp", res);
    return _decode(res);
  }

  // =========================
  // AUTH: LOGIN
  // =========================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String totpCode,
    required String deviceId,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/v1/auth/login"),
      headers: _headers(),
      body: jsonEncode({
        "email": email,
        "password": password,
        "totp_code": totpCode,
        "device_id": deviceId,
      }),
    );

    if (res.statusCode != 200) throw _err("login", res);

    final data = _decode(res);
    token = (data["token"] as String?) ?? token;
    return data;
  }

  // =========================
  // AUTH: LOGOUT
  // =========================
  static Future<void> logout() async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/v1/auth/logout"),
      headers: _headers(auth: true),
    );

    if (res.statusCode != 200) throw _err("logout", res);
    token = null;
  }

  // =========================
  // ADMIN: GENERATE INVITE TOKEN
  // =========================
  static Future<Map<String, dynamic>> adminGenerateInvite({
    int minutesValid = 60,
  }) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/v1/admin/invite"),
      headers: _headers(auth: true),
      body: jsonEncode({
        "minutes_valid": minutesValid,
      }),
    );

    if (res.statusCode != 200) throw _err("adminGenerateInvite", res);
    return _decode(res);
  }

  // =========================
  // ADMIN: LIST PENDING EMPLOYEES
  // =========================
  static Future<Map<String, dynamic>> adminPendingEmployees() async {
    final res = await http.get(
      Uri.parse("$baseUrl/api/v1/admin/employees/pending"),
      headers: _headers(auth: true),
    );

    if (res.statusCode != 200) throw _err("adminPendingEmployees", res);
    return _decode(res);
  }

  // =========================
  // ADMIN: APPROVE / REJECT EMPLOYEE
  // =========================
  static Future<void> adminApproveEmployee(int id) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/v1/admin/employees/$id/approve"),
      headers: _headers(auth: true),
    );

    if (res.statusCode != 200) throw _err("adminApproveEmployee", res);
  }

  static Future<void> adminRejectEmployee(int id) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/v1/admin/employees/$id/reject"),
      headers: _headers(auth: true),
    );

    if (res.statusCode != 200) throw _err("adminRejectEmployee", res);
  }

  // =========================
  // ADMIN: RESET DEVICE BINDING (kalau endpoint kamu ada)
  // =========================
  static Future<void> adminResetDevice(int userId) async {
    final res = await http.post(
      Uri.parse("$baseUrl/api/v1/admin/employees/$userId/reset-device"),
      headers: _headers(auth: true),
    );

    if (res.statusCode != 200) throw _err("adminResetDevice", res);
  }

  // =========================
  // EMPLOYEE: ME (optional)
  // kalau backend kamu punya endpoint profile /me
  // =========================
  static Future<Map<String, dynamic>> me() async {
    final res = await http.get(
      Uri.parse("$baseUrl/api/v1/auth/me"),
      headers: _headers(auth: true),
    );

    if (res.statusCode != 200) throw _err("me", res);
    return _decode(res);
  }
}
