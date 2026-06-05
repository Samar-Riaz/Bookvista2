import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../core/services/ad_service.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/utils/book_mapper.dart';
import '../../../core/theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 400;
    final isMediumScreen = size.width >= 400 && size.width < 700;
    final isLargeScreen = size.width >= 700;

    // Responsive padding and spacing values
    final screenPadding = isSmallScreen ? 14.0 : (isMediumScreen ? 18.0 : 22.0);
    final sectionSpacing = isSmallScreen ? 18.0 : 28.0;
    final headingFontSize = isSmallScreen ? 15.0 : (isMediumScreen ? 18.0 : 20.0);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Background Radial Gradients (Scaled)
          Positioned(
            top: -size.width * 0.2,
            right: -size.width * 0.2,
            child: Container(
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [AppColors.plumGlow, Colors.transparent],
                ),
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              // Custom Top App Bar
              SliverAppBar(
                backgroundColor: AppColors.backgroundDark.withOpacity(0.8),
                expandedHeight: isSmallScreen ? 70 : 80,
                floating: true,
                pinned: true,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: FlexibleSpaceBar(
                      titlePadding: EdgeInsets.symmetric(
                        horizontal: screenPadding,
                        vertical: 16,
                      ),
                      title: Row(
                        children: [
                          Icon(Icons.menu_book,
                              color: AppColors.accentDark,
                              size: isSmallScreen ? 20 : 24),
                          const SizedBox(width: 8),
                          Text(
                            'BookVista',
                            style: GoogleFonts.satisfy(
                              color: AppColors.accentDark,
                              fontSize: isSmallScreen ? 20 : 24,
                              fontStyle: FontStyle.italic,
                              shadows: [
                                Shadow(
                                    color: AppColors.accentDark.withOpacity(0.4),
                                    blurRadius: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                      centerTitle: false,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white60),
                    onPressed: () => context.push('/settings'),
                  ),
                  const SizedBox(width: 8),
                ],
              ),

              SliverPadding(
                padding: EdgeInsets.all(screenPadding),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Recommended Section
                    _buildSectionHeader(context, 'Recommended For You',
                        showArrow: true,
                        onTap: () => context.push('/reading'),
                        isSmall: isSmallScreen,
                        headingFontSize: headingFontSize),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => context.push('/reading'),
                      child: _buildHeroCarousel(context, isSmallScreen, isMediumScreen),
                    ),

                    SizedBox(height: sectionSpacing),

                    // Recent Picks Section
                    _buildSectionHeader(context, 'Recent Picks',
                        icon: Icons.more_horiz,
                        isSmall: isSmallScreen,
                        headingFontSize: headingFontSize),
                    const SizedBox(height: 12),
                    _buildRecentPicksList(
                        context, ref, isSmallScreen, isMediumScreen),

                    SizedBox(height: sectionSpacing),

                    // Google Mobile Ads - Test Banner
                    const BookVistaBannerAd(),

                    SizedBox(height: sectionSpacing),

                    // Top Hit Books Section
                    _buildSectionHeader(context, 'Top Hit Books',
                        isSmall: isSmallScreen,
                        headingFontSize: headingFontSize),
                    const SizedBox(height: 16),
                    _buildTopHitsGrid(context, ref, isSmallScreen, isMediumScreen,
                        isLargeScreen),

                    const SizedBox(height: 48),

                    // Aesthetic Separator
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          3,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Opacity(
                              opacity: 0.2,
                              child: Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.accentDark,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      {bool showArrow = false,
      VoidCallback? onTap,
      IconData? icon,
      bool filters = false,
      required bool isSmall,
      required double headingFontSize}) {
    return InkWell(
      onTap: onTap ?? (showArrow ? () {} : null),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.notoSerif(
                  color: AppColors.textPrimaryDark,
                  fontSize: headingFontSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (showArrow) ...[
                const SizedBox(width: 8),
                Icon(Icons.chevron_right,
                    color: AppColors.accentDark.withOpacity(0.5), size: 20),
              ],
            ],
          ),
          if (icon != null) Icon(icon, color: Colors.white24),
          if (filters)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterChip('WEEKLY', true, isSmall),
                const SizedBox(width: 4),
                _buildFilterChip('MONTHLY', false, isSmall),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool active, bool isSmall) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 6 : 12, vertical: isSmall ? 4 : 6),
      decoration: BoxDecoration(
        color: active ? AppColors.accentDark.withOpacity(0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: active
            ? Border.all(color: AppColors.accentDark.withOpacity(0.2))
            : null,
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: active
              ? AppColors.accentDark
              : AppColors.textPrimaryDark.withOpacity(0.4),
          fontSize: isSmall ? 9 : 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildHeroCarousel(BuildContext context, bool isSmall, bool isMedium) {
    // Responsive height for carousel
    double carouselHeight = isSmall ? 260 : (isMedium ? 320 : 380);

    // Responsive font sizes
    double titleSize = isSmall ? 20 : (isMedium ? 24 : 28);
    double subtitleSize = isSmall ? 12 : (isMedium ? 14 : 15);

    return Container(
      height: carouselHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.shade900.withOpacity(0.4),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&q=80&w=800',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundDark.withOpacity(0.4),
                      AppColors.backgroundDark,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isSmall ? 20 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.accentDark.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accentDark.withOpacity(0.4)),
                    ),
                    child: Text(
                      'EDITOR\'S CHOICE',
                      style: GoogleFonts.inter(
                        color: AppColors.accentDark,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'The Midnight Library of Secrets',
                    style: GoogleFonts.notoSerif(
                      color: AppColors.textPrimaryDark,
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"Between life and death there is a library."',
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimaryDark.withOpacity(0.7),
                      fontSize: subtitleSize,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.push('/reading'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentDark,
                        foregroundColor: AppColors.backgroundDark,
                        padding: EdgeInsets.symmetric(
                            horizontal: isSmall ? 16 : 24, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text('START READING',
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: isSmall ? 11 : 13)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildBooksLoading(double height) {
    return SizedBox(
      height: height,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.accentDark),
      ),
    );
  }

  Widget _buildBooksMessage(double height, String message) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(
          message,
          style: GoogleFonts.inter(
            color: AppColors.textPrimaryDark.withOpacity(0.5),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildRecentPicksList(
      BuildContext context, WidgetRef ref, bool isSmall, bool isMedium) {
    final cardWidth = isSmall ? 120.0 : (isMedium ? 140.0 : 160.0);
    final listHeight = isSmall ? 210.0 : (isMedium ? 240.0 : 280.0);

    final booksAsync = ref.watch(recommendedBooksProvider);

    return booksAsync.when(
      loading: () => _buildBooksLoading(listHeight),
      error: (error, _) => _buildBooksMessage(
        listHeight,
        'Could not load recent picks.\nAdd books in Supabase.',
      ),
      data: (books) {
        if (books.isEmpty) {
          return _buildBooksMessage(
            listHeight,
            'No books in your Supabase `books` table yet.',
          );
        }

        final picks =
            books.map(toRecentPickMap).toList(growable: false);

        return SizedBox(
          height: listHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: picks.length,
            itemBuilder: (context, index) {
              final pick = picks[index];
          return GestureDetector(
            onTap: () => context.push('/reading'),
            child: Container(
              width: cardWidth,
              margin: const EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child:
                                  Image.network(pick['cover'] as String, fit: BoxFit.cover),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: SizedBox(
                                      width: isSmall ? 30 : 40,
                                      height: 3,
                                      child: LinearProgressIndicator(
                                        value: pick['progress'] as double,
                                        backgroundColor: Colors.white12,
                                        valueColor: const AlwaysStoppedAnimation(
                                            AppColors.accentDark),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pick['title'] as String,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: isSmall ? 12 : 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    (pick['author'] as String).toUpperCase(),
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimaryDark.withOpacity(0.4),
                      fontSize: isSmall ? 9 : 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),
          );
            },
          ),
        );
      },
    );
  }

  Widget _buildTopHitsGrid(BuildContext context, WidgetRef ref, bool isSmall,
      bool isMedium, bool isLarge) {
    final coverWidth = isSmall ? 54.0 : (isMedium ? 64.0 : 74.0);
    final coverHeight = isSmall ? 76.0 : (isMedium ? 90.0 : 104.0);
    final itemPadding = isSmall ? 10.0 : (isMedium ? 12.0 : 14.0);
    final titleFontSize = isSmall ? 13.0 : (isMedium ? 15.0 : 17.0);
    final authorFontSize = isSmall ? 10.0 : (isMedium ? 11.0 : 13.0);

    final booksAsync = ref.watch(booksProvider);

    return booksAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.accentDark),
        ),
      ),
      error: (error, _) => _buildBooksMessage(
        120,
        'Could not load top books from Supabase.',
      ),
      data: (books) {
        if (books.isEmpty) {
          return _buildBooksMessage(
            120,
            'No books found. Seed your `books` table in Supabase.',
          );
        }

        final hits = books
            .take(8)
            .toList()
            .asMap()
            .entries
            .map((e) => toTopHitMap(e.value, e.key + 1))
            .toList();

        if (isLarge) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: hits.length,
            itemBuilder: (context, index) {
              return _buildTopHitCard(
                context,
                hits[index],
                coverWidth,
                coverHeight,
                itemPadding,
                titleFontSize,
                authorFontSize,
              );
            },
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: hits.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildTopHitCard(
                context,
                hits[index],
                coverWidth,
                coverHeight,
                itemPadding,
                titleFontSize,
                authorFontSize,
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildTopHitCard(BuildContext context, Map<String, dynamic> hit, double coverWidth,
      double coverHeight, double itemPadding, double titleFontSize, double authorFontSize) {
    return GestureDetector(
      onTap: () => context.push('/book-detail'),
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(itemPadding),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.amber.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        hit['cover'] as String,
                        width: coverWidth,
                        height: coverHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: const BoxDecoration(
                          color: AppColors.accentDark,
                          borderRadius:
                              BorderRadius.only(bottomRight: Radius.circular(8)),
                        ),
                        child: Text(
                          '#${hit['rank']}',
                          style: TextStyle(
                              color: AppColors.backgroundDark,
                              fontWeight: FontWeight.bold,
                              fontSize: coverWidth * 0.12),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: itemPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        hit['title'] as String,
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                        ),
                      ),
                      Text(
                        hit['author'] as String,
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimaryDark.withOpacity(0.4),
                          fontSize: authorFontSize,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.accentDark, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${hit['rating']}',
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${hit['reviews']} reviews',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.3), fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookVistaBannerAd extends ConsumerStatefulWidget {
  const BookVistaBannerAd({super.key});

  @override
  ConsumerState<BookVistaBannerAd> createState() => _BookVistaBannerAdState();
}

class _BookVistaBannerAdState extends ConsumerState<BookVistaBannerAd> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadAd() {
    final banner = ref.read(adServiceProvider).loadBannerAd(
      size: AdSize.banner,
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _isAdLoaded = true;
          });
        }
      },
      onAdFailedToLoad: (ad, error) {
        // Handled in ad service logs
      },
    );
    if (banner == null) return;
    _bannerAd = banner;
    _bannerAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}