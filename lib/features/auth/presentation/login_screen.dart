import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uc_task_2/core/theme/app_colors.dart';
import 'package:uc_task_2/features/auth/application/auth_notifier.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final authError = authState.error?.toString() ?? '';

    final usernameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final usernameFocus = useFocusNode();
    final passwordFocus = useFocusNode();

    final usernameError = useState<String?>(null);
    final passwordError = useState<String?>(null);

    Future<void> submit() async {
      usernameError.value = null;
      passwordError.value = null;

      if (!formKey.currentState!.validate()) return;

      final username = usernameController.text.trim();
      final password = passwordController.text.trim();

      await ref.read(authNotifierProvider.notifier).login(username, password);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(theme),
                    const SizedBox(height: 48),
                    _buildUsernameField(
                      usernameController,
                      usernameFocus,
                      passwordFocus,
                      usernameError,
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      passwordController,
                      passwordFocus,
                      passwordError,
                      submit,
                    ),
                    const SizedBox(height: 24),
                    if (authError.isNotEmpty) _buildErrorMessage(authError),
                    _buildLoginButton(isLoading, submit),
                    const SizedBox(height: 24),
                    _buildForgotPasswordButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        _buildHeaderIcon(),
        const SizedBox(height: 16),
        _buildHeaderTitle(theme),
        const SizedBox(height: 8),
        _buildHeaderSubtitle(theme),
      ],
    );
  }

  Icon _buildHeaderIcon() {
    return const Icon(Icons.movie_creation_rounded, size: 80);
  }

  Text _buildHeaderTitle(ThemeData theme) {
    return Text(
      'Welcome Back',
      style: theme.textTheme.headlineMedium,
      textAlign: TextAlign.center,
    );
  }

  Text _buildHeaderSubtitle(ThemeData theme) {
    return Text(
      'Sign in to continue',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: AppColors.textSecondary,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUsernameField(
    TextEditingController controller,
    FocusNode usernameFocus,
    FocusNode passwordFocus,
    ValueNotifier<String?> usernameError,
  ) {
    return TextFormField(
      controller: controller,
      focusNode: usernameFocus,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) => passwordFocus.requestFocus(),
      decoration: InputDecoration(
        labelText: 'Username',
        prefixIcon: const Icon(Icons.person),
      ),
      validator: (v) =>
          v?.trim().isEmpty ?? true ? 'Username is required' : null,
    );
  }

  Widget _buildPasswordField(
    TextEditingController controller,
    FocusNode focus,
    ValueNotifier<String?> error,
    VoidCallback onSubmit,
  ) {
    return TextFormField(
      controller: controller,
      focusNode: focus,
      obscureText: true,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => onSubmit(),
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: const Icon(Icons.lock_outline),
      ),
      validator: (v) =>
          v?.trim().isEmpty ?? true ? 'Password is required' : null,
    );
  }

  Widget _buildErrorMessage(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        message,
        style: const TextStyle(color: Colors.redAccent),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoginButton(bool isLoading, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? _buildIsLoadingIndicator() : _buildSignInText(),
    );
  }

  SizedBox _buildIsLoadingIndicator() {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
    );
  }

  Text _buildSignInText() {
    return const Text(
      'Sign In',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(onPressed: () {}, child: const Text('Forgot Password?'));
  }
}
