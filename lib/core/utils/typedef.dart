import 'package:clean_arch_course/core/errors/failure.dart';
import 'package:dartz/dartz.dart';

typedef FutureResult<T> = Future<Either<Failure, T>>;

typedef FutureVoid = Future<Either<Failure, void>>;

typedef DataMap = Map<String, dynamic>;
