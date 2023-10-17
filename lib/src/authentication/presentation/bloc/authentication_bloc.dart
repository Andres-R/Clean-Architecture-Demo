import 'package:clean_arch_course/src/authentication/domain/entities/user.dart';
import 'package:clean_arch_course/src/authentication/domain/usecases/create_user_usecase.dart';
import 'package:clean_arch_course/src/authentication/domain/usecases/get_users_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required CreateUserUseCase createUserUseCase,
    required GetUsersUseCase getUsersUseCase,
  })  : _createUserUseCase = createUserUseCase,
        _getUsersUseCase = getUsersUseCase,
        super(const AuthenticationInitial()) {
    on<CreateUserEvent>(_createUserHandler);
    on<GetUsersEvent>(_getUsersHandler);
  }

  final CreateUserUseCase _createUserUseCase;
  final GetUsersUseCase _getUsersUseCase;

  /// Create User
  ///
  Future<void> _createUserHandler(
    CreateUserEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const CreatingUser());

    final result = await _createUserUseCase.call(
      CreateUserParams(
        createdAt: event.createdAt,
        name: event.name,
        avatar: event.avatar,
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
  Future<void> _getUsersHandler(
    GetUsersEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
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
