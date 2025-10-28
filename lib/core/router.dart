import 'package:b1c_test_app/features/promt_screen.dart';
import 'package:b1c_test_app/features/result_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: PromtScreen.path,
      builder: (_, _) => const PromtScreen(),

      routes: [
        GoRoute(
          path: ResultScreen.path,
          builder: (_, _) => const ResultScreen(),
        ),
      ],
    ),
  ],
);
