import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mqtt/pages/camera_page.dart';
import 'package:mqtt/pages/home_page.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // _ref.listen(authProvider, 
    // (_, __) => notifyListeners());
  }

  // String? _redirect_login(_, GoRouterState state) {
  //   final authSate = _ref.read(authProvider).authSate;
    
  //   if (authSate == AuthSate.initial) return null;

  //   final are_we_loggin_in = state.location == "/login";

  //   if (authSate != AuthSate.login) {
  //     if (state.location == '/loading') {

  //     }
  //     return are_we_loggin_in ? null : '/login';
  //   }

  //   if (are_we_loggin_in || state.location == '/loading') return '/';

  //   return null;    
  // }

  List<RouteBase> get _routers => [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      name: 'camera',
      path: '/camera',
      builder: (context, state) => const CameraPage(),
    ),
  ];
}

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    refreshListenable: router,
    // redirect: router._redirect_login,
    routes: router._routers
  );
});