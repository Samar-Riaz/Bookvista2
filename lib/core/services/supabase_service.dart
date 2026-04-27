import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  // Sign Up
  Future<AuthResponse> signUp(String email, String password, String name, String role) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': name,
        'role': role,
      },
    );
    return response;
  }

  // Sign In
  Future<AuthResponse> signIn(String email, String password) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  // Sign Out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get Current User
  User? get currentUser => _supabase.auth.currentUser;
}

class BookService {
  final _supabase = Supabase.instance.client;

  // Fetch all books
  Future<List<Map<String, dynamic>>> fetchBooks() async {
    final response = await _supabase.from('books').select();
    return List<Map<String, dynamic>>.from(response);
  }

  // Fetch recommended books
  Future<List<Map<String, dynamic>>> fetchRecommendedBooks() async {
    final response = await _supabase.from('books').select().limit(5);
    return List<Map<String, dynamic>>.from(response);
  }

  // Search books
  Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    final response = await _supabase
        .from('books')
        .select()
        .ilike('title', '%$query%');
    return List<Map<String, dynamic>>.from(response);
  }
}
