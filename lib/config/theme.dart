import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color primaryGreen = Color(0xFF22c55e);
  static const Color primaryDarkGreen = Color(0xFF16a34a);
  static const Color lightMint = Color(0xFFF0FDF4);
  static const Color white = Color(0xFFFFFFFF);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFFB923C);
  static const Color darkGrey = Color(0xFF1F2937);
  static const Color mediumGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFFF3F4F6);
  static const Color borderGrey = Color(0xFFE5E7EB);

  // Convenience color aliases
  static const Color primary = primaryGreen;
  static const Color primaryDark = primaryDarkGreen;
  static const Color error = errorRed;
  static const Color borderLight = borderGrey;
  static const Color inputBackground = lightMint;
  static const Color success = successGreen;
  static const Color warning = warningOrange;

  // Text Colors
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMedium = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);

  // Spacing Constants
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusSmall = 8.0; // Alias for radiusSm
  static const double radiusMd = 12.0;
  static const double radiusMedium = 12.0; // Alias for radiusMd
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  // Component Sizes
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
  static const double iconSizeSm = 20.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double socialButtonSize = 48.0;

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // Shadow Definitions
  static const BoxShadow shadowSmall = BoxShadow(
    color: Color(0x0A000000),
    blurRadius: 2,
    offset: Offset(0, 1),
  );

  static const BoxShadow shadowMedium = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow shadowLarge = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: white,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        onPrimary: white,
        secondary: primaryDarkGreen,
        onSecondary: white,
        error: errorRed,
        onError: white,
        surface: white,
        onSurface: textDark,
        outline: borderGrey,
      ),

      // Text Themes
      textTheme: TextTheme(
        // Display Styles
        displayLarge: _textStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: -0.5,
        ),
        displayMedium: _textStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: -0.5,
        ),
        displaySmall: _textStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textDark,
          letterSpacing: -0.25,
        ),

        // Heading Styles
        headlineLarge: _textStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineMedium: _textStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineSmall: _textStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),

        // Body Styles
        bodyLarge: _textStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textDark,
          height: 1.5,
        ),
        bodyMedium: _textStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textDark,
          height: 1.43,
        ),
        bodySmall: _textStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textMedium,
          height: 1.33,
        ),

        // Label Styles
        labelLarge: _textStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: 0.5,
        ),
        labelMedium: _textStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textMedium,
          letterSpacing: 0.5,
        ),
        labelSmall: _textStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textLight,
          letterSpacing: 0.5,
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: white,
        foregroundColor: textDark,
        centerTitle: true,
        titleTextStyle: _textStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightMint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: borderGrey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: borderGrey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        hintStyle: _textStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textLight,
        ),
        labelStyle: _textStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textMedium,
        ),
        errorStyle: _textStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: errorRed,
        ),
        prefixIconColor: MaterialStateColor.resolveWith((
          Set<MaterialState> states,
        ) {
          if (states.contains(MaterialState.focused)) {
            return primaryGreen;
          }
          return textLight;
        }),
        suffixIconColor: MaterialStateColor.resolveWith((
          Set<MaterialState> states,
        ) {
          if (states.contains(MaterialState.focused)) {
            return primaryGreen;
          }
          return textLight;
        }),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: white,
          elevation: 0,
          minimumSize: const Size(double.infinity, buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingMd,
          ),
          textStyle: _textStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: white,
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>((
            Set<MaterialState> states,
          ) {
            if (states.contains(MaterialState.hovered)) {
              return primaryGreen.withOpacity(0.9);
            }
            if (states.contains(MaterialState.pressed)) {
              return primaryDarkGreen;
            }
            return null;
          }),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          textStyle: _textStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: primaryGreen,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: borderGrey, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          minimumSize: const Size(double.infinity, buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingMd,
          ),
          textStyle: _textStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: primaryGreen,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          side: const BorderSide(color: borderGrey, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color?>((
          Set<MaterialState> states,
        ) {
          if (states.contains(MaterialState.selected)) {
            return primaryGreen;
          }
          return transparent;
        }),
        checkColor: MaterialStateProperty.all(white),
        side: MaterialStateBorderSide.resolveWith((Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return const BorderSide(color: primaryGreen);
          }
          return const BorderSide(color: borderGrey);
        }),
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: borderGrey,
        thickness: 1,
        space: spacingMd,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkGrey,
        contentTextStyle: _textStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        titleTextStyle: _textStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        contentTextStyle: _textStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textMedium,
        ),
      ),

      // Navigation Bar Theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: white,
        elevation: 8,
        height: 80,
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle?>((
          Set<MaterialState> states,
        ) {
          if (states.contains(MaterialState.selected)) {
            return _textStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primaryGreen,
            );
          }
          return _textStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textMedium,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith<IconThemeData?>((
          Set<MaterialState> states,
        ) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: primaryGreen);
          }
          return const IconThemeData(color: textMedium);
        }),
      ),
    );
  }

  // Helper method to create text styles
  static TextStyle _textStyle({
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    double letterSpacing = 0,
    double height = 1.2,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      fontFamily: 'Poppins', // You can change this to your preferred font
    );
  }

  // Utility method to get theme colors
  static const Color transparent = Colors.transparent;

  // Text style getters for convenience
  static TextStyle get labelMedium {
    return _textStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: textMedium,
      letterSpacing: 0.5,
    );
  }

  static TextStyle get labelSmall {
    return _textStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: textLight,
      letterSpacing: 0.5,
    );
  }

  static TextStyle get bodyMedium {
    return _textStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textDark,
      height: 1.43,
    );
  }

  static TextStyle get buttonLarge {
    return _textStyle(fontSize: 16, fontWeight: FontWeight.w600, color: white);
  }

  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return successGreen;
      case 'error':
        return errorRed;
      case 'warning':
        return warningOrange;
      default:
        return mediumGrey;
    }
  }
}
