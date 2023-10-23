import 'package:clean_arch_course/src/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:clean_arch_course/src/authentication/data/repositories/authentication_repository_implementation.dart';
import 'package:clean_arch_course/src/authentication/domain/repositories/authentication_repository.dart';
import 'package:clean_arch_course/src/authentication/domain/usecases/create_user_usecase.dart';
import 'package:clean_arch_course/src/authentication/domain/usecases/get_users_usecase.dart';
import 'package:clean_arch_course/src/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:clean_arch_course/src/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerFactory(
      () => AuthenticationCubit(
        createUserUseCase: sl(),
        getUsersUseCase: sl(),
      ),
    )
    ..registerFactory(
      () => AuthenticationBloc(
        createUserUseCase: sl(),
        getUsersUseCase: sl(),
      ),
    )
    ..registerLazySingleton(() => CreateUserUseCase(sl()))
    ..registerLazySingleton(() => GetUsersUseCase(sl()))
    ..registerLazySingleton<AuthenticationRepository>(
        () => AuthenticationRepositoryImplementation(sl()))
    ..registerLazySingleton<AuthenticationRemoteDataSource>(
        () => AuthRemoteDataSrcImpl(sl()))
    ..registerLazySingleton(() => http.Client());
}
