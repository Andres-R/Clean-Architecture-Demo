import 'package:clean_arch_course/core/usecase/usecase.dart';
import 'package:clean_arch_course/core/utils/typedef.dart';
import 'package:clean_arch_course/src/authentication/domain/entities/user.dart';
import 'package:clean_arch_course/src/authentication/domain/repositories/authentication_repository.dart';

class GetUsersUseCase extends UseCase<List<User>> {
  const GetUsersUseCase(this._repository);

  final AuthenticationRepository _repository;

  @override
  FutureResult<List<User>> call() async {
    return _repository.getUsers();
  }
}
