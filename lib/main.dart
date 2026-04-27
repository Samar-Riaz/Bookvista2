import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://raoszgrmnzksaxnnuayp.supabase.co',
    anonKey: 'sb_publishable_jd0tG8l_Dfic7yjcAC_ZPg_jGlpK3o2',
  );
  
  runApp(const ProviderScope(child: BookVistaApp()));
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