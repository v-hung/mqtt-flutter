import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mqtt/pages/home2.dart';
import 'package:mqtt/providers/router_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget  {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Mqtt demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
      ),
      // darkTheme: ThemeData.dark(),
      // themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      // routeInformationParser: router.routeInformationParser,
      // routerDelegate: router.routerDelegate,
      routerConfig: router,
    );
  }
}