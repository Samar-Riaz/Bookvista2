import 'package:logger/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoggingService {
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, // Number of method calls to be printed
      errorMethodCount: 5, // Number of method calls if stacktrace is provided
      lineLength: 80, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: true, // Should each log be printed with a timestamp
    ),
  );

  void d(String message) => _logger.d(message);
  void i(String message) => _logger.i(message);
  void w(String message) => _logger.w(message);
  void e(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
}

// Provider for LoggingService
final loggerProvider = Provider<LoggingService>((ref) => LoggingService());
