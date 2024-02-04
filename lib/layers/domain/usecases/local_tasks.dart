import 'package:dartz/dartz.dart';
import '../../../commons/failure.dart';
import '../../data/models/log_model.dart';
import '../repositories/remote_local_repository.dart';

class LocalTasks {
  final LocalRepository repository;

  LocalTasks(this.repository);

  Future<Either<Failure, LogModel>> getAndSaveLogLocal() {
    return repository.getAndSaveLogLocal();
  }

  Future<Either<Failure, String>> showLogs() {
    return repository.showLogs();
  }

  Future<Either<Failure, void>> deleteLogs(List<int> ids) {
    return repository.deleteLog(ids);
  }
}
