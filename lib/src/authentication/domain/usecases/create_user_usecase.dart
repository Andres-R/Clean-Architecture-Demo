import 'package:clean_arch_course/core/usecase/usecase.dart';
import 'package:clean_arch_course/core/utils/typedef.dart';
import 'package:clean_arch_course/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';

class CreateUserUseCase extends UseCaseWithParams<void, CreateUserParams> {
  const CreateUserUseCase(this._repository);

  final AuthenticationRepository _repository;

  @override
  FutureVoid call(CreateUserParams params) async {
    return _repository.createUser(
      createdAt: params.createdAt,
      name: params.name,
      avatar: params.avatar,
    );
  }
}

class CreateUserParams extends Equatable {
  const CreateUserParams({
    required this.createdAt,
    required this.name,
    required this.avatar,
  });

  const CreateUserParams.empty()
      : this(
          createdAt: 'empty.createdAt',
          name: 'empty.name',
          avatar: 'empty.avatar',
        );

  final String createdAt;
  final String name;
  final String avatar;

  @override
  List<Object?> get props => [createdAt, name, avatar];
}
