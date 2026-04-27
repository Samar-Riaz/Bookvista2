import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.network(
            'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?auto=format&fit=crop&q=80&w=1000',
            fit: BoxFit.cover,
          ),
          // Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF020617).withOpacity(0.8),
                  const Color(0xFF020617).withOpacity(0.95),
                ],
              ),
            ),
          ),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  // Logo
                  const Icon(Icons.menu_book, color: Color(0xFFFFD700), size: 32),
                  const SizedBox(height: 12),
                  Text(
                    'BookVista',
                    style: GoogleFonts.satisfy(
                      color: const Color(0xFFFFD700),
                      fontSize: 36,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Reset Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reset Password',
                          style: GoogleFonts.notoSerif(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Enter your email address and we\'ll send you a link to get back into your account.',
                          style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        
                        Text(
                          'EMAIL ADDRESS',
                          style: GoogleFonts.inter(
                            color: const Color(0xFFFFD700),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
                          decoration: InputDecoration(
                            hintText: 'your@email.com',
                            hintStyle: GoogleFonts.inter(color: Colors.white10, fontSize: 15),
                            prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFFFD700), size: 20),
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
                          ),
                        ),
                        const SizedBox(height: 48),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () => context.push('/otp'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4A373),
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SEND LINK',
                                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        Center(
                          child: TextButton.icon(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.chevron_left_rounded, color: Colors.white24, size: 20),
                            label: Text(
                              'BACK TO LOGIN',
                              style: GoogleFonts.inter(color: Colors.white24, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1),

                  const SizedBox(height: 60),
                  
                  // Decorative Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 60, height: 1, color: Colors.white.withOpacity(0.05)),
                      const SizedBox(width: 16),
                      const Icon(Icons.eco_outlined, color: Colors.white10, size: 16),
                      const SizedBox(width: 16),
                      Container(width: 60, height: 1, color: Colors.white.withOpacity(0.05)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
