import 'package:dartz/dartz.dart';
import 'package:sharely/features/auth/domain/entities/auth_entity.dart';

abstract class IAuthRepository {
  Future<Either<String, AuthEntity>> login(String email, String password);
  Future<Either<String, bool>> register(AuthEntity entity);
  Future<Either<String, bool>> logout();
  Future<Either<String, AuthEntity>> getCurrentUser();
}
