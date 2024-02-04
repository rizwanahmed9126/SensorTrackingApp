import 'package:dartz/dartz.dart';
import '../../../commons/failure.dart';
import '../repositories/remote_local_repository.dart';

class RemoteTasks {
  final RemoteRepository repository;

  RemoteTasks(this.repository);

  Future<Either<Failure, bool>> execute(String body) {
    return repository.uploadLogs(body);
  }
}
