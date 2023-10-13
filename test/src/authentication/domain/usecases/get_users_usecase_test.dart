import 'package:clean_arch_course/src/authentication/domain/entities/user.dart';
import 'package:clean_arch_course/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:clean_arch_course/src/authentication/domain/usecases/get_users_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.mock.dart';

void main() {
  late AuthenticationRepository repository;
  late GetUsersUseCase usecase;
  const tResponse = [User.empty()];

  setUp(() {
    repository = MockAuthRepo();
    usecase = GetUsersUseCase(repository);
  });

  test(
    'should call [AuthRepo.getUsers] and return [List<User>]',
    () async {
      // Arrange
      when(() {
        return repository.getUsers();
      }).thenAnswer((invocation) async {
        return const Right(tResponse);
      });

      // Act
      final result = await usecase.call();

      // Assert
      expect(result, equals(const Right(tResponse)));

      verify(() {
        repository.getUsers();
      }).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}
