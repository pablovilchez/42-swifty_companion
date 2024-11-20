import 'package:flutter/material.dart';

class UserAppBar extends StatelessWidget {
  const UserAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text('User Profile'),
          CircleAvatar(
            child: Text('User Photo'),
          ),
        ],
      ),
    );
  }
}
