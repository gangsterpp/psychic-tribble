import 'dart:async';
import 'dart:developer';

import 'package:b1c_test_app/bloc/image_generator_bloc.dart';
import 'package:b1c_test_app/bloc/storage_bloc.dart';
import 'package:b1c_test_app/core/router.dart';
import 'package:b1c_test_app/repository/image_generator_repository.dart';
import 'package:b1c_test_app/repository/storage_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runZonedGuarded(
    () {
      runApp(const MainApp());
    },
    (e, s) {
      log("Unknown error", error: e, stackTrace: s);
    },
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                ImageGeneratorBloc(ImageGeneratorRepositoryImpl(), ImageIdle()),
          ),
          BlocProvider(
            create: (_) =>
                StorageBloc(StorageRepositoryImpl(SharedPreferencesAsync())),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: appRouter,
          title: 'AI Image Generator',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6200EE),
              brightness: Brightness.light,
            ),
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              shadowColor: Colors.transparent,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                textStyle: WidgetStateProperty.all(
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}
