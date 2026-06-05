import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase for AuthException
import '../../../core/providers/service_providers.dart';
import '../../../core/theme/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(authServiceProvider).signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) context.go('/home');
    } catch (e) {
      if (mounted) {
        String errorMessage = 'An unexpected error occurred. Please try again.';
        
        if (e is AuthException) {
          final message = e.message.toLowerCase();
          if (message.contains('invalid login credentials') || e.statusCode == '400') {
            errorMessage = 'Invalid email or password. Please verify your credentials.';
          } else if (message.contains('email not confirmed')) {
            errorMessage = 'Your email address is not verified. Please check your inbox or turn off email confirmation.';
          } else if (message.contains('rate limit')) {
            errorMessage = 'Too many login attempts. Please wait a moment and try again.';
          } else {
            errorMessage = e.message;
          }
        } else {
          errorMessage = e.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    errorMessage,
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                // Logo Icon
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF020617),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.1),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.menu_book, color: Color(0xFFFFD700), size: 32),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'BookVista',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.satisfy(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Settle in with a good story',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 32),
                
                // Email Field
                _buildTextField('Email Address', _emailController, false),
                const SizedBox(height: 24),
                
                // Password Field
                _buildTextField('Password', _passwordController, true),
                const SizedBox(height: 24),
                
                // Remember Me
                GestureDetector(
                  onTap: () => setState(() => _rememberMe = !_rememberMe),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white24),
                        ),
                        child: _rememberMe 
                          ? const Center(child: Icon(Icons.circle, color: Color(0xFFFFD700), size: 6))
                          : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Remember Me',
                        style: GoogleFonts.inter(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                
                // Sign In Button
                GestureDetector(
                  onTap: _isLoading ? null : _login,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFB300), Color(0xFFFFD700)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SIGN IN TO LIBRARY',
                                style: GoogleFonts.inter(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(Icons.arrow_forward_rounded, color: Colors.black87, size: 18),
                            ],
                          ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Or continue with
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.white10)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR CONTINUE WITH',
                        style: GoogleFonts.inter(
                          color: Colors.white24,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.white10)),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Social Buttons
                Row(
                  children: [
                    Expanded(child: _buildSocialButton('google')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildSocialButton('ios')),
                  ],
                ),
                const SizedBox(height: 32),
                
                // Join the club
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'New reader? ',
                      style: GoogleFonts.inter(color: Colors.white38, fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/signup'),
                      child: Text(
                        'Join the club',
                        style: GoogleFonts.inter(
                          color: const Color(0xFFFFD700),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white24,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          obscureText: isPassword ? _obscurePassword : false,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Colors.white24,
                    size: 18,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                )
              : null,
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFD700))),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(String type) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Center(
        child: type == 'google'
          ? const Icon(Icons.g_mobiledata, color: Colors.white38, size: 28)
          : const Text('iOS', style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }
}
