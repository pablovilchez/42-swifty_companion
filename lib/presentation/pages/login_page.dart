import 'package:flutter/material.dart';

import 'package:swiftycompanion/application/providers/auth_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required this.authProvider});
  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swifty Companion'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/green_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 50),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  final token = await authProvider.getToken;
                  if(context.mounted && token != null) {
                    Navigator.pushReplacementNamed(context, '/search');
                  }
                },
                child: const Text('Login with 42')),
            ],
          ),
        ),
      ),
    );
  }
}
