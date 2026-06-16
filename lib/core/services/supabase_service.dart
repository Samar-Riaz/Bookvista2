import 'package:supabase_flutter/supabase_flutter.dart';

bool isSupabaseInitialized = false;

class AuthService {
  SupabaseClient? get _supabase =>
      isSupabaseInitialized ? Supabase.instance.client : null;

  // Sign Up
  Future<AuthResponse> signUp(
      String email, String password, String name, String role) async {
    final client = _supabase;
    if (client == null) {
      throw StateError('Supabase is not configured. Unable to sign up.');
    }

    final response = await client.auth.signUp(
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
    final client = _supabase;
    if (client == null) {
      throw StateError('Supabase is not configured. Unable to sign in.');
    }

    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  }

  // Sign Out
  Future<void> signOut() async {
    final client = _supabase;
    if (client == null) return;
    await client.auth.signOut();
  }

  // Get Current User
  User? get currentUser => _supabase?.auth.currentUser;
}

class BookService {
  SupabaseClient? get _supabase =>
      isSupabaseInitialized ? Supabase.instance.client : null;

  // Fetch all books
  Future<List<Map<String, dynamic>>> fetchBooks() async {
    final client = _supabase;
    if (client == null) return [];

    final response = await client.from('books').select();
    return List<Map<String, dynamic>>.from(response);
  }

  // Fetch recommended books
  Future<List<Map<String, dynamic>>> fetchRecommendedBooks() async {
    final client = _supabase;
    if (client == null) return [];

    final response = await client.from('books').select().limit(5);
    return List<Map<String, dynamic>>.from(response);
  }

  // Search books
  Future<List<Map<String, dynamic>>> searchBooks(String query) async {
    final client = _supabase;
    if (client == null) return [];

    final response =
        await client.from('books').select().ilike('title', '%$query%');
    return List<Map<String, dynamic>>.from(response);
  }
}
