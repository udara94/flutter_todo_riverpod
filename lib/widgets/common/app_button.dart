import 'package:flutter/material.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_dimensions.dart';

/// Common button component for consistent styling across the app
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? textColor;
  final Color? backgroundColor;
  final double? elevation;
  final BorderSide? borderSide;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.textColor,
    this.backgroundColor,
    this.elevation,
    this.borderSide,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final buttonStyle = _getButtonStyle(isDarkMode);
    final buttonPadding = _getButtonPadding();
    final buttonBorderRadius = borderRadius ?? _getButtonBorderRadius();

    Widget buttonChild = _buildButtonChild();

    if (isFullWidth) {
      buttonChild = SizedBox(width: double.infinity, child: buttonChild);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(buttonBorderRadius),
        gradient: _getGradient(isDarkMode),
        boxShadow: elevation != null
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: elevation!,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle.copyWith(
          padding: WidgetStateProperty.all(buttonPadding),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonBorderRadius),
              side: borderSide ?? BorderSide.none,
            ),
          ),
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          alignment: Alignment.center,
        ),
        child: buttonChild,
      ),
    );
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return Center(
        child: SizedBox(
          height: AppDimensions.iconM,
          width: AppDimensions.iconM,
          child: CircularProgressIndicator(
            strokeWidth: AppDimensions.progressIndicatorStrokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(
              textColor ?? _getTextColor(),
            ),
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _getIconSize(), color: textColor ?? _getTextColor()),
          const SizedBox(width: AppDimensions.spacingS),
          Text(
            text,
            style: TextStyle(
              fontSize: _getFontSize(),
              fontWeight: FontWeight.w600,
              color: textColor ?? _getTextColor(),
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: _getFontSize(),
        fontWeight: FontWeight.w600,
        color: textColor ?? _getTextColor(),
      ),
    );
  }

  ButtonStyle _getButtonStyle(bool isDarkMode) {
    final baseStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: textColor ?? _getTextColor(),
      disabledBackgroundColor: AppColors.grey300,
      disabledForegroundColor: AppColors.grey500,
    );

    switch (variant) {
      case AppButtonVariant.primary:
        return baseStyle;
      case AppButtonVariant.secondary:
        return baseStyle.copyWith(
          foregroundColor: WidgetStateProperty.all(AppColors.primary),
        );
      case AppButtonVariant.outline:
        return baseStyle.copyWith(
          foregroundColor: WidgetStateProperty.all(AppColors.primary),
        );
      case AppButtonVariant.text:
        return baseStyle.copyWith(
          foregroundColor: WidgetStateProperty.all(AppColors.primary),
          elevation: WidgetStateProperty.all(0),
        );
      case AppButtonVariant.danger:
        return baseStyle.copyWith(
          foregroundColor: WidgetStateProperty.all(AppColors.textLight),
        );
      case AppButtonVariant.success:
        return baseStyle.copyWith(
          foregroundColor: WidgetStateProperty.all(AppColors.textLight),
        );
    }
  }

  LinearGradient _getGradient(bool isDarkMode) {
    switch (variant) {
      case AppButtonVariant.primary:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        );
      case AppButtonVariant.secondary:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primary, AppColors.primaryDark],
        );
      case AppButtonVariant.outline:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.withOpacity(AppColors.primary, 0.1),
            Colors.transparent,
            AppColors.withOpacity(AppColors.primary, 0.05),
          ],
        );
      case AppButtonVariant.text:
        return const LinearGradient(
          colors: [Colors.transparent, Colors.transparent],
        );
      case AppButtonVariant.danger:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.error,
            AppColors.error.withOpacity(0.8),
            AppColors.error.withOpacity(0.6),
          ],
        );
      case AppButtonVariant.success:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.success,
            AppColors.success.withOpacity(0.8),
            AppColors.success.withOpacity(0.6),
          ],
        );
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.textLight;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      case AppButtonVariant.outline:
        return AppColors.primary;
      case AppButtonVariant.text:
        return AppColors.primary;
      case AppButtonVariant.danger:
        return AppColors.textLight;
      case AppButtonVariant.success:
        return AppColors.textLight;
    }
  }

  EdgeInsetsGeometry _getButtonPadding() {
    if (padding != null) return padding!;

    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingS,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXL,
          vertical: AppDimensions.paddingL,
        );
    }
  }

  double _getButtonBorderRadius() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.radiusS;
      case AppButtonSize.medium:
        return AppDimensions.inputBorderRadius;
      case AppButtonSize.large:
        return AppDimensions.radiusL;
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.fontSizeS;
      case AppButtonSize.medium:
        return AppDimensions.fontSizeM;
      case AppButtonSize.large:
        return AppDimensions.fontSizeL;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.iconS;
      case AppButtonSize.medium:
        return AppDimensions.iconM;
      case AppButtonSize.large:
        return AppDimensions.iconL;
    }
  }
}

