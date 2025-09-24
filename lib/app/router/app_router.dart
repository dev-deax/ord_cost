import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ord_cost/app/router/nav_shell.dart';
import 'package:ord_cost/features/costeo/presentation/pages/home_page.dart';
import 'package:ord_cost/features/costeo/presentation/pages/orders_page.dart';
import 'package:ord_cost/features/costeo/presentation/pages/params_page.dart';
import 'package:ord_cost/features/costeo/presentation/pages/results_page.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => NavShell(child: child),
      routes: [
        GoRoute(
          path: '/orders',
          builder: (context, state) => const OrdersPage(),
        ),
        GoRoute(
          path: '/params',
          builder: (context, state) => const ParamsPage(),
        ),
        GoRoute(
          path: '/results',
          builder: (context, state) => const ResultsPage(),
        ),
      ],
    ),
  ],
);
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();
