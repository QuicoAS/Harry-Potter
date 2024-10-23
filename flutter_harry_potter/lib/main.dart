import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_harry_potter/presentation/blocs/characters/characters_bloc.dart';
import 'package:flutter_harry_potter/presentation/screen/characters_screen.dart';
import 'package:flutter_harry_potter/presentation/screen/login_screen.dart';
import 'package:flutter_harry_potter/presentation/blocs/login/login_bloc.dart';
import 'package:flutter_harry_potter/domain/repositories/login_repository.dart';
import 'package:flutter_harry_potter/presentation/blocs/theme/theme_bloc.dart';
import 'package:flutter_harry_potter/presentation/blocs/theme/theme_state.dart';

import 'package:go_router/go_router.dart';
import 'injection_container.dart' as injection_container;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injection_container.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => BlocProvider(
          create: (context) => injection_container.sl<LoginBloc>(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => injection_container.sl<CharacterBloc>(),
            ),
            BlocProvider(
              create: (context) => injection_container.sl<LoginBloc>(),
            ),
          ],
          child: const CharactersScreen(),
        ),
      ),
    ],
    redirect: (context, state) async {
      final isLoggedIn =
          await injection_container.sl<LoginRepository>().isLoggedIn();
      return isLoggedIn.fold(
        (_) => '/login',
        (loggedIn) {
          if (!loggedIn && state.matchedLocation != '/login') {
            return '/login';
          }
          return null;
        },
      );
    },
  );
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            theme: themeState.themeData,
            routerConfig: _router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
