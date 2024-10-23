import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_harry_potter/data/datasources/character_remote_datasource.dart';
import 'package:flutter_harry_potter/data/datasources/login_fake_datasource.dart';
import 'package:flutter_harry_potter/data/repositories/character_repository_impl.dart';
import 'package:flutter_harry_potter/data/repositories/login_repository_impl.dart';
import 'package:flutter_harry_potter/domain/repositories/character_repository.dart';
import 'package:flutter_harry_potter/domain/repositories/login_repository.dart';
import 'package:flutter_harry_potter/domain/usecases/get_all_characters_usecase.dart';
import 'package:flutter_harry_potter/domain/usecases/login_user_usecase.dart';
import 'package:flutter_harry_potter/presentation/blocs/characters/characters_bloc.dart';
import 'package:flutter_harry_potter/presentation/blocs/login/login_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerLazySingleton(() => http.Client());

  final sharedPreferences = await SharedPreferences.getInstance();
  
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton<CharacterRemoteDataSource>(
    () => CharacterRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<LoginFakeDatasource>(
    () => LoginFakeDatasourceImpl(),
  );

  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton(() => GetAllCharacters(sl()));

  sl.registerLazySingleton(() => LoginUser(sl()));

  sl.registerFactory(() => CharacterBloc(sl()));

  sl.registerFactory(() => LoginBloc(sl(), sl()));
}
