import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/platform_utils.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _dailyReminder = true;
  bool _newArrivals = true;
  bool _autoTranslate = true;
  bool _zenMode = false;
  double _typographyScale = 18.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final secureStorage = ref.read(secureStorageServiceProvider);
    final daily = await secureStorage.read('daily_reminder');
    final arrivals = await secureStorage.read('new_arrivals');
    final typography = await secureStorage.read('typography_scale');
    
    if (mounted) {
      setState(() {
        if (daily != null) _dailyReminder = daily == 'true';
        if (arrivals != null) _newArrivals = arrivals == 'true';
        if (typography != null) _typographyScale = double.tryParse(typography) ?? 18.0;
      });
    }
  }

  Future<void> _saveSetting(String key, String value) async {
    await ref.read(secureStorageServiceProvider).write(key, value);
  }

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
            centerTitle: false,
            actions: const [],
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Header
                Text(
                  'Settings',
                  style: GoogleFonts.notoSerif(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Customize your intellectual sanctuary.',
                  style: GoogleFonts.inter(
                    color: Colors.white54,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 24),

                // Appearance Section
                _buildSectionHeader(Icons.dark_mode_outlined, 'Appearance'),
                const SizedBox(height: 12),
                _buildThemeCard(),

                const SizedBox(height: 24),

                // Alerts Section
                _buildSectionHeader(Icons.notifications_none_rounded, 'Alerts'),
                const SizedBox(height: 6),
                Text(
                  'Manage reading reminders and library updates.',
                  style: GoogleFonts.inter(color: Colors.white38, fontSize: 11),
                ),
                const SizedBox(height: 16),
                _buildCheckboxTile('Daily Reminder', _dailyReminder, (v) {
                  setState(() {
                    _dailyReminder = v!;
                  });
                  _saveSetting('daily_reminder', v.toString());
                  if (v == true) {
                    ref.read(notificationServiceProvider).scheduleDailyReminder();
                  } else {
                    ref.read(notificationServiceProvider).cancelDailyReminder();
                  }
                }),
                const SizedBox(height: 10),
                _buildCheckboxTile('New Arrivals', _newArrivals, (v) => setState(() { _newArrivals = v!; _saveSetting('new_arrivals', v.toString()); })),

                const SizedBox(height: 24),

                // Reading Engine Section
                _buildSectionHeader(Icons.menu_book_rounded, 'Reading Engine'),
                const SizedBox(height: 12),
                _buildReadingEngineCard(),

                const SizedBox(height: 24),

                // Data & Storage Section
                _buildSectionHeader(Icons.storage_rounded, 'Data & Storage'),
                const SizedBox(height: 12),
                _buildDataStorageCard(),

                const SizedBox(height: 24),

                // Support Section
                _buildSupportBanner(),

                const SizedBox(height: 32),

                // Footer Links
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFooterLink('PRIVACY POLICY'),
                      _buildFooterDivider(),
                      _buildFooterLink('TERMS OF SERVICE'),
                      _buildFooterDivider(),
                      _buildFooterLink('FEEDBACK'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Version 2.4.0-bookvista',
                    style: GoogleFonts.inter(color: Colors.white24, fontSize: 10, fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFD700), size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.notoSerif(
            color: const Color(0xFFFFD700),
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -8,
            child: Icon(Icons.palette_outlined, color: Colors.white.withOpacity(0.03), size: 60),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THEME MODE',
                    style: GoogleFonts.inter(color: const Color(0xFFFFD700), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'BookVista (OLED\nOptimized)',
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: true,
                  onChanged: (v) {},
                  activeColor: const Color(0xFFFFD700),
                  activeTrackColor: const Color(0xFFFFD700).withOpacity(0.2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallOptionCard(IconData icon, String label, {bool isYellow = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isYellow ? const Color(0xFFFFD700) : Colors.white24, size: 18),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              color: isYellow ? const Color(0xFFFFD700) : Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile(String label, bool value, Function(bool?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 20,
            height: 20,
            child: Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white10),
              child: Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xFFFFD700),
                checkColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingEngineCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A373).withOpacity(0.8),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Restore Defaults', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TYPOGRAPHY SCALE',
                style: GoogleFonts.inter(color: const Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
              Text(
                '${_typographyScale.toInt()}px',
                style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Slider(
            value: _typographyScale,
            min: 12,
            max: 32,
            activeColor: const Color(0xFFFFD700),
            inactiveColor: Colors.white.withOpacity(0.05),
            onChanged: (v) => setState(() {
              _typographyScale = v;
              _saveSetting('typography_scale', v.toString());
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('COMPACT', style: GoogleFonts.inter(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.bold)),
              Text('IMMERSIVE', style: GoogleFonts.inter(color: Colors.white24, fontSize: 8, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCard(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: value ? const Color(0xFFFFD700) : Colors.white24, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(color: value ? const Color(0xFFFFD700) : Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                Text(subtitle, style: GoogleFonts.inter(color: Colors.white24, fontSize: 11)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFFD700),
            activeTrackColor: const Color(0xFFFFD700).withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildDataStorageCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.cloud_done_rounded, color: Colors.white24, size: 20),
              const SizedBox(width: 12),
              Expanded(child: Text('Cloud Sync', style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))),
              Text('Active', style: GoogleFonts.inter(color: const Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Offline Library', style: GoogleFonts.inter(color: Colors.white38, fontSize: 13)),
              Text('1.2 GB / 5 GB', style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 1.2 / 5.0,
            backgroundColor: Colors.white.withOpacity(0.05),
            valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD700)),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: const Color(0xFFFFD700).withOpacity(0.3)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Clear Cache', style: TextStyle(color: Color(0xFFFFD700), fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFD4830D),
            const Color(0xFF8B5E0D),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Support the Creator',
            style: GoogleFonts.notoSerif(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          Text(
            'Enjoying the BookVista experience? Buy us a coffee to support independent book curation and reading tools.',
            style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, height: 1.5),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              if (isMobilePlatform) {
                FirebaseAnalytics.instance.logEvent(
                  name: 'gift_a_coffee_clicked',
                  parameters: {
                    'timestamp': DateTime.now().toIso8601String(),
                    'support_type': 'coffee',
                  },
                );
              }
              
              // Show on-screen feedback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('❤️ Thank you! Event "gift_a_coffee_clicked" logged to Firebase!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.favorite, size: 16),
            label: const Text('Gift a Coffee', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF020617),
              foregroundColor: const Color(0xFFFFD700),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
    );
  }

  Widget _buildFooterDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(width: 1, height: 10, color: Colors.white10),
    );
  }
}
