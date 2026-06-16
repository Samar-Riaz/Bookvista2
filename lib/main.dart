import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';
import 'firebase_options.dart'; // 2. Import generated options
import 'core/services/logging_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/background_sync_service.dart';
import 'core/services/ad_service.dart';
import 'core/services/supabase_service.dart';
import 'core/utils/platform_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (e, stack) {
    debugPrint('Warning: Could not load .env file: $e');
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
  if (supabaseUrl != null &&
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey != null &&
      supabaseAnonKey.isNotEmpty) {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );
      isSupabaseInitialized = true;
    } catch (e, stack) {
      debugPrint('Warning: Supabase initialization failed: $e');
    }
  } else {
    debugPrint(
        'Warning: Supabase is not configured. App will run in offline mode.');
  }

  // 2. Initialize Firebase safely alongside Supabase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }

  // 3. Create standalone Riverpod ProviderContainer to initialize services
  final container = ProviderContainer();
  final log = container.read(loggerProvider);
  log.i("Initializing BookVista native services...");

  // Initialize notifications (no-op on unsupported platforms; errors are caught)
  await container.read(notificationServiceProvider).init();

  // Workmanager and ads are Android/iOS only — skip on Windows/Web/Desktop
  if (isMobilePlatform) {
    await container.read(backgroundSyncServiceProvider).init();
    await container
        .read(backgroundSyncServiceProvider)
        .registerPeriodicSyncTask();
    // Temporarily disabled ads due to Gradle build issues
    // await container.read(adServiceProvider).init();
  } else {
    log.i('Skipping Workmanager and Mobile Ads on this platform.');
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const BookVistaApp(),
    ),
  );
}

class BookVistaApp extends StatelessWidget {
  const BookVistaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BookVista',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