/// Button variants
enum AppButtonVariant { primary, secondary, outline, text, danger, success }

/// Button sizes
enum AppButtonSize { small, medium, large }

/// Specialized floating action button with gradient
class AppFloatingActionButton extends StatelessWidget {
  final String? label;
  final IconData icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const AppFloatingActionButton({
    super.key,
    this.label,
    required this.icon,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (label != null) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          gradient: _getGradient(isDarkMode),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label!, textAlign: TextAlign.center),
          backgroundColor: Colors.transparent,
          foregroundColor: foregroundColor ?? _getForegroundColor(),
          elevation: 0, // We handle elevation with Container
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        gradient: _getGradient(isDarkMode),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Icon(icon),
        backgroundColor: Colors.transparent,
        foregroundColor: foregroundColor ?? _getForegroundColor(),
        elevation: 0, // We handle elevation with Container
      ),
    );
  }

  LinearGradient _getGradient(bool isDarkMode) {
    switch (variant) {
      case AppButtonVariant.primary:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
            AppColors.primary.withOpacity(0.6),
          ],
        );
      case AppButtonVariant.secondary:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.withOpacity(AppColors.primary, 0.2),
            AppColors.withOpacity(AppColors.primary, 0.1),
            AppColors.withOpacity(AppColors.primary, 0.05),
          ],
        );
      case AppButtonVariant.danger:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.error,
            AppColors.error.withOpacity(0.8),
            AppColors.error.withOpacity(0.6),
          ],
        );
      case AppButtonVariant.success:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success,
            AppColors.success.withOpacity(0.8),
            AppColors.success.withOpacity(0.6),
          ],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primary.withOpacity(0.8),
            AppColors.primary.withOpacity(0.6),
          ],
        );
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.textLight;
      case AppButtonVariant.secondary:
        return AppColors.textLight;
      case AppButtonVariant.danger:
        return AppColors.textLight;
      case AppButtonVariant.success:
        return AppColors.textLight;
      default:
        return AppColors.textLight;
    }
  }
}

/// Icon button with gradient styling
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final String? tooltip;
  final Color? iconColor;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.tooltip,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    Widget button = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
        gradient: _getGradient(isDarkMode),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: _getIconSize(),
          color: iconColor ?? _getIconColor(),
        ),
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: iconColor ?? _getIconColor(),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }

    return button;
  }

  LinearGradient _getGradient(bool isDarkMode) {
    switch (variant) {
      case AppButtonVariant.primary:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.withOpacity(AppColors.textLight, 0.1),
            Colors.transparent,
            AppColors.withOpacity(AppColors.textLight, 0.05),
          ],
        );
      case AppButtonVariant.secondary:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.withOpacity(AppColors.primary, 0.1),
            Colors.transparent,
            AppColors.withOpacity(AppColors.primary, 0.05),
          ],
        );
      default:
        return const LinearGradient(
          colors: [Colors.transparent, Colors.transparent],
        );
    }
  }

  Color _getIconColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.textLight;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.iconS;
      case AppButtonSize.medium:
        return AppDimensions.iconM;
      case AppButtonSize.large:
        return AppDimensions.iconL;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.radiusS;
      case AppButtonSize.medium:
        return AppDimensions.radiusM;
      case AppButtonSize.large:
        return AppDimensions.radiusL;
    }
  }
}
