import 'package:flutter_harry_potter/data/datasources/login_fake_datasource.dart';
import 'package:flutter_harry_potter/data/models/user_model.dart';
import 'package:flutter_harry_potter/domain/entities/user.dart';
import 'package:flutter_harry_potter/domain/repositories/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dartz/dartz.dart';

class LoginRepositoryImpl implements LoginRepository {
 final SharedPreferences sharedPreferences;
 final LoginFakeDatasource loginFakeDatasource;

 LoginRepositoryImpl(this.sharedPreferences, this.loginFakeDatasource);

 @override
 Future<Either<Exception, User>> login(String email, String password) async {
   try {
     UserModel usuario = await loginFakeDatasource.getValidUser(email, password);
     final user = User(email: usuario.email, token: 'random_token');
     await sharedPreferences.setString('token', user.token);
     await sharedPreferences.setString('email', user.email);
     return Right(user);
   } catch (e) {
     return Left(Exception('Credenciales incorrectas'));
   }
 }

 @override
 Future<Either<Exception, bool>> isLoggedIn() async {
   try {
     final token = sharedPreferences.getString('token');
     return Right(token != null);
   } catch (e) {
     return Left(Exception("Error al verificar si el usuario está logueado: $e"));
   }
 }

 @override
 Future<void> logout() async {
   await sharedPreferences.remove('token');
   await sharedPreferences.remove('email');
 }
}