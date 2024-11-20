import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:swiftycompanion/application/providers/auth_provider.dart';
import 'package:swiftycompanion/application/providers/user_provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final TextEditingController loginController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Search 42 user'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
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
              SizedBox(
                width: 250,
                child: TextField(
                  controller: loginController,
                  style: const TextStyle(fontSize: 18),
                  maxLength: 20,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    hintText: 'Enter login',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              userProvider.isSearching
                  ? const CircularProgressIndicator()
                  : Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 40),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
                          onPressed: () async {
                            final login = loginController.text.trim();
                            print('*** EVAL used token: ${await authProvider.getToken}');
                            if (login.isNotEmpty) {
                              await userProvider.loadUser(login, authProvider);
                              if (context.mounted) {
                                loginController.text = login;
                                if (userProvider.errorMessage.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        userProvider.errorMessage,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red.shade400,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  Navigator.pushNamed(context, '/profile');
                                }
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Please enter a login',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red.shade400,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: const Text('Search'),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            await userProvider.loadUser('me', authProvider);
                            if (context.mounted) {
                              Navigator.pushNamed(context, '/profile');
                            }
                          },
                          child: const Text('My profile'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> _showLogoutDialog(BuildContext context) async {
  final oauth2Helper = Provider.of<AuthProvider>(context, listen: false);
  return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  await oauth2Helper.logout(context);
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/login', (route) => false);
                  }
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}
