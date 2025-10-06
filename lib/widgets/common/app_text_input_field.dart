import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants/app_colors.dart';
import '../../utils/constants/app_dimensions.dart';

/// Common text input field component for consistent styling across the app
class AppTextInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool filled;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final bool isRequired;
  final String? requiredErrorMessage;
  final bool showCharacterCount;
  final bool autofocus;

  const AppTextInputField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction = TextInputAction.done,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.inputFormatters,
    this.filled = true,
    this.fillColor,
    this.contentPadding,
    this.borderRadius,
    this.isRequired = false,
    this.requiredErrorMessage,
    this.showCharacterCount = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      textInputAction: textInputAction,
      validator: validator ?? (isRequired ? _defaultValidator : null),
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: _buildSuffixIcon(),
        filled: filled,
        fillColor:
            fillColor ?? (isDarkMode ? AppColors.grey800 : AppColors.grey50),
        contentPadding:
            contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingL,
              vertical: AppDimensions.paddingM,
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.inputBorderRadius,
          ),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.grey600 : AppColors.grey300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.inputBorderRadius,
          ),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.grey600 : AppColors.grey300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.inputBorderRadius,
          ),
          borderSide: BorderSide(color: AppColors.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.inputBorderRadius,
          ),
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.inputBorderRadius,
          ),
          borderSide: const BorderSide(color: AppColors.error, width: 2.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.inputBorderRadius,
          ),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.grey700 : AppColors.grey200,
          ),
        ),
        counterText: showCharacterCount ? null : '',
        labelStyle: TextStyle(
          color: isDarkMode ? AppColors.grey300 : AppColors.grey600,
          fontSize: AppDimensions.fontSizeM,
        ),
        hintStyle: TextStyle(
          color: isDarkMode ? AppColors.grey400 : AppColors.grey500,
          fontSize: AppDimensions.fontSizeM,
        ),
        helperStyle: TextStyle(
          color: isDarkMode ? AppColors.grey400 : AppColors.grey600,
          fontSize: AppDimensions.fontSizeS,
        ),
        errorStyle: const TextStyle(
          color: AppColors.error,
          fontSize: AppDimensions.fontSizeS,
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (suffixIcon == null) return null;

    if (onSuffixIconPressed != null) {
      return IconButton(
        icon: Icon(suffixIcon),
        onPressed: onSuffixIconPressed,
        color: AppColors.grey600,
      );
    }

    return Icon(suffixIcon, color: AppColors.grey600);
  }

  String? _defaultValidator(String? value) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return requiredErrorMessage ?? '${labelText ?? 'This field'} is required';
    }
    return null;
  }
}

/// Specialized text input field for search functionality
class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmitted;
  final bool autofocus;
  final double borderRadius;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onClear,
    this.onSubmitted,
    this.autofocus = false,
    this.borderRadius = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return TextField(
      controller: controller,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted != null ? (_) => onSubmitted!() : null,
      decoration: InputDecoration(
        hintText: hintText ?? 'Search...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller?.text.isNotEmpty == true
            ? IconButton(icon: const Icon(Icons.clear), onPressed: onClear)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.grey600 : AppColors.grey300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: isDarkMode ? AppColors.grey600 : AppColors.grey300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        filled: true,
        fillColor: isDarkMode ? AppColors.grey800 : AppColors.grey50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
        hintStyle: TextStyle(
          color: isDarkMode ? AppColors.grey400 : AppColors.grey500,
          fontSize: AppDimensions.fontSizeM,
        ),
      ),
    );
  }
}

/// Specialized text input field for password with visibility toggle
class AppPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isRequired;
  final String? requiredErrorMessage;

  const AppPasswordField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.isRequired = false,
    this.requiredErrorMessage,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextInputField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      isRequired: widget.isRequired,
      requiredErrorMessage: widget.requiredErrorMessage,
      obscureText: _obscureText,
      prefixIcon: Icons.lock_outlined,
      suffixIcon: _obscureText ? Icons.visibility : Icons.visibility_off,
      onSuffixIconPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
    );
  }
}

/// Specialized text input field for email
class AppEmailField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool isRequired;
  final String? requiredErrorMessage;

  const AppEmailField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.isRequired = false,
    this.requiredErrorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextInputField(
      controller: controller,
      labelText: labelText,
      hintText: hintText,
      validator: validator ?? _emailValidator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      autofocus: autofocus,
      isRequired: isRequired,
      requiredErrorMessage: requiredErrorMessage,
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  String? _emailValidator(String? value) {
    if (isRequired && (value == null || value.trim().isEmpty)) {
      return requiredErrorMessage ?? '${labelText ?? 'Email'} is required';
    }
    if (value != null && value.isNotEmpty && !value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
