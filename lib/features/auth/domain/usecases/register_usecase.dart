import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sharely/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sharely/features/auth/domain/entities/auth_entity.dart';
import 'package:sharely/features/auth/domain/repositories/auth_repository.dart';

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(repository: ref.watch(authRepositoryProvider));
});

class RegisterUseCase {
  final IAuthRepository _repository;

  RegisterUseCase({required IAuthRepository repository}) : _repository = repository;

  Future<Either<String, bool>> call(AuthEntity entity) {
    return _repository.register(entity);
  }
}
