import 'package:flutter/material.dart';

import 'package:uc_task_2/core/theme/app_colors.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80),
            const SizedBox(height: 24),
            _buildErrorText(context),
            const SizedBox(height: 16),
            _buildMessageText(context),
            const SizedBox(height: 32),
            _buildRetryButton(),
          ],
        ),
      ),
    );
  }

  Text _buildErrorText(BuildContext context) {
    return Text(
      'Something went wrong',
      style: TextTheme.of(context).titleLarge,
      textAlign: TextAlign.center,
    );
  }

  Text _buildMessageText(BuildContext context) {
    return Text(
      message,
      style: TextTheme.of(
        context,
      ).bodyLarge?.copyWith(color: AppColors.textSecondary),
      textAlign: TextAlign.center,
    );
  }

  ElevatedButton _buildRetryButton() {
    return ElevatedButton.icon(
      onPressed: onRetry,
      icon: const Icon(Icons.refresh),
      label: const Text('Retry'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }
}
