import 'package:bloc_test/bloc_test.dart';
import 'package:clean_arch_course/core/errors/failure.dart';
import 'package:clean_arch_course/src/authentication/domain/usecases/create_user_usecase.dart';
import 'package:clean_arch_course/src/authentication/domain/usecases/get_users_usecase.dart';
import 'package:clean_arch_course/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetUsersUseCase extends Mock implements GetUsersUseCase {}

class MockCreateUserUseCase extends Mock implements CreateUserUseCase {}

void main() {
  late GetUsersUseCase getUsersUseCase;
  late CreateUserUseCase createUserUseCase;
  late AuthenticationCubit cubit;

  const tCreateUserParams = CreateUserParams.empty();
  const tAPIFailure = APIFailure(message: 'message', statusCode: 400);

  setUp(() {
    getUsersUseCase = MockGetUsersUseCase();
    createUserUseCase = MockCreateUserUseCase();
    cubit = AuthenticationCubit(
      createUserUseCase: createUserUseCase,
      getUsersUseCase: getUsersUseCase,
    );
    registerFallbackValue(tCreateUserParams);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be [AuthenticationInitial]', () async {
    expect(cubit.state, const AuthenticationInitial());
  });

  group('createUser', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreatingUser, UserCreated] when successful',
      build: () {
        when(() {
          // any() only works because of registerFallbackValue(tCreateUserParams);
          return createUserUseCase.call(any());
        }).thenAnswer((invocation) async {
          return const Right(null);
        });
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => const [
        CreatingUser(),
        UserCreated(),
      ],
      verify: (cubit) {
        verify(() => createUserUseCase.call(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUserUseCase);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [CreartingUser, AuthenticationError] when unsuccessful',
      build: () {
        when(() {
          return createUserUseCase.call(any());
        }).thenAnswer((invocation) async {
          return const Left(tAPIFailure);
        });
        return cubit;
      },
      act: (cubit) => cubit.createUser(
        createdAt: tCreateUserParams.createdAt,
        name: tCreateUserParams.name,
        avatar: tCreateUserParams.avatar,
      ),
      expect: () => [
        const CreatingUser(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (cubit) {
        verify(() => createUserUseCase.call(tCreateUserParams)).called(1);
        verifyNoMoreInteractions(createUserUseCase);
      },
    );
  });

  group('getUsers', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, UsersLoaded] when successful',
      build: () {
        when(() {
          return getUsersUseCase.call();
        }).thenAnswer((invocation) async {
          return const Right([]);
        });
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => const [
        GettingUsers(),
        UsersLoaded([]),
      ],
      verify: (cubit) {
        verify(() => getUsersUseCase.call()).called(1);
        verifyNoMoreInteractions(getUsersUseCase);
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [GettingUsers, AuthenticationError] when unsuccessful',
      build: () {
        when(() {
          return getUsersUseCase.call();
        }).thenAnswer((invocation) async {
          return const Left(tAPIFailure);
        });
        return cubit;
      },
      act: (cubit) => cubit.getUsers(),
      expect: () => [
        const GettingUsers(),
        AuthenticationError(tAPIFailure.errorMessage),
      ],
      verify: (cubit) {
        verify(() => getUsersUseCase.call()).called(1);
        verifyNoMoreInteractions(getUsersUseCase);
      },
    );
  });
}
