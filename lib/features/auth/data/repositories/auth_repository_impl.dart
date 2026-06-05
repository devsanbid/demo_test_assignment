import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharely/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:sharely/features/auth/data/models/auth_hive_model.dart';
import 'package:sharely/features/auth/domain/entities/auth_entity.dart';
import 'package:sharely/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final localDataSource = ref.watch(authLocalDatasourceProvider);
  return AuthRepositoryImpl(localDataSource: localDataSource);
});

class AuthRepositoryImpl implements IAuthRepository {
  final AuthLocalDatasource _localDataSource;

  AuthRepositoryImpl({required AuthLocalDatasource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<Either<String, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _localDataSource.getCurrentUser();
      if (user != null) {
        return Right(user.toEntity());
      } else {
        return const Left("User not found");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, AuthEntity>> login(String email, String password) async {
    try {
      final user = await _localDataSource.login(email, password);
      if (user != null) {
        return Right(user.toEntity());
      } else {
        return const Left("Invalid email or password");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> logout() async {
    try {
      final success = await _localDataSource.logout();
      return Right(success);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, bool>> register(AuthEntity entity) async {
    try {
      final isEmailExists = await _localDataSource.isEmailExists(entity.email);
      if (isEmailExists) {
        return const Left("Email already exists");
      }

      final model = AuthHiveModel.fromEntity(entity);
      final success = await _localDataSource.register(model);
      if (success) {
        return const Right(true);
      } else {
        return const Left("Failed to register user");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }
}
