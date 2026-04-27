import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/supabase_service.dart';

final authServiceProvider = Provider((ref) => AuthService());
final bookServiceProvider = Provider((ref) => BookService());

// Provider for fetching books
final booksProvider = FutureProvider((ref) async {
  final bookService = ref.watch(bookServiceProvider);
  return bookService.fetchBooks();
});

// Provider for recommended books
final recommendedBooksProvider = FutureProvider((ref) async {
  final bookService = ref.watch(bookServiceProvider);
  return bookService.fetchRecommendedBooks();
});
