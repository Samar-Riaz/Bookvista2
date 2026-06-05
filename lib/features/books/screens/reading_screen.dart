import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';

// Heavy parsing task running inside a background Isolate/Thread
Map<String, dynamic> parseBookTextStats(String text) {
  // Mock CPU-intensive work (syllables, search indices, caesar decryption checks)
  final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  int characterCount = text.length;
  int wordCount = words.length;
  
  double averageWordLength = wordCount > 0 ? (characterCount / wordCount) : 0.0;
  
  // Simulating cryptography decryption in background
  String encryptedSample = text.codeUnits.map((u) => String.fromCharCode(u + 2)).join();
  String decryptedSample = encryptedSample.codeUnits.map((u) => String.fromCharCode(u - 2)).join();

  // Artificial small delay to make the loader visible for verification
  return {
    'wordCount': wordCount,
    'characterCount': characterCount,
    'averageWordLength': averageWordLength.toStringAsFixed(1),
    'decryptedSample': decryptedSample.substring(0, minOf(30, decryptedSample.length)) + "...",
  };
}

int minOf(int a, int b) => a < b ? a : b;

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  double fontSize = 18.0;
  String selectedFont = 'Serif';
  Color selectedAmbiance = const Color(0xFF020617); // Blue Midnight
  double brightness = 0.7;
  bool _isProcessing = false;
  Map<String, dynamic>? _textStats;

  @override
  void initState() {
    super.initState();
    _startBackgroundParsing();
  }

  Future<void> _startBackgroundParsing() async {
    setState(() {
      _isProcessing = true;
    });

    const String chapterText = "I still remember the day my father took me to the Cemetery of Forgotten Books for the first time. It was the early summer of 1945, and we walked through the streets of a Barcelona trapped under ashen skies as the sun rose over Rambla de Santa Monica like a copper wreath. My father led me by the hand, through ancient lanes and gothic arcades...";

    // Offloading to background thread using compute Isolate
    final stats = await compute(parseBookTextStats, chapterText);

    if (mounted) {
      setState(() {
        _textStats = stats;
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedAmbiance,
      body: Stack(
        children: [
          // Reading Content
          SafeArea(
            child: Column(
              children: [
                // Custom Header
                _buildHeader(context),
                
                // Book Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'The Cemetery of Forgotten Books',
                          style: GoogleFonts.notoSerif(
                            color: Colors.white,
                            fontSize: 22,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 48),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.notoSerif(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: fontSize,
                              height: 1.7,
                            ),
                            children: [
                              const TextSpan(text: 'I still remember the day my father took me to the '),
                              WidgetSpan(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Cemetery of',
                                    style: GoogleFonts.notoSerif(
                                      color: Colors.white,
                                      fontSize: fontSize,
                                      height: 1.7,
                                    ),
                                  ),
                                ),
                              ),
                              const TextSpan(text: '\n'),
                              WidgetSpan(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Forgotten Books',
                                    style: GoogleFonts.notoSerif(
                                      color: Colors.white,
                                      fontSize: fontSize,
                                      height: 1.7,
                                    ),
                                  ),
                                ),
                              ),
                              const TextSpan(text: ' for the first time.\nIt was the early summer of 1945, and we walked through the streets of a Barcelona trapped under ashen...'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (_isProcessing)
                          const Center(child: CircularProgressIndicator(color: AppColors.accentDark))
                        else if (_textStats != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.bolt, color: AppColors.accentDark, size: 14),
                                    const SizedBox(width: 6),
                                    Text(
                                      'BACKGROUND ISOLATE THREAD PARSED',
                                      style: GoogleFonts.inter(
                                        color: AppColors.accentDark,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Words: ${_textStats!['wordCount']}', style: GoogleFonts.inter(color: Colors.white60, fontSize: 10)),
                                    Text('Chars: ${_textStats!['characterCount']}', style: GoogleFonts.inter(color: Colors.white60, fontSize: 10)),
                                    Text('Avg Word: ${_textStats!['averageWordLength']}', style: GoogleFonts.inter(color: Colors.white60, fontSize: 10)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Secure Decrypted Text Sample: "${_textStats!['decryptedSample']}"',
                                  style: GoogleFonts.inter(color: Colors.white38, fontSize: 9, fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom Spacing for Persistent Bar
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Draggable Settings Sheet
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.08,
            maxChildSize: 0.65,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF020617),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, -5)),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      // Handle
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionLabel('TYPOGRAPHY'),
                            const SizedBox(height: 16),
                            
                            // Font Size Slider
                            Row(
                              children: [
                                _buildIconBox(Icons.text_fields, size: 20),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: AppColors.accentDark,
                                      inactiveTrackColor: Colors.white12,
                                      thumbColor: AppColors.accentDark,
                                      overlayColor: AppColors.accentDark.withOpacity(0.1),
                                      trackHeight: 2,
                                    ),
                                    child: Slider(
                                      value: fontSize,
                                      min: 14,
                                      max: 30,
                                      onChanged: (val) => setState(() => fontSize = val),
                                    ),
                                  ),
                                ),
                                _buildIconBox(Icons.text_fields, size: 28),
                              ],
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Font Selector
                            Row(
                              children: [
                                _buildTogglePill('Serif', selectedFont == 'Serif', () => setState(() => selectedFont = 'Serif')),
                                const SizedBox(width: 8),
                                _buildTogglePill('Sans', selectedFont == 'Sans', () => setState(() => selectedFont = 'Sans')),
                                const SizedBox(width: 8),
                                _buildTogglePill('Literary', selectedFont == 'Literary', () => setState(() => selectedFont = 'Literary')),
                              ],
                            ),
                            
                            const SizedBox(height: 32),
                            _buildSectionLabel('AMBIANCE'),
                            const SizedBox(height: 16),
                            
                            // Ambiance Swatches
                            Row(
                              children: [
                                _buildColorSwatch(Colors.white, false, () {}),
                                const SizedBox(width: 12),
                                _buildColorSwatch(const Color(0xFFF5E6D3), false, () {}),
                                const SizedBox(width: 12),
                                _buildColorSwatch(const Color(0xFF020617), true, () => setState(() => selectedAmbiance = const Color(0xFF020617))),
                              ],
                            ),
                            
                            const SizedBox(height: 32),
                            _buildSectionLabel('ATMOSPHERE'),
                            const SizedBox(height: 16),
                            
                            // Brightness Slider
                            Row(
                              children: [
                                const Icon(Icons.wb_sunny_outlined, color: Colors.white38, size: 20),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: AppColors.accentDark,
                                      inactiveTrackColor: Colors.white12,
                                      thumbColor: AppColors.accentDark,
                                      trackHeight: 2,
                                    ),
                                    child: Slider(
                                      value: brightness,
                                      onChanged: (val) => setState(() => brightness = val),
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
                ),
              );
            },
          ),

          // Fixed Bottom Navigation Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.accentDark, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.menu_book, color: AppColors.accentDark, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'BookVista',
                    style: GoogleFonts.satisfy(
                      color: AppColors.accentDark,
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const SizedBox(width: 48), // Balance for back button
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'THE SHADOW OF THE WIND — CH. 4',
            style: GoogleFonts.inter(
              color: Colors.white38,
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.accentDark,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildIconBox(IconData icon, {required double size}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: AppColors.accentDark, size: size),
    );
  }

  Widget _buildTogglePill(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: active ? AppColors.accentDark : AppColors.surfaceDark,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: active ? Colors.black : Colors.white38,
              fontSize: 12,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              fontStyle: label == 'Literary' ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorSwatch(Color color, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: selected ? Border.all(color: AppColors.accentDark, width: 2) : null,
        ),
        child: selected ? const Icon(Icons.check, color: AppColors.accentDark, size: 16) : null,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF020617),
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          // Streak Info
          Expanded(
            flex: 4,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department, color: AppColors.accentDark, size: 20),
                const SizedBox(width: 6),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('DAILY STREAK', style: GoogleFonts.inter(color: Colors.white38, fontSize: 7, fontWeight: FontWeight.bold)),
                      Text('Reading Journey', style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Text('12', style: GoogleFonts.inter(color: AppColors.accentDark, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          // Progress Info
          Expanded(
            flex: 3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('42%', style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 2),
                    Text('completed', style: GoogleFonts.inter(color: Colors.white38, fontSize: 9)),
                  ],
                ),
                const SizedBox(height: 3),
                Container(
                  width: 45,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: 0.42,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.accentDark,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 8),
          const Icon(Icons.menu_book_outlined, color: Colors.white54, size: 20),
          const SizedBox(width: 12),
          const Icon(Icons.bookmark_outline, color: Colors.white54, size: 20),
        ],
      ),
    );
  }
}
