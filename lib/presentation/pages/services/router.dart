import 'package:go_router/go_router.dart';
import 'package:project_firebase/presentation/pages/auth_page.dart';
import 'package:project_firebase/presentation/pages/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RouterPage {
  final GoRouter _route = GoRouter(routes: [
    GoRoute(name: 'home', path: '/', builder: (context, state) => AuthScreen()),
    GoRoute(
        name: 'chat', path: '/chat', builder: (context, state) => ChatScreen()),
  ]);
  getRouterPage() {
    return _route;
  }
}
