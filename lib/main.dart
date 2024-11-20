import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swiftycompanion/presentation/pages/login_page.dart';
import 'package:swiftycompanion/presentation/pages/profile_page.dart';
import 'package:swiftycompanion/presentation/pages/search_page.dart';
import 'package:provider/provider.dart';

import 'application/providers/auth_provider.dart';
import 'application/providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'assets/.env');
  final AuthProvider authProvider = AuthProvider();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => authProvider),
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swifty Companion',
      theme: ThemeData.dark(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(
          authProvider: Provider.of<AuthProvider>(context, listen: false),
        ),
        '/search': (context) => const SearchPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
