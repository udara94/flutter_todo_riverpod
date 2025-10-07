import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../generated/l10n.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_dimensions.dart';
import '../auth/controllers/auth_controller.dart';
import '../auth/enum/auth_state.dart';
import '../auth/state/auth_state.dart';
import '../../utils/router/app_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Fade animation controller
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale and rotation animation
    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // Fade animation for text
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    // Start logo animation
    await _logoController.forward();

    // Start fade animation after logo
    await Future.delayed(const Duration(milliseconds: 300));
    await _fadeController.forward();

    // Wait a bit then check auth state
    await Future.delayed(const Duration(milliseconds: 1000));
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() {
    if (mounted) {
      // Check current state and navigate
      final authState = ref.read(authControllerProvider);
      if (authState?.status == AuthStatus.authenticated) {
        AppRouter.goToHome(context);
      } else if (authState?.status == AuthStatus.unauthenticated) {
        AppRouter.goToLogin(context);
      }
      // If status is still initial, the build method will handle navigation
      // when the auth state changes
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState?>(authControllerProvider, (previous, next) {
      if (next != null && mounted) {
        if (next.status == AuthStatus.authenticated) {
          AppRouter.goToHome(context);
        } else if (next.status == AuthStatus.unauthenticated) {
          AppRouter.goToLogin(context);
        }
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo with animation
                AnimatedBuilder(
                  animation: _logoAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoAnimation.value,
                      child: Transform.rotate(
                        angle: _logoAnimation.value * 0.1,
                        child: Container(
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
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppDimensions.spacingHuge),

                // App name with fade animation
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        children: [
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
                              color: AppColors.withOpacity(
                                AppColors.textLight,
                                0.8,
                              ),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppDimensions.spacingHuge),

                // Loading indicator
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: SizedBox(
                        width: AppDimensions.progressIndicatorSize,
                        height: AppDimensions.progressIndicatorSize,
                        child: CircularProgressIndicator(
                          strokeWidth:
                              AppDimensions.progressIndicatorStrokeWidth,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.withOpacity(AppColors.textLight, 0.8),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
