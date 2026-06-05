import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'logging_service.dart';

class SecureStorageService {
  final Ref _ref;
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  SecureStorageService(this._ref);

  // Write securely
  Future<void> write(String key, String value) async {
    final log = _ref.read(loggerProvider);
    try {
      log.i("Securely writing key: $key");
      await _storage.write(key: key, value: value);
    } catch (e, stack) {
      log.e("Error writing secure storage for key: $key", e, stack);
    }
  }

  // Read securely
  Future<String?> read(String key) async {
    final log = _ref.read(loggerProvider);
    try {
      log.i("Securely reading key: $key");
      return await _storage.read(key: key);
    } catch (e, stack) {
      log.e("Error reading secure storage for key: $key", e, stack);
      return null;
    }
  }

  // Delete securely
  Future<void> delete(String key) async {
    final log = _ref.read(loggerProvider);
    try {
      log.i("Securely deleting key: $key");
      await _storage.delete(key: key);
    } catch (e, stack) {
      log.e("Error deleting secure storage for key: $key", e, stack);
    }
  }

  // Clear all
  Future<void> clearAll() async {
    final log = _ref.read(loggerProvider);
    try {
      log.i("Securely clearing all storage keys...");
      await _storage.deleteAll();
    } catch (e, stack) {
      log.e("Error clearing all secure storage", e, stack);
    }
  }
}

// Provider for SecureStorageService
final secureStorageServiceProvider = Provider<SecureStorageService>((ref) => SecureStorageService(ref));
