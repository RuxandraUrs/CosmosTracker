import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import 'constants.dart';
import '../data/datasources/iss_remote_data_source.dart';
import '../data/datasources/iss_local_data_source.dart';
import '../domain/repositories/iss_repository.dart';
import '../data/repositories/iss_repository_impl.dart';
import '../presentation/bloc/iss_cubit.dart';
import '../presentation/bloc/favorites_cubit.dart';
import '../presentation/bloc/apod_cubit.dart'; // <--- Import Nou

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton<IssRemoteDataSource>(
    () => IssRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<IssLocalDataSource>(
    () => IssLocalDataSourceImpl(box: Hive.box(AppConstants.favoritesBox)),
  );

  sl.registerLazySingleton<IssRepository>(
    () => IssRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerFactory(() => IssCubit(repository: sl()));
  sl.registerFactory(() => FavoritesCubit(repository: sl()));
  
  sl.registerFactory(() => ApodCubit(repository: sl()));
}