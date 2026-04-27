import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class WriterUploadScreen extends StatefulWidget {
  const WriterUploadScreen({super.key});

  @override
  State<WriterUploadScreen> createState() => _WriterUploadScreenState();
}

class _WriterUploadScreenState extends State<WriterUploadScreen> {
  bool _publishByChapters = true;
  bool _enableAutoTranslation = false;
  String _selectedGenre = 'Literary Fiction';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020617).withOpacity(0.8),
        elevation: 0,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFD700), size: 18),
                onPressed: () => context.pop(),
              )
            : const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Icon(Icons.menu_book, color: Color(0xFFFFD700), size: 20),
              ),
        title: Row(
          children: [
            if (Navigator.of(context).canPop())
              const Icon(Icons.menu_book, color: Color(0xFFFFD700), size: 20),
            if (Navigator.of(context).canPop()) const SizedBox(width: 8),
            Text(
              'BookVista',
              style: GoogleFonts.satisfy(
                color: const Color(0xFFFFD700),
                fontSize: 22,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Create New Story',
              style: GoogleFonts.notoSerif(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pour your thoughts onto the digital canvas.',
              style: GoogleFonts.inter(
                color: Colors.white54,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 32),

            // Book Cover Section
            Text(
              'BOOK COVER',
              style: GoogleFonts.inter(
                color: const Color(0xFFFFD700),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 380,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10, style: BorderStyle.solid),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, color: Colors.white24, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    'Click to upload cover',
                    style: GoogleFonts.notoSerif(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Recommended 1600x2400px',
                    style: GoogleFonts.inter(color: Colors.white24, fontSize: 11),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Inputs
            _buildInputLabel('TITLE'),
            _buildTextField('Whispers in the Coffee Shop...'),
            
            const SizedBox(height: 24),
            _buildInputLabel('DESCRIPTION'),
            _buildTextField('Briefly describe your masterpiece...', maxLines: 5),

            const SizedBox(height: 24),
            _buildInputLabel('GENRE'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedGenre,
                  dropdownColor: const Color(0xFF0F172A),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white38),
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                  items: ['Literary Fiction', 'Mystery', 'Romance', 'Sci-Fi', 'Non-Fiction']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedGenre = v!),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Settings Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withOpacity(0.4),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Column(
                children: [
                  _buildToggleRow(
                    Icons.layers_outlined, 
                    'Publish by Chapters', 
                    'Allow readers to follow your progress', 
                    _publishByChapters, 
                    (v) => setState(() => _publishByChapters = v)
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Colors.white.withOpacity(0.05)),
                  ),
                  _buildCheckboxRow(
                    Icons.translate_rounded, 
                    'Enable auto-translation', 
                    'Reach readers across the globe', 
                    _enableAutoTranslation, 
                    (v) => setState(() => _enableAutoTranslation = v!)
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // Publish Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Publish Story',
                      style: GoogleFonts.notoSerif(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.auto_awesome, size: 20),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle)),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: const Color(0xFFFFD700),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.white10, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFF0F172A).withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
    );
  }

  Widget _buildToggleRow(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFD700), size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              Text(subtitle, style: GoogleFonts.inter(color: Colors.white24, fontSize: 11)),
            ],
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFFD700),
            activeTrackColor: const Color(0xFFFFD700).withOpacity(0.2),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxRow(IconData icon, String title, String subtitle, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFD700), size: 20),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              Text(subtitle, style: GoogleFonts.inter(color: Colors.white24, fontSize: 11)),
            ],
          ),
        ),
        SizedBox(
          width: 24,
          height: 24,
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
    );
  }
}
