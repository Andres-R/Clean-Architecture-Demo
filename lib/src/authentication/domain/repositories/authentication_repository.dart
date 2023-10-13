import 'package:clean_arch_course/core/utils/typedef.dart';
import 'package:clean_arch_course/src/authentication/domain/entities/user.dart';

abstract class AuthenticationRepository {
  const AuthenticationRepository();

  FutureVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  FutureResult<List<User>> getUsers();
}
