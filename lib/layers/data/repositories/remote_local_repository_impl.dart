import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../commons/exception.dart';
import '../../../commons/failure.dart';
import '../../domain/repositories/remote_local_repository.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/log_model.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final RemoteDataSource remoteDataSource;

  RemoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, bool>> uploadLogs(String body) async {
    try {
      final result = await remoteDataSource.uploadLogs(body);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}

class LocalRepositoryImpl implements LocalRepository {
  final LocalDataSource localDataSource;

  LocalRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, LogModel>> getAndSaveLogLocal() async {
    try {
      final result = await localDataSource.getAndSaveLogLocal();
      return Right(result);
    } on DataBaseException {
      return const Left(ServerFailure('Failed to connect'));
    }
  }

  @override
  Future<Either<Failure, String>> showLogs() async {
    try {
      final result = await localDataSource.showLogs();
      return Right(result);
    } on DataBaseException {
      return const Left(ServerFailure('Failed to connect'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteLog(List<int> ids) async {
    try {
      final result = await localDataSource.deleteLog(ids);
      return Right(result);
    } on DataBaseException {
      return const Left(ServerFailure('Failed to connect'));
    }
  }
}
