import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['Saved', 'Reading', 'Read'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Custom App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (Navigator.of(context).canPop())
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFD700), size: 18),
                            onPressed: () => context.pop(),
                          ),
                        if (Navigator.of(context).canPop()) const SizedBox(width: 8),
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
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.settings, color: Colors.white60, size: 22),
                          onPressed: () => context.push('/settings'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Library',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'A quiet corner for your literary journeys.',
                      style: GoogleFonts.inter(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: TabBar(
                  controller: _tabController,
                  tabs: _tabs.map((t) => Tab(text: t)).toList(),
                  labelColor: const Color(0xFFFFD700),
                  unselectedLabelColor: Colors.white24,
                  indicatorColor: const Color(0xFFFFD700),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.normal),
                  dividerColor: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Reading List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildReadingCard(
                    'The Midnight Library',
                    'Matt Haig',
                    'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400',
                    0.64,
                    ['FICTION', 'PHILOSOPHICAL'],
                  ),
                  const SizedBox(height: 16),
                  _buildReadingCard(
                    'Stardust Rituals',
                    'Elena Thorne',
                    'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=400',
                    0.12,
                    ['FANTASY', 'POETRY'],
                  ),
                  const SizedBox(height: 16),
                  // "Add new book" Section from Screenshot 2
                  _buildAddNewBookDashed(),
                  const SizedBox(height: 32),
                  
                  // Recently Visited Shelves Header
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Row(
                      children: [
                        Text(
                          'Recently Visited Shelves',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Shelves Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.1, // Adjusted from 1.4 to fix bottom overflow
                    children: [
                      _buildShelfCard('Classic Literature', '12 TITLES', Icons.history_edu),
                      _buildShelfCard('Philosophy', '8 TITLES', Icons.psychology_outlined),
                      _buildShelfCard('Fantasy Quest', '24 TITLES', Icons.menu_book),
                      _buildShelfCard('Morning Reads', '5 TITLES', Icons.coffee),
                    ],
                  ),
                  const SizedBox(height: 100),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingCard(String title, String author, String imageUrl, double progress, List<String> tags) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl, width: 80, height: 110, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Text(
                  author,
                  style: GoogleFonts.inter(color: Colors.white38, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PROGRESS', style: GoogleFonts.inter(color: const Color(0xFFFFD700).withOpacity(0.6), fontSize: 9, fontWeight: FontWeight.bold)),
                    Text('${(progress * 100).toInt()}%', style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
                  minHeight: 3,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1B4B).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.inter(color: const Color(0xFF818CF8), fontSize: 7, fontWeight: FontWeight.bold),
                    ),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewBookDashed() {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10, style: BorderStyle.solid, width: 1),
      ),
      child: DpDashedBorder(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, color: Colors.white24, size: 24),
              const SizedBox(height: 4),
              Text('Add new book', style: GoogleFonts.inter(color: Colors.white24, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShelfCard(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(icon, color: const Color(0xFFFFD700).withOpacity(0.15), size: 18),
            ],
          ),
          const Spacer(),
          Text(
            title, 
            style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: GoogleFonts.inter(color: Colors.white38, fontSize: 8, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class DpDashedBorder extends StatelessWidget {
  final Widget child;
  const DpDashedBorder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
