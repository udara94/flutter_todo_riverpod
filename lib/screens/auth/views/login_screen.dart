import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/state/auth_state.dart';
import '../../auth/enum/auth_state.dart';
import '../../theme/controllers/theme_controller.dart';
import '../../config/controllers/app_config_controller.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_dimensions.dart';
import '../../../generated/l10n.dart';
import '../../../utils/router/app_router.dart';
import '../../../widgets/common/app_text_input_field.dart';
import '../../../widgets/common/app_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch auth state for reactive UI updates
    final authState = ref.watch(authControllerProvider);
    final themeState = ref.watch(themeControllerProvider);
    final appConfigState = ref.watch(appConfigControllerProvider);

    // Listen to auth state changes for side effects (navigation, snackbars)
    ref.listen<AuthState?>(authControllerProvider, (previous, next) {
      if (next?.status == AuthStatus.authenticated) {
        // Navigate to home screen on successful login
        AppRouter.goToHome(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.current.welcomeBack(next?.user?.name ?? 'User')),
            backgroundColor: Colors.green,
          ),
        );
      } else if (next?.errorMessage != null) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next?.errorMessage ?? S.current.loginFailed),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: S.current.retry,
              textColor: Colors.white,
              onPressed: () {
                ref.read(authControllerProvider.notifier).clearError();
              },
            ),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: themeState.isDarkMode
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppDimensions.paddingAllXXL,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo/Title
                Icon(
                  Icons.task_alt,
                  size: AppDimensions.iconMassive,
                  color: themeState.isDarkMode
                      ? AppColors.textLight
                      : AppColors.primary,
                ),
                const SizedBox(height: AppDimensions.spacingL),
                Text(
                  appConfigState.appName,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: themeState.isDarkMode
                        ? AppColors.textLight
                        : AppColors.textDark,
                  ),
                ),
                Text(
                  S.current.version(appConfigState.version),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: themeState.isDarkMode
                        ? AppColors.grey400
                        : AppColors.grey600,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingHuge),

                // Login Form
                Card(
                  elevation: themeState.isDarkMode ? 8 : 4,
                  child: Padding(
                    padding: AppDimensions.paddingAllXXL,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            S.current.singIn,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Email Field
                          AppEmailField(
                            controller: _emailController,
                            labelText: S.current.emailLabel,
                            isRequired: true,
                            requiredErrorMessage: 'Please enter your email',
                          ),
                          const SizedBox(height: AppDimensions.spacingL),

                          // Password Field
                          AppPasswordField(
                            controller: _passwordController,
                            labelText: S.current.passwordLabel,
                            isRequired: true,
                            requiredErrorMessage: 'Please enter your password',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Login Button
                          AppButton(
                            text: S.current.loginButton,
                            onPressed: _handleLogin,
                            variant: AppButtonVariant.primary,
                            size: AppButtonSize.large,
                            isLoading: authState?.isLoading == true,
                            isFullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Demo Credentials
                Card(
                  color: themeState.isDarkMode
                      ? AppColors.grey800
                      : AppColors.primary.withOpacity(0.1),
                  child: Padding(
                    padding: AppDimensions.paddingAllL,
                    child: Column(
                      children: [
                        Text(
                          S.current.demoCredentials,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: themeState.isDarkMode
                                ? AppColors.textLight
                                : AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        Text(
                          S.current.demoCredentialsText,
                          style: TextStyle(
                            color: themeState.isDarkMode
                                ? AppColors.grey300
                                : AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        AppButton(
                          text: S.current.useDemoCredentials,
                          onPressed: () {
                            _emailController.text = 'demo@example.com';
                            _passwordController.text = 'password123';
                          },
                          variant: AppButtonVariant.secondary,
                          size: AppButtonSize.medium,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Dark Mode Toggle
                Card(
                  child: ListTile(
                    leading: Icon(
                      themeState.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    ),
                    title: Text(
                      themeState.isDarkMode
                          ? S.current.darkMode
                          : S.current.lightMode,
                    ),
                    trailing: Switch(
                      value: themeState.isDarkMode,
                      onChanged: (value) {
                        ref
                            .read(themeControllerProvider.notifier)
                            .setDarkMode(value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Read auth notifier for one-time action
      await ref
          .read(authControllerProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);
    }
  }
}

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return IconButton(
      onPressed: authState?.isLoading == true
          ? null
          : () async {
              // Show confirmation dialog
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    AppButton(
                      text: S.current.cancel,
                      onPressed: () => Navigator.of(context).pop(false),
                      variant: AppButtonVariant.text,
                      size: AppButtonSize.medium,
                    ),
                    AppButton(
                      text: S.current.logout,
                      onPressed: () => Navigator.of(context).pop(true),
                      variant: AppButtonVariant.danger,
                      size: AppButtonSize.medium,
                    ),
                  ],
                ),
              );

              if (shouldLogout == true) {
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) {
                  AppRouter.goToLogin(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logged out successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              }
            },
      icon: authState?.isLoading == true
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.logout),
      tooltip: 'Logout',
    );
  }
}
