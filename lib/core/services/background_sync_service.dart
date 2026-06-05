import 'package:workmanager/workmanager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'logging_service.dart';
import '../utils/platform_utils.dart';

// Top-Level background dispatcher (must be top-level or static)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Note: Since this runs in a separate background isolate, we construct a standalone logger
    final logger = LoggingService();
    logger.i("Background task started: $task");

    try {
      if (task == "syncOfflineBooksTask") {
        logger.i("Synchronizing offline book sessions with Supabase backend...");
        // Mocking work (network check, data validation)
        await Future.delayed(const Duration(seconds: 2));
        logger.i("Offline books successfully synced in background!");
      }
      return Future.value(true);
    } catch (e, stack) {
      logger.e("Failed to execute background task: $task", e, stack);
      return Future.value(false);
    }
  });
}

class BackgroundSyncService {
  final Ref _ref;

  BackgroundSyncService(this._ref);

  // Initialize Workmanager
  Future<void> init() async {
    if (!isMobilePlatform) return;
    final log = _ref.read(loggerProvider);
    log.i("Initializing Workmanager Background Tasks...");
    try {
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: true, // Show notification and toast for debugging execution
      );
      log.i("Workmanager initialized successfully.");
    } catch (e, stack) {
      log.e("Error initializing Workmanager", e, stack);
    }
  }

  // Schedule background sync task
  Future<void> registerPeriodicSyncTask() async {
    if (!isMobilePlatform) return;
    final log = _ref.read(loggerProvider);
    log.i("Registering periodic background synchronization task...");
    try {
      await Workmanager().registerPeriodicTask(
        "periodic-book-sync",
        "syncOfflineBooksTask",
        frequency: const Duration(minutes: 15), // Run every 15 minutes (minimum allowed by Android)
        constraints: Constraints(
          networkType: NetworkType.connected, // Only run if connected to network
          requiresBatteryNotLow: true,
        ),
      );
      log.i("Periodic background synchronization task registered successfully.");
    } catch (e, stack) {
      log.e("Error registering background sync task", e, stack);
    }
  }
}

// Provider for BackgroundSyncService
final backgroundSyncServiceProvider = Provider<BackgroundSyncService>((ref) => BackgroundSyncService(ref));
