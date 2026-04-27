import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020617).withOpacity(0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFD700), size: 18),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'BookVista',
          style: GoogleFonts.satisfy(
            color: const Color(0xFFFFD700),
            fontSize: 22,
          ),
        ),
        actions: [
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your\nBookmarks',
                            style: GoogleFonts.notoSerif(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'A quiet corner for your curated thoughts and passages.',
                            style: GoogleFonts.inter(
                              color: Colors.white54,
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Section 1: The Midnight Library
                _buildSectionHeader('The Midnight Library'),
                const SizedBox(height: 24),
                _buildBookmarkCard(
                  'CHAPTER 04: THE CHESSBOARD',
                  'PAGE 142',
                  '"It is easy to mourn the lives we aren\'t living. Easy to wish we had developed other talents, said yes to different offers. It is easy to wish we had worked harder."',
                  underlinedText: 'Easy to wish we had developed other talents',
                ),
                const SizedBox(height: 16),
                _buildBookmarkCard(
                  'CHAPTER 09: REGRETS',
                  'PAGE 208',
                  '"Between life and death there is a library, and within that library, the shelves go on forever. Every book provides a chance to try another life you could have lived."',
                  underlinedText: 'Every book provides a chance',
                ),

                const SizedBox(height: 48),

                // Section 2: Circe
                _buildSectionHeader('Circe'),
                const SizedBox(height: 24),
                _buildBookmarkCard(
                  'CHAPTER 15: THE ISLAND OF AIAIA',
                  'PAGE 315',
                  '"But in a solitary life, there are rare moments when another soul dips near yours, as stars brush the earth once a year. Such a constellation was he to me."',
                  underlinedText: 'as stars brush the earth once a year',
                  hasEdit: true,
                ),

                const SizedBox(height: 48),

                // Section 3: Kafka on the Shore
                _buildSectionHeader('Kafka on the Shore'),
                const SizedBox(height: 24),
                _buildBookmarkCard(
                  'PART ONE: THE BOY NAMED CROW',
                  'PAGE 12',
                  '"And once the storm is over, you won\'t remember how you made it through, how you managed to survive. But one thing is certain."',
                  underlinedText: 'But one thing is certain.',
                ),

                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFFFFD700),
        child: const Icon(Icons.bookmark_add_rounded, color: Colors.black),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: Colors.white.withOpacity(0.05))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: GoogleFonts.satisfy(
              color: const Color(0xFFFFD700),
              fontSize: 22,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Expanded(child: Container(height: 1, color: Colors.white.withOpacity(0.05))),
      ],
    );
  }

  Widget _buildBookmarkCard(String chapter, String page, String quote, {String? underlinedText, bool hasEdit = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  chapter,
                  style: GoogleFonts.inter(color: const Color(0xFFFFD700), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                page,
                style: GoogleFonts.inter(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildQuoteText(quote, underlinedText),

          const SizedBox(height: 24),
          const Divider(color: Colors.white10),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'GO TO PAGE',
                style: GoogleFonts.inter(color: const Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Color(0xFFFFD700), size: 14),
              const Spacer(),
              if (hasEdit)
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white38, size: 18),
                  onPressed: () {},
                ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.white38, size: 18),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white38, size: 18),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteText(String quote, String? underlinedPart) {
    if (underlinedPart == null || !quote.contains(underlinedPart)) {
      return Text(
        quote,
        style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 14, height: 1.6),
      );
    }

    final parts = quote.split(underlinedPart);
    return RichText(
      text: TextSpan(
        style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 14, height: 1.6),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: underlinedPart,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Color(0xFFFFD700),
              decorationThickness: 2,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }
}
