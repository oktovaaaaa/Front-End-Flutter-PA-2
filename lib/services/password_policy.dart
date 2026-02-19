class PasswordPolicy {
  static String? validate(String pw) {
    if (pw.length < 8) return "Password minimal 8 karakter.";
    if (!RegExp(r'[a-z]').hasMatch(pw)) return "Password wajib punya huruf kecil (a-z).";
    if (!RegExp(r'[A-Z]').hasMatch(pw)) return "Password wajib punya huruf besar (A-Z).";
    if (!RegExp(r'\d').hasMatch(pw)) return "Password wajib punya angka (0-9).";
    if (!RegExp(r'[!@#\$%\^&\*\(\)_\+\-=\[\]{};:"\\|,.<>\/\?`~]').hasMatch(pw)) {
      return "Password wajib punya karakter spesial (contoh: !@#).";
    }
    return null;
  }
}
