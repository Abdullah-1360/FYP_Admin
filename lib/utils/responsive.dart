import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 850;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 850;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  static double getScreenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static Widget buildResponsiveContent({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    required Widget desktop,
  }) {
    if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet ?? mobile;
    } else {
      return mobile;
    }
  }

  static EdgeInsets getHorizontalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
      );
    } else if (isTablet(context)) {
      return EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      );
    } else {
      return const EdgeInsets.symmetric(horizontal: 16);
    }
  }

  static double getCardWidth(BuildContext context) {
    if (isDesktop(context)) {
      return (MediaQuery.of(context).size.width - 300) / 4; // 4 cards per row
    } else if (isTablet(context)) {
      return (MediaQuery.of(context).size.width - 200) / 2; // 2 cards per row
    } else {
      return MediaQuery.of(context).size.width - 32; // 1 card per row
    }
  }

  static double getSidebarWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 250;
    } else if (isTablet(context)) {
      return 200;
    } else {
      return 0; // Mobile uses drawer instead
    }
  }
} 