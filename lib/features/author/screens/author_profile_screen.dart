import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class AuthorProfileScreen extends StatelessWidget {
  const AuthorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: CustomScrollView(
        slivers: [
          // App Bar with Background
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF020617),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFD700), size: 18),
              onPressed: () => context.pop(),
            ),
            title: Row(
              children: [
                const Icon(Icons.menu_book, color: Color(0xFFFFD700), size: 20),
                const SizedBox(width: 8),
                Text(
                  'BookVista',
                  style: GoogleFonts.satisfy(
                    color: const Color(0xFFFFD700),
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            actions: const [],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&q=80&w=1000',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF020617).withOpacity(0.4),
                          const Color(0xFF020617),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=evelyn'),
                          ),
                        ).animate().scale(delay: 200.ms),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    'Evelyn Thorne',
                    style: GoogleFonts.notoSerif(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_outlined, color: Color(0xFFFFD700), size: 14),
                      const SizedBox(width: 4),
                      Text(
                        'London, UK',
                        style: GoogleFonts.inter(color: const Color(0xFFFFD700), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      '"Collector of vintage first editions and midnight coffee drinker."',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  _buildActionButton(Icons.edit_outlined, 'Edit Profile', isPrimary: true),
                  const SizedBox(height: 12),
                  _buildActionButton(Icons.bar_chart_rounded, 'View Analytics'),
                  const SizedBox(height: 12),
                  _buildActionButton(Icons.file_upload_outlined, 'Upload New Book'),

                  const SizedBox(height: 32),

                  // Stats Row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('8', 'BOOKS\nPUBLISHED'),
                        _buildDivider(),
                        _buildStatItem('45k', 'TOTAL\nREADS'),
                        _buildDivider(),
                        _buildStatItem('1.2k', 'FOLLOWERS'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Books Section
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Books by this Author',
                          style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildBookCard(
                          'Whispers in the\nCoffee Shop', 
                          'Mystery & Romance • 2023',
                          'https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&q=80&w=300'
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildBookCard(
                          'The Midnight\nParchment', 
                          'Historical Fiction • 2022',
                          'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&q=80&w=300'
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Q&A Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Reader Q&A',
                      style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildQACard(
                    '@NightOwlReader',
                    '"What\'s your favorite coffee blend to write with at night?"',
                    'Evelyn:',
                    'A dark Sumatra roast with a hint of cinnamon. It helps the words flow when the city is quiet.'
                  ),
                  const SizedBox(height: 16),
                  _buildQACard(
                    '@LibraryLover',
                    '"Will there be a sequel to \'Whispers\'?"',
                    'Evelyn:',
                    'The coffee shop still has many stories to tell. Stay tuned for early 2025!'
                  ),
                  const SizedBox(height: 24),
                  
                  // Ask Question Button
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10, style: BorderStyle.solid),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_box_outlined, color: Color(0xFFFFD700), size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Ask a Question',
                          style: GoogleFonts.inter(color: const Color(0xFFFFD700), fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, {bool isPrimary = false}) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFFFD700) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: isPrimary ? null : Border.all(color: Colors.white10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isPrimary ? Colors.black : const Color(0xFFFFD700), size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: isPrimary ? Colors.black : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.notoSerif(color: const Color(0xFFFFD700), fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 30, color: Colors.white10);
  }

  Widget _buildBookCard(String title, String info, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          info,
          style: GoogleFonts.inter(color: Colors.white38, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildQACard(String user, String question, String authorName, String answer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Color(0xFFFFD700), size: 14),
              ),
              const SizedBox(width: 10),
              Text(user, style: GoogleFonts.inter(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 4),
              Text(
                authorName,
                style: GoogleFonts.inter(color: const Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  answer,
                  style: GoogleFonts.inter(color: Colors.white60, fontSize: 11, height: 1.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
