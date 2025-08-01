import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/admin_dashboard.dart';
import 'screens/user_management.dart';
import 'screens/doctor_management.dart';
import 'screens/medicine_management.dart';
import 'screens/analytics_dashboard.dart';
import 'screens/admin_management_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Remove portrait mode restriction for web
  runApp(const AdminPanel());
}

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Plant Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Color Scheme
        primaryColor: const Color(0xFF2E7D32), // Deep botanical green
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF8BC34A), // Leaf green
          background: Colors.white,
          surface: Colors.white,
        ),

        // Text Theme
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E7D32),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),

        // Input Decoration Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),

        // Card Theme
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),

        // Elevated Button Theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            elevation: 2,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // Text Button Theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF2E7D32),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Icon Theme
        iconTheme: const IconThemeData(
          color: Color(0xFF2E7D32),
          size: 24,
        ),

        // App Bar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          toolbarHeight: 64,
        ),

        // Scaffold Background Color
        scaffoldBackgroundColor: Colors.grey[100],

        // Divider Theme
        dividerTheme: DividerThemeData(
          color: Colors.grey[200],
          thickness: 1,
          space: 32,
        ),

        // Data Table Theme
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
          dataRowColor: MaterialStateProperty.all(Colors.white),
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
          horizontalMargin: 24,
          columnSpacing: 24,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const AdminLoginScreen(),
        '/dashboard': (context) => const AdminDashboard(),
        '/users': (context) => const UserManagement(),
        '/doctors': (context) => const DoctorManagement(),
        '/medicines': (context) => const MedicineManagement(),
        '/analytics': (context) => const AnalyticsDashboard(),
        '/admin-management': (context) => const AdminManagementScreen(),
        // Placeholders for future implementation
        '/stats': (context) => const Scaffold(body: Center(child: Text('Statistics'))),
        '/settings': (context) => const Scaffold(body: Center(child: Text('Settings'))),
      },
    );
  }
}
