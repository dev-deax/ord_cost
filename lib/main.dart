import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ord_cost/app/router/app_router.dart';
import 'package:ord_cost/app/theme/app_theme.dart';

void main() {
  runApp(
    const ProviderScope(
      child: OrdaCostApp(),
    ),
  );
}

class OrdaCostApp extends StatelessWidget {
  const OrdaCostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OrdaCost',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}
