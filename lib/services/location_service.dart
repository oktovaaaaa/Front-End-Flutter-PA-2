import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position> getCurrentPosition() async {
    // 1) service location ON?
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location service OFF. Aktifkan lokasi di emulator/HP.");
    }

    // 2) permission
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw Exception("Izin lokasi ditolak.");
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception("Izin lokasi ditolak permanen. Buka Settings dan aktifkan.");
    }

    // 3) ambil lokasi
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
