import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import 'layers/data/datasources/local_data_source.dart';
import 'layers/data/datasources/remote_data_source.dart';
import 'layers/data/repositories/remote_local_repository_impl.dart';
import 'layers/domain/repositories/remote_local_repository.dart';
import 'layers/domain/usecases/remote_tasks.dart';
import 'layers/domain/usecases/local_tasks.dart';
import 'layers/presentation/notifiers/home_provider.dart';

final locator = GetIt.instance;

void init() {

  //provider
  locator.registerFactory(() => HomeProvider(localStorageTasks: locator(),remoteTasks: locator(),));

  // usecase
  locator.registerLazySingleton(() => LocalTasks(locator()));
  locator.registerLazySingleton(() => RemoteTasks(locator()));

  // repository
  locator.registerLazySingleton<RemoteRepository>(() => RemoteRepositoryImpl(remoteDataSource: locator(),),);
  locator.registerLazySingleton<LocalRepository>(() => LocalRepositoryImpl(localDataSource: locator(),),);

  // data source
  locator.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(client: locator(),),);
  locator.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImp(),);

  // external
  locator.registerLazySingleton(() => http.Client());
}
