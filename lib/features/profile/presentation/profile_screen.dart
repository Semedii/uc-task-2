import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uc_task_2/core/theme/app_colors.dart';
import 'package:uc_task_2/features/auth/application/auth_notifier.dart';
import 'package:uc_task_2/features/profile/presentation/my_list_screen.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildUserInfo(),
            const SizedBox(height: 32),
            _buildMyListTile(context),
            const Divider(color: Colors.white24),
            _buildLogoutTile(ref),
          ],
        ),
      ),
    );
  }

  Column _buildUserInfo() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary,
          child: Icon(Icons.person, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'Welcome, User',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  ListTile _buildMyListTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.favorite_outline),
      title: const Text('My List', style: TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyListScreen()),
        );
      },
    );
  }

  ListTile _buildLogoutTile(WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
      onTap: () async {
        await ref.read(authNotifierProvider.notifier).logout();
      },
    );
  }
}
