import 'package:dartz/dartz.dart';

abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}


abstract class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}


class NoParams {}


abstract class Failure{
  final String message;
  const Failure(this.message);
}


class ServerFailure extends Failure{
  const ServerFailure(super.message);
}

class CacheFailure extends Failure{
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super("No Internet connection");
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure() : super("Unexpected error occurred");
}