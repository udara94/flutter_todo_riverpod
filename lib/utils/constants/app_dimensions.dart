import 'package:flutter/material.dart';

class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;
  static const double spacingXXXL = 32.0;
  static const double spacingHuge = 48.0;

  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 12.0;
  static const double paddingL = 16.0;
  static const double paddingXL = 20.0;
  static const double paddingXXL = 24.0;
  static const double paddingXXXL = 32.0;
  static const double paddingHuge = 48.0;

  // Margin
  static const double marginXS = 4.0;
  static const double marginS = 8.0;
  static const double marginM = 12.0;
  static const double marginL = 16.0;
  static const double marginXL = 20.0;
  static const double marginXXL = 24.0;
  static const double marginXXXL = 32.0;

  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusRound = 50.0;

  // Icon Sizes
  static const double iconXS = 12.0;
  static const double iconS = 16.0;
  static const double iconM = 20.0;
  static const double iconL = 24.0;
  static const double iconXL = 32.0;
  static const double iconXXL = 40.0;
  static const double iconHuge = 60.0;
  static const double iconMassive = 80.0;

  // Font Sizes
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeXXXL = 24.0;
  static const double fontSizeHuge = 32.0;

  // Button Heights
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 40.0;
  static const double buttonHeightL = 48.0;
  static const double buttonHeightXL = 56.0;

  // Card Dimensions
  static const double cardElevation = 4.0;
  static const double cardElevationHigh = 8.0;
  static const double cardPadding = 16.0;
  static const double cardMargin = 12.0;

  // Input Field Dimensions
  static const double inputHeight = 48.0;
  static const double inputBorderWidth = 1.0;
  static const double inputBorderRadius = 12.0;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0;

  // List Item Heights
  static const double listItemHeight = 56.0;
  static const double listItemHeightLarge = 72.0;

  // Chip Dimensions
  static const double chipHeight = 32.0;
  static const double chipBorderRadius = 16.0;
  static const double chipPadding = 8.0;

  // Progress Indicator
  static const double progressIndicatorSize = 30.0;
  static const double progressIndicatorStrokeWidth = 2.0;

  // Splash Screen
  static const double splashLogoSize = 120.0;
  static const double splashIconSize = 60.0;

  // Stat Card
  static const double statCardHeight = 50.0;
  static const double statCardWidth = 120.0;

  // Dialog
  static const double dialogPadding = 24.0;
  static const double dialogBorderRadius = 12.0;

  // Divider
  static const double dividerHeight = 1.0;

  // Shadow
  static const double shadowBlurRadius = 10.0;
  static const double shadowBlurRadiusHigh = 20.0;
  static const double shadowOffsetX = 0.0;
  static const double shadowOffsetY = 5.0;
  static const double shadowOffsetYHigh = 10.0;

  // Screen Dimensions
  static const double screenPadding = 16.0;
  static const double screenPaddingLarge = 24.0;

  // Container Sizes
  static const double containerHeightS = 40.0;
  static const double containerHeightM = 60.0;
  static const double containerHeightL = 80.0;
  static const double containerHeightXL = 120.0;

  // Helper methods for responsive design
  static double getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return paddingL;
    } else if (screenWidth < 900) {
      return paddingXL;
    } else {
      return paddingXXL;
    }
  }

  static double getResponsiveFontSize(
    BuildContext context,
    double baseFontSize,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return baseFontSize;
    } else if (screenWidth < 900) {
      return baseFontSize * 1.1;
    } else {
      return baseFontSize * 1.2;
    }
  }

  static double getResponsiveIconSize(
    BuildContext context,
    double baseIconSize,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return baseIconSize;
    } else if (screenWidth < 900) {
      return baseIconSize * 1.1;
    } else {
      return baseIconSize * 1.2;
    }
  }

  // Common EdgeInsets
  static const EdgeInsets paddingAllXS = EdgeInsets.all(paddingXS);
  static const EdgeInsets paddingAllS = EdgeInsets.all(paddingS);
  static const EdgeInsets paddingAllM = EdgeInsets.all(paddingM);
  static const EdgeInsets paddingAllL = EdgeInsets.all(paddingL);
  static const EdgeInsets paddingAllXL = EdgeInsets.all(paddingXL);
  static const EdgeInsets paddingAllXXL = EdgeInsets.all(paddingXXL);

  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(
    horizontal: paddingL,
  );
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(
    horizontal: paddingXL,
  );
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(
    vertical: paddingL,
  );
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(
    vertical: paddingXL,
  );

  static const EdgeInsets marginAllS = EdgeInsets.all(marginS);
  static const EdgeInsets marginAllM = EdgeInsets.all(marginM);
  static const EdgeInsets marginAllL = EdgeInsets.all(marginL);
  static const EdgeInsets marginAllXL = EdgeInsets.all(marginXL);

  static const EdgeInsets marginBottomS = EdgeInsets.only(bottom: marginS);
  static const EdgeInsets marginBottomM = EdgeInsets.only(bottom: marginM);
  static const EdgeInsets marginBottomL = EdgeInsets.only(bottom: marginL);

  // Common BorderRadius
  static const BorderRadius radiusAllS = BorderRadius.all(
    Radius.circular(radiusS),
  );
  static const BorderRadius radiusAllM = BorderRadius.all(
    Radius.circular(radiusM),
  );
  static const BorderRadius radiusAllL = BorderRadius.all(
    Radius.circular(radiusL),
  );
  static const BorderRadius radiusAllXL = BorderRadius.all(
    Radius.circular(radiusXL),
  );

  static const BorderRadius radiusTopM = BorderRadius.only(
    topLeft: Radius.circular(radiusM),
    topRight: Radius.circular(radiusM),
  );

  static const BorderRadius radiusBottomM = BorderRadius.only(
    bottomLeft: Radius.circular(radiusM),
    bottomRight: Radius.circular(radiusM),
  );

  // Common BoxShadow
  static const List<BoxShadow> shadowLight = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: shadowBlurRadius,
      offset: Offset(shadowOffsetX, shadowOffsetY),
    ),
  ];

  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: shadowBlurRadius,
      offset: Offset(shadowOffsetX, shadowOffsetY),
    ),
  ];

  static const List<BoxShadow> shadowHigh = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: shadowBlurRadiusHigh,
      offset: Offset(shadowOffsetX, shadowOffsetYHigh),
    ),
  ];
}
