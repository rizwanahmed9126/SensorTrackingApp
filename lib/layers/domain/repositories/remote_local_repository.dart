import 'package:dartz/dartz.dart';
import '../../../commons/failure.dart';
import '../../data/models/log_model.dart';

abstract class RemoteRepository {
  Future<Either<Failure, bool>> uploadLogs(String body);
}

abstract class LocalRepository {
  Future<Either<Failure, LogModel>> getAndSaveLogLocal();

  Future<Either<Failure, String>> showLogs();

  Future<Either<Failure, void>> deleteLog(List<int> ids);
}
