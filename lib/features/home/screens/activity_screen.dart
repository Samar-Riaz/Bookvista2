import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            backgroundColor: const Color(0xFF020617).withOpacity(0.8),
            floating: true,
            pinned: true,
            leading: Navigator.of(context).canPop()
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFD700), size: 18),
                    onPressed: () => context.pop(),
                  )
                : const Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(Icons.menu_book, color: Color(0xFFFFD700), size: 20),
                  ),
            leadingWidth: Navigator.of(context).canPop() ? 40 : 56,
            title: Text(
              'BookVista',
              style: GoogleFonts.satisfy(
                color: const Color(0xFFFFD700),
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white60, size: 20),
                onPressed: () => context.push('/settings'),
              ),
              const SizedBox(width: 8),
            ],
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header
                Text(
                  'ANALYTICS & HISTORY',
                  style: GoogleFonts.inter(
                    color: const Color(0xFFFFD700),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your Activity',
                  style: GoogleFonts.notoSerif(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Cards
                _buildStatsCard(
                  'TOTAL READS', 
                  '14,282', 
                  Icons.visibility_outlined,
                  pill: '+12% this week',
                ),
                const SizedBox(height: 10),
                _buildStatsCard('LIKES', '1,894', Icons.favorite_rounded),
                const SizedBox(height: 10),
                _buildStatsCard('COMMENTS', '432', Icons.chat_bubble_outline),

                const SizedBox(height: 24),

                // Recent History Section
                Row(
                  children: [
                    const Icon(Icons.menu_book_rounded, color: Color(0xFFFFD700), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Recent History',
                      style: GoogleFonts.notoSerif(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildHistoryCard(
                  'The Shadow of The Wind', 
                  'Carlos Ruiz Zafón', 
                  'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?auto=format&fit=crop&q=80&w=200', 
                  0.75, 
                  '2H AGO'
                ),
                const SizedBox(height: 10),
                _buildHistoryCard(
                  'Midnight Library', 
                  'Matt Haig', 
                  'https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&q=80&w=200', 
                  0.4, 
                  'YESTERDAY'
                ),

                const SizedBox(height: 24),

                // Audience Insights Section
                Row(
                  children: [
                    const Icon(Icons.insights_rounded, color: Color(0xFFFFD700), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Audience Insights',
                      style: GoogleFonts.notoSerif(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInsightsCard(),

                const SizedBox(height: 32),

                // Top Commenters Section
                _buildTopCommentersCard(),

                const SizedBox(height: 24),

                // Support Card
                _buildSupportCard(),

                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String label, String value, IconData icon, {String? pill}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFFFFD700), size: 18),
              ),
              if (pill != null)
                Text(
                  pill,
                  style: GoogleFonts.inter(color: const Color(0xFFFFD700), fontSize: 9, fontWeight: FontWeight.bold),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.white38, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String title, String author, String imageUrl, double progress, String time) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imageUrl, width: 44, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.inter(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  author,
                  style: GoogleFonts.inter(color: Colors.white38, fontSize: 11, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                Stack(
                  children: [
                    Container(
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Engagement',
            style: GoogleFonts.inter(color: Colors.white38, fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBar(0.4),
              _buildBar(0.6),
              _buildBar(0.3),
              _buildBar(0.8, isActive: true),
              _buildBar(0.4),
              _buildBar(0.7, isActive: true),
              _buildBar(0.3),
              _buildBar(0.9, isActive: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double height, {bool isActive = false}) {
    return Container(
      width: 16,
      height: 70 * height,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFFD700) : const Color(0xFFFFD700).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildTopCommentersCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Commenters',
            style: GoogleFonts.inter(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildCommenterRow('Elena Vance', '12 COMMENTS'),
          const Divider(color: Colors.white10, height: 24),
          _buildCommenterRow('Julian Gray', '8 COMMENTS'),
        ],
      ),
    );
  }

  Widget _buildCommenterRow(String name, String count) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.indigo.shade900,
          child: const Icon(Icons.person, size: 14, color: Colors.white38),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              Text(count, style: GoogleFonts.inter(color: const Color(0xFFFFD700), fontSize: 9, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.white10, size: 16),
      ],
    );
  }

  Widget _buildSupportCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFD4A373).withOpacity(0.2),
            const Color(0xFF0F172A).withOpacity(0.5),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD4A373).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.coffee_rounded, color: Color(0xFFFFD700), size: 28),
          const SizedBox(height: 16),
          Text(
            'Buy a Coffee',
            style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Your readers have sent you 12 coffees this month. Keep writing!',
            style: GoogleFonts.inter(color: Colors.white60, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('View Supporters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}
