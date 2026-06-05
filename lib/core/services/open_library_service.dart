import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'logging_service.dart';

class OpenLibraryBook {
  final String title;
  final String author;
  final String? coverUrl;
  final String? key;

  OpenLibraryBook({
    required this.title,
    required this.author,
    this.coverUrl,
    this.key,
  });

  factory OpenLibraryBook.fromJson(Map<String, dynamic> json) {
    final authorNames = json['author_name'] as List?;
    final author = authorNames != null && authorNames.isNotEmpty
        ? authorNames.first.toString()
        : 'Unknown Author';

    final coverId = json['cover_i'] as int?;
    final coverUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
        : 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=200';

    return OpenLibraryBook(
      title: json['title'] ?? 'Untitled Book',
      author: author,
      coverUrl: coverUrl,
      key: json['key'],
    );
  }
}

class OpenLibraryService {
  final Ref _ref;

  OpenLibraryService(this._ref);

  Future<List<OpenLibraryBook>> searchBooks(String query) async {
    final log = _ref.read(loggerProvider);
    if (query.trim().isEmpty) return [];

    final url = Uri.parse('https://openlibrary.org/search.json?q=${Uri.encodeComponent(query)}&limit=7');
    log.i("Fetching from Open Library API: $url");

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final docs = data['docs'] as List?;
        if (docs != null) {
          log.i("Successfully fetched ${docs.length} books from Open Library API.");
          return docs.map((doc) => OpenLibraryBook.fromJson(doc as Map<String, dynamic>)).toList();
        }
        return [];
      } else {
        log.w("Open Library API returned status code: ${response.statusCode}");
        return [];
      }
    } catch (e, stack) {
      log.e("Error querying Open Library API", e, stack);
      return [];
    }
  }
}

// Provider for OpenLibraryService
final openLibraryServiceProvider = Provider<OpenLibraryService>((ref) => OpenLibraryService(ref));

// FutureProvider for search queries
final externalSearchProvider = FutureProvider.family<List<OpenLibraryBook>, String>((ref, query) async {
  if (query.isEmpty) return [];
  return ref.read(openLibraryServiceProvider).searchBooks(query);
});
