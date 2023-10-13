import 'package:clean_arch_course/core/utils/typedef.dart';

abstract class UseCaseWithParams<Type, Params> {
  const UseCaseWithParams();

  FutureResult<Type> call(Params params);
}

abstract class UseCase<Type> {
  const UseCase();

  FutureResult<Type> call();
}
