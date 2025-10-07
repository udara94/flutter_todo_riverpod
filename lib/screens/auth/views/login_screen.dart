import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../auth/state/auth_state.dart';
import '../../auth/enum/auth_state.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_dimensions.dart';
import '../../../generated/l10n.dart';
import '../../../utils/router/app_router.dart';
import '../../../utils/snackbar_util.dart';
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

    // Listen to auth state changes for side effects (navigation, snackbars)
    ref.listen<AuthState?>(authControllerProvider, (previous, next) {
      if (next?.status == AuthStatus.authenticated) {
        // Navigate to home screen on successful login
        AppRouter.goToHome(context);
        SnackBarUtil.showSuccess(
          context,
          S.current.welcomeBack(next?.user?.name ?? 'User'),
        );
      } else if (next?.errorMessage != null) {
        // Show error message
        SnackBarUtil.showWithAction(
          context,
          next?.errorMessage ?? S.current.loginFailed,
          actionLabel: S.current.retry,
          onActionPressed: () {
            ref.read(authControllerProvider.notifier).clearError();
          },
          backgroundColor: Colors.red,
        );
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.splashGradient,
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.withOpacity(AppColors.textLight, 0.1),
                Colors.transparent,
                AppColors.withOpacity(AppColors.textLight, 0.05),
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: AppDimensions.paddingAllXXL,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo/Title - Using splash screen design
                    Container(
                      width: AppDimensions.splashLogoSize,
                      height: AppDimensions.splashLogoSize,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusXXL,
                        ),
                        boxShadow: AppDimensions.shadowHigh,
                      ),
                      child: const Icon(
                        Icons.task_alt,
                        size: AppDimensions.splashIconSize,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingHuge),
                    Text(
                      S.current.appName,
                      style: const TextStyle(
                        fontSize: AppDimensions.fontSizeHuge,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingS),
                    Text(
                      S.current.splashSubtitle,
                      style: TextStyle(
                        fontSize: AppDimensions.fontSizeL,
                        color: AppColors.withOpacity(AppColors.textLight, 0.8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingHuge),

                    // Login Form
                    Card(
                      elevation: 8,
                      color: AppColors.surfaceLight.withOpacity(0.95),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                      ),
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
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),

                              // Email Field
                              AppEmailField(
                                controller: _emailController,
                                labelText: S.current.emailLabel,
                                isRequired: true,
                                requiredErrorMessage:
                                    S.current.emailRequiredError,
                              ),
                              const SizedBox(height: AppDimensions.spacingL),

                              // Password Field
                              AppPasswordField(
                                controller: _passwordController,
                                labelText: S.current.passwordLabel,
                                isRequired: true,
                                requiredErrorMessage:
                                    S.current.passwordRequiredError,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return S.current.passwordRequiredError;
                                  }
                                  if (value.length < 6) {
                                    return S.current.passwordLengthError;
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

                              const SizedBox(height: AppDimensions.spacingL),

                              // Demo Credentials Button
                              AppButton(
                                text: S.current.useDemoCredentials,
                                onPressed: () {
                                  _emailController.text = 'demo@example.com';
                                  _passwordController.text = 'password123';
                                },
                                variant: AppButtonVariant.outline,
                                size: AppButtonSize.medium,
                                isFullWidth: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                  title: Text(S.current.logoutTitle),
                  content: Text(S.current.logoutMessage),
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
                  SnackBarUtil.showSuccess(
                    context,
                    S.current.loggedOutSuccessfully,
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
      tooltip: S.current.logoutTooltip,
    );
  }
}
