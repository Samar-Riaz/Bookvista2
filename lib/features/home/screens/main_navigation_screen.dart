import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import 'activity_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0; // Default to Home

  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
    const LibraryScreen(),
    const ActivityScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 60,
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          border: Border(top: BorderSide(color: Colors.white10, width: 1)),
        ),
        child: Row(
          children: [
            Expanded(child: _buildNavItem(0, Icons.home_outlined, Icons.home, 'HOME')),
            Expanded(child: _buildNavItem(1, Icons.search_outlined, Icons.search, 'SEARCH')),
            Expanded(child: _buildNavItem(2, Icons.menu_book_outlined, Icons.menu_book, 'LIBRARY')),
            Expanded(child: _buildNavItem(3, Icons.timeline_outlined, Icons.timeline, 'ACTIVITY')),
            Expanded(child: _buildNavItem(4, Icons.person_outline, Icons.person, 'PROFILE')),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData selectedIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? AppColors.accentDark : Colors.white38,
            size: 20,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              color: isSelected ? AppColors.accentDark : Colors.white38,
              fontSize: 8,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          // Selected Dot
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accentDark : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
