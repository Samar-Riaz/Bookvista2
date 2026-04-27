import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    
    // Animate the progress bar
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (_progress < 1.0) {
          _progress += 0.02;
        } else {
          _timer.cancel();
          context.go('/onboarding');
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617), // Midnight Plum Night
      body: Stack(
        children: [
          // Background texture (subtle dots)
          Positioned.fill(
            child: CustomPaint(
              painter: DotGridPainter(),
            ),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Coffee Cup Icon with Steam
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.coffee,
                      size: 42,
                      color: Color(0xFFFBBF24), // Amber/Yellow
                    ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.8, 0.8)),
                    
                    // Subtle Steam line
                    Positioned(
                      top: -15,
                      child: Container(
                        width: 2,
                        height: 15,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              const Color(0xFFFBBF24).withOpacity(0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ).animate(onPlay: (c) => c.repeat())
                       .moveY(begin: 5, end: -15, duration: 1500.ms)
                       .fadeOut(),
                    ),
                  ],
                ),
                
                const SizedBox(height: 48),
                
                // BookVista Title
                Text(
                  'BookVista',
                  style: GoogleFonts.satisfy(
                    color: const Color(0xFFFBBF24),
                    fontSize: 64,
                    shadows: [
                      Shadow(
                        color: const Color(0xFFFBBF24).withOpacity(0.3),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 1000.ms, delay: 200.ms).moveY(begin: 10, end: 0),
                
                const SizedBox(height: 16),
                
                // Tagline
                Text(
                  'Brew your next chapter',
                  style: GoogleFonts.notoSerif(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                  ),
                ).animate().fadeIn(duration: 1000.ms, delay: 600.ms),
                
                const SizedBox(height: 80),
                
                // Progress Bar Container
                SizedBox(
                  width: 200,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: _progress,
                          backgroundColor: Colors.white.withOpacity(0.05),
                          valueColor: const AlwaysStoppedAnimation(Color(0xFFFBBF24)),
                          minHeight: 2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'WARMING UP',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 4,
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true))
                       .fadeIn(duration: 1000.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Footer
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF422006), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFFBBF24), shape: BoxShape.circle)),
                    const SizedBox(width: 8),
                    Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF422006), shape: BoxShape.circle)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Established in BookVista',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.2),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;

    const double spacing = 30;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
