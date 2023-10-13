import 'package:clean_arch_course/core/errors/exceptions.dart';
import 'package:clean_arch_course/core/errors/failure.dart';
import 'package:clean_arch_course/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:clean_arch_course/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:clean_arch_course/src/authentication/domain/entities/user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRemoteDatasource extends Mock
    implements AuthenticationRemoteDataSource {}

void main() {
  late AuthenticationRemoteDataSource remoteDataSource;
  late AuthenticationRepositoryImplementation repoImpl;

  const String createdAt = 'whatever.createdAt';
  const String name = 'whatever.name';
  const String avatar = 'whatever.avatar';

  const tException = APIException(
    message: 'Unknown Error Occurred',
    statusCode: 500,
  );

  setUp(() {
    remoteDataSource = MockAuthRemoteDatasource();
    repoImpl = AuthenticationRepositoryImplementation(remoteDataSource);
  });

  group('createUser', () {
    test(
      'should call the [RemoteDataSource.createUser] and complete successfully when the call to the remote source is successful',
      () async {
        // Arrange
        when(() {
          return remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          );
        }).thenAnswer((invocation) async {
          // This is how you return void
          return Future.value();
        });

        // Act
        final result = await repoImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        // Assert
        // This is how you expect a 'Right(void)'
        expect(result, const Right(null));
        verify(() {
          return remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          );
        }).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return an [APIFailure] when the call to the remote source is unsuccessful',
      () async {
        // Arrange
        when(() {
          return remoteDataSource.createUser(
            createdAt: any(named: 'createdAt'),
            name: any(named: 'name'),
            avatar: any(named: 'avatar'),
          );
        }).thenThrow(tException);

        // Act
        final result = await repoImpl.createUser(
          createdAt: createdAt,
          name: name,
          avatar: avatar,
        );

        // Assert
        expect(
            result,
            equals(
              Left(
                APIFailure(
                  message: tException.message,
                  statusCode: tException.statusCode,
                ),
              ),
            ));
        verify(() {
          return remoteDataSource.createUser(
            createdAt: createdAt,
            name: name,
            avatar: avatar,
          );
        }).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });

  group('getUsers', () {
    test(
      'should call the [RemoteDataSource.getUsers] and return [List<User>] when call to remote source is successful',
      () async {
        // Arrange
        when(() {
          return remoteDataSource.getUsers();
        }).thenAnswer((invocation) async {
          return [];
        });

        // Act
        final result = await repoImpl.getUsers();

        // Assert
        expect(result, isA<Right<dynamic, List<User>>>());
        verify(() {
          return remoteDataSource.getUsers();
        }).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should return a [APIFailure] when the call to the remote source is unsuccessful',
      () async {
        // Arrange
        when(() {
          return remoteDataSource.getUsers();
        }).thenThrow(tException);

        // Act
        final result = await repoImpl.getUsers();

        // Assert
        expect(result, equals(Left(APIFailure.fromException(tException))));
        verify(() {
          return remoteDataSource.getUsers();
        }).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
