import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uc_task_2/core/theme/app_theme.dart';
import 'package:uc_task_2/features/auth/application/auth_notifier.dart';
import 'package:uc_task_2/features/auth/domain/auth_state.dart';
import 'package:uc_task_2/features/auth/presentation/login_screen.dart';
import 'package:uc_task_2/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  await Hive.openBox<int>('favorites');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return MaterialApp(
      title: 'UniqCast',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      darkTheme: buildAppTheme(),
      themeMode: ThemeMode.dark,
      home: authState.when(
        data: (state) => state.maybeWhen(
          authenticated: (_) => MainScreen(),
          orElse: () => const LoginScreen(),
        ),
        loading: () => Container(), //TODO: loading screen
        error: (err, st) => Container(), //TODO: error Screen
      ),
    );
  }
}
