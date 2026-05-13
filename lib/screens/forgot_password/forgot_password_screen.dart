import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/form_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late TextEditingController _emailController;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    final email = _emailController.text.trim();

    // Validate email
    final emailError = FormValidator.validateEmail(email);
    if (emailError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(emailError),
          backgroundColor: AppTheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      await ref.read(passwordResetProvider.call(email).future);

      setState(() {
        _emailSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password reset email sent. Check your inbox.'),
          backgroundColor: AppTheme.success,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppTheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _handleBackToLogin() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: AppTheme.spacingMd,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Spacing from top
              const SizedBox(height: AppTheme.spacingXl),

              // App Logo/Branding
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                ),
                child: const Icon(
                  Icons.lock_reset_outlined,
                  size: 40,
                  color: AppTheme.white,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Title
              Text(
                'Reset Password',
                style:
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textDark,
                    ) ??
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: AppTheme.spacingSm),

              // Subtitle
              Text(
                'Enter your email to receive a password reset link',
                style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textLight,
                    ) ??
                    const TextStyle(fontSize: 14, color: AppTheme.textLight),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppTheme.spacingXl),

              if (!_emailSent) ...[
                // Email Input
                CustomTextField(
                  label: 'Email',
                  placeholder: 'Enter your email',
                  value: _emailController.text,
                  onChanged: (value) {
                    _emailController.text = value;
                  },
                  prefixIcon: Icons.email_outlined,
                  type: TextFieldType.email,
                ),

                const SizedBox(height: AppTheme.spacingXl),

                // Send Reset Link Button
                CustomButton(
                  text: 'Send Reset Link',
                  onPressed: _handleResetPassword,
                  isLoading: false,
                  isEnabled: true,
                ),
              ] else ...[
                // Success Message
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingMd),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(color: AppTheme.success),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: AppTheme.success,
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                      Text(
                        'Check Your Email',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.success,
                            ) ??
                            const TextStyle(
                              fontSize: 18,
                              color: AppTheme.success,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppTheme.spacingSm),
                      Text(
                        'We\'ve sent a password reset link to ${_emailController.text}',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textMedium,
                            ) ??
                            const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textMedium,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppTheme.spacingXl),

                // Back to Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleBackToLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppTheme.spacingXl),

              // Back to Login Link
              if (!_emailSent)
                GestureDetector(
                  onTap: _handleBackToLogin,
                  child: Text(
                    'Back to Login',
                    style:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ) ??
                        const TextStyle(
                          fontSize: 14,
                          color: AppTheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),

              const SizedBox(height: AppTheme.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}
