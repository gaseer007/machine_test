import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static const Color _primaryBlack = Color(0xFF1A1A1A); // Main brand black
  static const Color _speechBubbleBlack = Color(
    0xFF000000,
  ); // Pure black for accents
  static const Color _pureWhite = Color(0xFFFFFFFF); // Clean white from logo
  static const Color _lightGrey = Color(0xFFF8F9FA); // Subtle background
  static const Color _mediumGrey = Color(0xFFE8EAED); // Borders and dividers
  static const Color _darkGrey = Color(0xFF5F6368); // Secondary text
  static const Color _accentBlue = Color(
    0xFF4285F4,
  ); // Professional blue accent
  static const Color successGreen = Color(0xFF34A853); // Success states
  static const Color warningAmber = Color(0xFFFBBC04); // Warning states
  static const Color errorRed = Color(0xFFEA4335); // Error states
  static const Color surfaceVariant = Color(0xFFF1F3F4); // Cards and surfaces

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryBlack,
        brightness: Brightness.light,
        primary: _primaryBlack,
        secondary: _accentBlue,
        tertiary: _speechBubbleBlack,
        surface: _pureWhite,
        surfaceVariant: surfaceVariant,
        onSurface: _primaryBlack,
        onSurfaceVariant: _darkGrey,
        outline: _mediumGrey,
        shadow: _primaryBlack.withOpacity(0.08),
        background: _lightGrey,
        onBackground: _primaryBlack,
      ),

      scaffoldBackgroundColor: _lightGrey,

      // Clean, modern App Bar matching logo aesthetic
      appBarTheme: AppBarTheme(
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: _pureWhite,
        foregroundColor: _primaryBlack,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: _primaryBlack.withOpacity(0.08),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700, // Bold like logo text
          color: _primaryBlack,
          letterSpacing: -0.3,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: _primaryBlack, size: 24),
        actionsIconTheme: const IconThemeData(color: _primaryBlack, size: 24),
      ),

      // Premium buttons with speech bubble inspiration
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlack,
          foregroundColor: _pureWhite,
          elevation: 2,
          shadowColor: _primaryBlack.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              12,
            ), // Less rounded, more professional
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700, // Bold like logo
            letterSpacing: 0.3,
          ),
          minimumSize: const Size(120, 52),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.hovered)) {
              return _pureWhite.withOpacity(0.1);
            }
            if (states.contains(MaterialState.pressed)) {
              return _pureWhite.withOpacity(0.2);
            }
            return null;
          }),
        ),
      ),

      // Secondary buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _primaryBlack,
          side: const BorderSide(color: _primaryBlack, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          minimumSize: const Size(120, 52),
        ),
      ),

      // Text buttons
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryBlack,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),

      // Clean card design inspired by logo container
      cardTheme: CardTheme(
        color: _pureWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: _primaryBlack.withOpacity(0.06),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Similar to logo corners
          side: BorderSide(color: _mediumGrey, width: 0.5),
        ),
      ),

      // Modern input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _pureWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _mediumGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _mediumGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryBlack, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        hintStyle: TextStyle(
          color: _darkGrey.withOpacity(0.7),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: _darkGrey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: const TextStyle(
          color: _primaryBlack,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Bottom navigation with clean design
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: _primaryBlack,
        unselectedItemColor: _darkGrey,
        showUnselectedLabels: true,
        backgroundColor: _pureWhite,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Navigation bar theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _pureWhite,
        indicatorColor: _primaryBlack.withOpacity(0.1),
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: _primaryBlack.withOpacity(0.08),
        labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(
              color: _primaryBlack,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            );
          }
          return const TextStyle(
            color: _darkGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith<IconThemeData>((states) {
          if (states.contains(MaterialState.selected)) {
            return const IconThemeData(color: _primaryBlack, size: 24);
          }
          return const IconThemeData(color: _darkGrey, size: 24);
        }),
      ),

      // FAB with speech bubble inspiration
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _primaryBlack,
        foregroundColor: _pureWhite,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // List tiles
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _primaryBlack,
          letterSpacing: -0.1,
        ),
        subtitleTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: _darkGrey,
        ),
        leadingAndTrailingTextStyle: const TextStyle(
          fontSize: 14,
          color: _darkGrey,
        ),
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: _pureWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 12,
        shadowColor: _primaryBlack.withOpacity(0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _primaryBlack,
          letterSpacing: -0.2,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _darkGrey,
          height: 1.5,
        ),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariant,
        disabledColor: _mediumGrey,
        selectedColor: _primaryBlack.withOpacity(0.1),
        secondarySelectedColor: _accentBlue.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        brightness: Brightness.light,
      ),

      // Progress indicators
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: _primaryBlack,
        linearTrackColor: _mediumGrey,
        circularTrackColor: _mediumGrey,
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return _primaryBlack;
          }
          return _pureWhite;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return _primaryBlack.withOpacity(0.5);
          }
          return _mediumGrey;
        }),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return _primaryBlack;
          }
          return Colors.transparent;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Snackbar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _primaryBlack,
        contentTextStyle: const TextStyle(
          color: _pureWhite,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
      ),

      // Typography theme inspired by logo typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w700, // Bold like INNER SPACE
          letterSpacing: -0.5,
          color: _primaryBlack,
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: _primaryBlack,
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: _primaryBlack,
        ),
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700, // Logo-inspired bold headings
          letterSpacing: -0.3,
          color: _primaryBlack,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
          color: _primaryBlack,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
          color: _primaryBlack,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: _primaryBlack,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          color: _primaryBlack,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: _primaryBlack,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
          color: _primaryBlack,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
          color: _primaryBlack,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.3,
          color: _darkGrey,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          color: _primaryBlack,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4, // Spaced like "COWORKING"
          color: _darkGrey,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: _darkGrey,
        ),
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: _mediumGrey,
        thickness: 0.5,
        space: 1,
      ),
    );
  }

  // Dark theme matching InnerSpace branding

  // Utility methods for InnerSpace design system
  static BoxDecoration get speechBubbleDecoration => BoxDecoration(
    color: _primaryBlack,
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(2), // Speech bubble point
    ),
    boxShadow: [
      BoxShadow(
        color: _primaryBlack.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get containerDecoration => BoxDecoration(
    color: _pureWhite,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: _mediumGrey, width: 0.5),
    boxShadow: [
      BoxShadow(
        color: _primaryBlack.withOpacity(0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration get logoInspiredDecoration => BoxDecoration(
    color: _pureWhite,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: _primaryBlack, width: 2),
    boxShadow: [
      BoxShadow(
        color: _primaryBlack.withOpacity(0.08),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxShadow get subtleShadow => BoxShadow(
    color: _primaryBlack.withOpacity(0.04),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  static BoxShadow get elevatedShadow => BoxShadow(
    color: _primaryBlack.withOpacity(0.08),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );

  // Brand colors for easy access
  static Color get primaryBlack => _primaryBlack;
  static Color get pureWhite => _pureWhite;
  static Color get speechBubbleBlack => _speechBubbleBlack;
  static Color get accentBlue => _accentBlue;
  static Color get lightGrey => _lightGrey;
  static Color get mediumGrey => _mediumGrey;
  static Color get darkGrey => _darkGrey;
}
