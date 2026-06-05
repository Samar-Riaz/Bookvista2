/// Maps Supabase `books` row fields to UI display values.
/// Expected columns: title, author, cover_url (optional: progress, rating, reviews_count, genre).

const String kDefaultBookCover =
    'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?auto=format&fit=crop&q=80&w=300';

String bookTitle(Map<String, dynamic> book) {
  final title = book['title']?.toString().trim();
  return (title != null && title.isNotEmpty) ? title : 'Untitled';
}

String bookAuthor(Map<String, dynamic> book) {
  final author = book['author']?.toString().trim();
  return (author != null && author.isNotEmpty) ? author : 'Unknown';
}

String bookCoverUrl(Map<String, dynamic> book) {
  final url = book['cover_url']?.toString().trim();
  return (url != null && url.isNotEmpty) ? url : kDefaultBookCover;
}

double bookProgress(Map<String, dynamic> book) {
  final value = book['progress'];
  if (value is num) return value.clamp(0.0, 1.0).toDouble();
  return 0.5;
}

double bookRating(Map<String, dynamic> book) {
  final value = book['rating'];
  if (value is num) return value.toDouble();
  return 4.5;
}

String bookReviewsLabel(Map<String, dynamic> book) {
  final raw = book['reviews_count'] ?? book['reviews'];
  if (raw == null) return '—';
  return raw.toString();
}

List<String> bookTags(Map<String, dynamic> book) {
  final genre = book['genre']?.toString().trim();
  if (genre != null && genre.isNotEmpty) {
    return [genre.toUpperCase()];
  }
  if (book['tags'] is List) {
    return (book['tags'] as List)
        .map((e) => e.toString().toUpperCase())
        .where((t) => t.isNotEmpty)
        .take(2)
        .toList();
  }
  return const ['READING'];
}

Map<String, dynamic> toRecentPickMap(Map<String, dynamic> book) => {
      'title': bookTitle(book),
      'author': bookAuthor(book),
      'progress': bookProgress(book),
      'cover': bookCoverUrl(book),
    };

Map<String, dynamic> toTopHitMap(Map<String, dynamic> book, int rank) => {
      'title': bookTitle(book),
      'author': bookAuthor(book),
      'rank': rank,
      'rating': bookRating(book),
      'reviews': bookReviewsLabel(book),
      'cover': bookCoverUrl(book),
    };
