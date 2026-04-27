import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // Header AppBar
          SliverAppBar(
            backgroundColor: AppColors.backgroundDark,
            elevation: 0,
            floating: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.accentDark, size: 20),
              onPressed: () => context.pop(),
            ),
            title: Row(
              children: [
                const Icon(Icons.menu_book, color: AppColors.accentDark, size: 20),
                const SizedBox(width: 8),
                Text(
                  'BookVista',
                  style: GoogleFonts.satisfy(
                    color: AppColors.accentDark,
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      Shadow(color: AppColors.accentDark.withOpacity(0.4), blurRadius: 8),
                    ],
                  ),
                ),
              ],
            ),
            actions: const [],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Book Cover
                  Center(
                    child: Container(
                      height: 280, // Reduced from 380
                      width: 200, // Fixed width for better proportions
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=800'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Metadata
                  Text(
                    'BESTSELLER • PHILOSOPHY',
                    style: GoogleFonts.inter(
                      color: AppColors.accentDark,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "The Alchemist's\nQuill",
                    style: GoogleFonts.notoSerif(
                      color: Colors.white,
                      fontSize: 26, // Reduced from 32
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'by Julian Thorne',
                    style: GoogleFonts.notoSerif(
                      color: AppColors.accentDark,
                      fontSize: 18, // Reduced from 22
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Stats Row
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (index) => const Icon(Icons.star, color: AppColors.accentDark, size: 16),
                        ),
                      ),
                      Text(
                        '4.8 (2.4k reviews)',
                        style: GoogleFonts.inter(color: Colors.white60, fontSize: 12),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.menu_book, color: Colors.white38, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '412 Pages',
                            style: GoogleFonts.inter(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => context.push('/reading'),
                          icon: const Icon(Icons.play_arrow_rounded, size: 20),
                          label: const Text('Read Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentDark,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.bookmark_outline, color: Colors.white70),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.translate, color: Colors.white38, size: 16),
                        const SizedBox(width: 8),
                        Text('English', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.white38, size: 16),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Synopsis
                  Row(
                    children: [
                      Text(
                        'Synopsis',
                        style: GoogleFonts.notoSerif(
                          color: Colors.white,
                          fontSize: 20, // Reduced from 24
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'In the dim-lit alleys of 19th-century Prague, a young scrivener discovers a quill that writes the future before it happens. As Julian Thorne weaves a tale of destiny and consequence, the reader is pulled into a world where every drop of ink carries the weight of a soul.',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "The Alchemist's Quill is not just a mystery; it's an exploration of creative obsession and the thin line between making history and being haunted by it.",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Publisher Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildPubInfo('PUBLISHER', 'Midnight Press')),
                            Expanded(child: _buildPubInfo('PUBLISHED', 'Oct 2023')),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _buildPubInfo('ISBN-13', '978-0123456789')),
                            Expanded(child: _buildPubInfo('LANGUAGE', 'English')),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Reviews
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Reader Reviews',
                        style: GoogleFonts.notoSerif(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Write a Review',
                          style: GoogleFonts.inter(
                            color: AppColors.accentDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildReviewCard(
                    'Elena Moretti',
                    '2 days ago',
                    'Atmospheric and haunting. The description of the coffee shop scenes made me want to grab a latte and never leave the world Julian created.',
                    'EM',
                  ),
                  const SizedBox(height: 16),
                  _buildReviewCard(
                    'James Kovic',
                    '1 week ago',
                    'The pacing in the middle was a bit slow, but the ending was absolutely masterful. One of the best historical fantasies I\'ve read this year.',
                    'JK',
                  ),

                  const SizedBox(height: 48),

                  // More by Author
                  Text(
                    'More by Julian Thorne',
                    style: GoogleFonts.notoSerif(
                      color: Colors.white,
                      fontSize: 20, // Reduced from 24
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildAuthorBookRow('The Silent Library', 'Mystery', '2021', 'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=200'),
                  const SizedBox(height: 16),
                  _buildAuthorBookRow('Whispers of the Oak', 'Fantasy', '2019', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=200'),

                  const SizedBox(height: 48),

                  // Reading Progress
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reading Progress',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: 0.45,
                          backgroundColor: Colors.white10,
                          valueColor: const AlwaysStoppedAnimation(AppColors.accentDark),
                          minHeight: 6,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('PAGE 185', style: GoogleFonts.inter(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
                            Text('45% COMPLETE', style: GoogleFonts.inter(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Writer's Blend
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accentDark.withOpacity(0.3), style: BorderStyle.solid),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.coffee, color: AppColors.accentDark, size: 32),
                        const SizedBox(height: 16),
                        Text(
                          "Writer's Blend",
                          style: GoogleFonts.notoSerif(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A curated playlist for reading this book',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.headphones_outlined),
                          label: const Text('Listen Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: AppColors.accentDark,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            side: const BorderSide(color: AppColors.accentDark),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPubInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.1),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildReviewCard(String name, String date, String content, String initials) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B2E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.accentDark.withOpacity(0.2),
                radius: 18,
                child: Text(initials, style: const TextStyle(color: AppColors.accentDark, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(date, style: GoogleFonts.inter(color: Colors.white38, fontSize: 11)),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => const Icon(Icons.star, color: AppColors.accentDark, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '"$content"',
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorBookRow(String title, String genre, String year, String imageUrl) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(imageUrl, width: 60, height: 80, fit: BoxFit.cover),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text('$genre • $year', style: GoogleFonts.inter(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 8),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(Icons.star, color: index < 4 ? AppColors.accentDark : Colors.white10, size: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
