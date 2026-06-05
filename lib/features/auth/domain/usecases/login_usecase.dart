import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharely/core/error/failures.dart';
import 'package:sharely/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sharely/features/auth/domain/entities/auth_entity.dart';
import 'package:sharely/features/auth/domain/repositories/auth_repository.dart';

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(repository: ref.watch(authRepositoryProvider));
});

class LoginUseCase {
  final IAuthRepository _repository;

  LoginUseCase({required IAuthRepository repository}) : _repository = repository;

  Future<Either<Failure, AuthEntity>> call(String email, String password) {
    return _repository.login(email, password);
  }
}
