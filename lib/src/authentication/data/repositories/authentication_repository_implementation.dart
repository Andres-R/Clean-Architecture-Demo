import 'package:clean_arch_course/core/errors/exceptions.dart';
import 'package:clean_arch_course/core/errors/failure.dart';
import 'package:clean_arch_course/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:clean_arch_course/src/authentication/data/models/user_model.dart';
import 'package:clean_arch_course/src/authentication/domain/entities/user.dart';
import 'package:clean_arch_course/core/utils/typedef.dart';
import 'package:clean_arch_course/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:dartz/dartz.dart';

class AuthenticationRepositoryImplementation
    implements AuthenticationRepository {
  const AuthenticationRepositoryImplementation(this._remoteDataSource);

  final AuthenticationRemoteDataSource _remoteDataSource;

  @override
  FutureVoid createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    try {
      await _remoteDataSource.createUser(
        createdAt: createdAt,
        name: name,
        avatar: avatar,
      );
      // If return type is void, always return a Right(null)

      return const Right(null);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }

  @override
  FutureResult<List<User>> getUsers() async {
    try {
      final result = await _remoteDataSource.getUsers();
      return Right(result);
    } on APIException catch (e) {
      return Left(APIFailure.fromException(e));
    }
  }
}
