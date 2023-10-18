import 'package:bloc_test/bloc_test.dart';
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
      // act: (bloc) => bloc.add(CreateUserEvent(createdAt: 'createdAt', name: 'name', avatar: 'avatar',))
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
  });
}
