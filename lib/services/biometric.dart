import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticateForAttendance() async {
    final canCheck = await _auth.canCheckBiometrics;
    final supported = await _auth.isDeviceSupported();
    if (!canCheck || !supported) return false;

    try {
      return await _auth.authenticate(
        localizedReason: 'Verifikasi biometrik untuk absensi',
        options: const AuthenticationOptions(
          biometricOnly: false, // allow PIN/Pattern/Password fallback if enabled by OS
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
