import 'package:clean_arch_course/src/authentication/domain/entities/user.dart';
import 'package:clean_arch_course/src/authentication/domain/usecases/create_user_usecase.dart';
import 'package:clean_arch_course/src/authentication/domain/usecases/get_users_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit({
    required CreateUserUseCase createUserUseCase,
    required GetUsersUseCase getUsersUseCase,
  })  : _createUserUseCase = createUserUseCase,
        _getUsersUseCase = getUsersUseCase,
        super(const AuthenticationInitial());

  final CreateUserUseCase _createUserUseCase;
  final GetUsersUseCase _getUsersUseCase;

  /// Create User
  ///
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    emit(const CreatingUser());

    final result = await _createUserUseCase.call(
      CreateUserParams(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      ),
    );

    result.fold(
      // l is [APIFailure], failed
      (l) => emit(AuthenticationError(l.errorMessage)),
      // r is [void], success
      (r) => emit(const UserCreated()),
    );
  }

  /// Get Users
  ///
  Future<void> getUsers() async {
    emit(const GettingUsers());

    final result = await _getUsersUseCase.call();

    result.fold(
      // l is a [APIFailure], failed
      (l) => emit(AuthenticationError(l.errorMessage)),
      // r is a [List<User>], success
      (r) => emit(UsersLoaded(r)),
    );
  }
}
