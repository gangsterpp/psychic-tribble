import 'package:shared_preferences/shared_preferences.dart';

abstract interface class StorageRepository {
  Future<String?> read(String key);
  Future<List<String>> readAll();
  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

class StorageRepositoryImpl implements StorageRepository {
  final SharedPreferencesAsync _prefs;

  const StorageRepositoryImpl(this._prefs);

  @override
  Future<String?> read(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<void> write(String key, String value) {
    return _prefs.setString(key, value);
  }

  @override
  Future<void> delete(String key) {
    return _prefs.remove(key);
  }

  @override
  Future<List<String>> readAll() async {
    final keys = await _prefs.getKeys();
    final result = <String>[];
    for (final key in keys) {
      final promt = await _prefs.getString(key);
      if (promt == null) continue;
      result.add(promt);
    }
    return result;
  }
}
