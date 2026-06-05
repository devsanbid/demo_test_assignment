import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharely/core/services/storage/user_session_service.dart';

final userSharedPrefsProvider = Provider<UserSharedPrefs>((ref) {
  return UserSharedPrefs(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

class UserSharedPrefs {
  final SharedPreferences _sharedPreferences;

  UserSharedPrefs({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  // Set first time
  Future<Either<String, bool>> setFirstTime(bool isFirstTime) async {
    try {
      await _sharedPreferences.setBool('isFirstTime', isFirstTime);
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Get first time
  Future<Either<String, bool>> getFirstTime() async {
    try {
      final isFirstTime = _sharedPreferences.getBool('isFirstTime') ?? true;
      return Right(isFirstTime);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Set User token
  Future<Either<String, bool>> setUserToken(String token) async {
    try {
      await _sharedPreferences.setString('token', token);
      return const Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  // Get User token
  Future<Either<String, String?>> getUserToken() async {
    try {
      final token = _sharedPreferences.getString('token');
      return Right(token);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
