import 'package:clean_arch_course/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:clean_arch_course/src/authentication/domain/usecases/create_user_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'authentication_repository.mock.dart';

void main() {
  late CreateUserUseCase usecase;
  late AuthenticationRepository repository;
  const CreateUserParams params = CreateUserParams.empty();

  setUp(() {
    repository = MockAuthRepo();
    usecase = CreateUserUseCase(repository);
  });

  test(
    'should call the [MockAuthRepo.createUser] ',
    () async {
      // Arrage
      when(() {
        return repository.createUser(
          createdAt: any(named: 'createdAt'),
          name: any(named: 'name'),
          avatar: any(named: 'avatar'),
        );
      }).thenAnswer((invocation) async {
        return const Right(null);
      });

      // Act
      final result = await usecase.call(params);

      // Assert
      expect(result, const Right(null));
      verify(() {
        repository.createUser(
          createdAt: params.createdAt,
          name: params.name,
          avatar: params.avatar,
        );
      }).called(1);

      verifyNoMoreInteractions(repository);
    },
  );
}
