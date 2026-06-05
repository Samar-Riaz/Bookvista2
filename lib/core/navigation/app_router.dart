import 'package:go_router/go_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import '../utils/platform_utils.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/home/screens/main_navigation_screen.dart';
import '../../features/books/screens/book_detail_screen.dart';
import '../../features/books/screens/reading_screen.dart';
import '../../features/books/screens/bookmarks_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/author/screens/writer_upload_screen.dart';
import '../../features/author/screens/author_profile_screen.dart';
import '../../features/home/screens/search_screen.dart';
import '../../features/home/screens/library_screen.dart';
import '../../features/home/screens/activity_screen.dart';
import '../../features/home/screens/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  observers: [
    if (isMobilePlatform)
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
  ],
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainNavigationScreen(),
    ),
    GoRoute(
      path: '/book-detail',
      builder: (context, state) => const BookDetailScreen(),
    ),
    GoRoute(
      path: '/reading',
      builder: (context, state) => const ReadingScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/writer-upload',
      builder: (context, state) => const WriterUploadScreen(),
    ),
    GoRoute(
      path: '/author-profile',
      builder: (context, state) => const AuthorProfileScreen(),
    ),
    GoRoute(
      path: '/bookmarks',
      builder: (context, state) => const BookmarksScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/library',
      builder: (context, state) => const LibraryScreen(),
    ),
    GoRoute(
      path: '/activity',
      builder: (context, state) => const ActivityScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
