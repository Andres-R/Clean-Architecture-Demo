import 'dart:convert';

import 'package:clean_arch_course/core/errors/exceptions.dart';
import 'package:clean_arch_course/core/utils/constants.dart';
import 'package:clean_arch_course/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:clean_arch_course/src/authentication/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late AuthenticationRemoteDataSource remoteDataSource;

  setUp(() {
    client = MockClient();
    remoteDataSource = AuthRemoteDataSrcImpl(client);
    // registerFallbackValue is for client.post(any(), body...)
    // since we want to treat any() as a Uri here and not a string
    registerFallbackValue(Uri());
  });

  group(
    'createUser',
    () {
      test(
        'should complete successfully when the status code is 200 or 201',
        () async {
          // Arrange
          when(() {
            return client.post(any(), body: any(named: 'body'));
          }).thenAnswer((invocation) async {
            return http.Response('User created successfully', 201);
          });

          // Act
          final methodCall = remoteDataSource.createUser;

          // Assert
          // this is written this way because creater user return void, so there
          // is no expected result to compare to
          expect(
            methodCall(
              createdAt: 'createdAt',
              name: 'name',
              avatar: 'avatar',
            ),
            completes,
          );

          verify(() {
            return client.post(
              Uri.parse('$kBaseUrl/$kCreateUserEndpoint'),
              //Uri.https(kBaseUrl, kCreateUserEndpoint),
              body: jsonEncode({
                'createdAt': 'createdAt',
                'name': 'name',
                'avatar': 'avatar',
              }),
            );
          }).called(1);

          verifyNoMoreInteractions(client);
        },
      );
      test(
        'should throw [APIException] when the status code is not 200 or 201',
        () async {
          // Arrange
          when(() {
            return client.post(any(), body: any(named: 'body'));
          }).thenAnswer((invocation) async {
            return http.Response('Invalid email address', 400);
          });

          // Act
          final methodCall = remoteDataSource.createUser;

          // Assert
          expect(
            () async {
              return methodCall(
                createdAt: 'createdAt',
                name: 'name',
                avatar: 'avatar',
              );
            },
            throwsA(
              const APIException(
                message: 'Invalid email address',
                statusCode: 400,
              ),
            ),
          );

          verify(() {
            return client.post(
              Uri.parse('$kBaseUrl/$kCreateUserEndpoint'),
              //Uri.https(kBaseUrl, kCreateUserEndpoint),
              body: jsonEncode({
                'createdAt': 'createdAt',
                'name': 'name',
                'avatar': 'avatar',
              }),
            );
          }).called(1);

          verifyNoMoreInteractions(client);
        },
      );
    },
  );

  group('getUsers', () {
    const tUsers = [UserModel.empty()];
    test(
      'should return [List<User>] when the status code is 200',
      () async {
        // Arrange
        when(() {
          return client.get(any());
        }).thenAnswer((invocation) async {
          return http.Response(jsonEncode([tUsers.first.toMap()]), 200);
        });

        // Act
        final result = await remoteDataSource.getUsers();

        // Assert
        expect(result, equals(tUsers));

        verify(() {
          return client.get(Uri.https(kBaseUrl, kGetUsersEndpoint));
        }).called(1);

        verifyNoMoreInteractions(client);
      },
    );

    test(
      'should throw [APIException] when the status code is not 200',
      () async {
        const tMessage = 'Server down';

        // Arrange
        when(() {
          return client.get(any());
        }).thenAnswer((invocation) async {
          return http.Response(tMessage, 500);
        });

        // Act
        final methodCall = remoteDataSource.getUsers;

        // Assert
        // make sure higher order function calls methodCall and throws exception
        expect(
          methodCall,
          throwsA(
            const APIException(message: tMessage, statusCode: 500),
          ),
        );

        verify(() {
          return client.get(Uri.https(kBaseUrl, kGetUsersEndpoint));
        }).called(1);

        verifyNoMoreInteractions(client);
      },
    );
  });
}
