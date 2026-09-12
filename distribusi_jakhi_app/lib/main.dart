import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'shared/theme/light_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/spv/providers/spv_provider.dart';
import 'features/gudang/providers/gudang_provider.dart';
import 'features/admin/providers/admin_provider.dart';
import 'features/admin/providers/notification_provider.dart';
import 'features/supir/providers/supir_provider.dart';

import 'features/auth/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SpvProvider()),
        ChangeNotifierProvider(create: (_) => GudangProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SupirProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Distribusi Jakhi',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: LightTheme.primary,
        scaffoldBackgroundColor: LightTheme.background,
        colorScheme: ColorScheme.light(
          primary: LightTheme.primary,
          surface: LightTheme.surface,
          error: const Color(0xFFEF4444),
          onPrimary: Colors.white,
          onSurface: LightTheme.textPrimary,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: LightTheme.background,
          foregroundColor: LightTheme.textPrimary,
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: LightTheme.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: LightTheme.textPrimary,
            side: const BorderSide(color: LightTheme.border, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: LightTheme.surfaceVariant,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: LightTheme.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: LightTheme.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: LightTheme.primary, width: 2),
          ),
          hintStyle: GoogleFonts.inter(color: LightTheme.textTertiary, fontSize: 14),
        ),
        dividerTheme: const DividerThemeData(color: LightTheme.border, thickness: 1),
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}