import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/form_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/social_login_buttons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleEmailChange(String value) {
    ref.read(loginFormProvider.notifier).updateEmail(value);
  }

  void _handlePasswordChange(String value) {
    ref.read(loginFormProvider.notifier).updatePassword(value);
  }

  Future<void> _handleLogin() async {
    final formState = ref.read(loginFormProvider);

    // Validate fields
    if (formState.emailField.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(formState.emailField.errorMessage ?? 'Invalid email'),
          backgroundColor: AppTheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    if (formState.passwordField.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            formState.passwordField.errorMessage ?? 'Invalid password',
          ),
          backgroundColor: AppTheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Perform login using the email/password provider
    try {
      await ref.read(
        emailPasswordSignInProvider.call((
          formState.emailField.value,
          formState.passwordField.value,
        )).future,
      );

      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppTheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _handleGoogleLogin() async {
    try {
      await ref.read(googleSignInProvider.future);
      if (!mounted) return;
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google Sign-In failed: $e'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  void _handleForgotPassword() {
    context.push('/forgot-password');
  }

  void _handleSignUp() {
    context.push('/register');
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(loginFormProvider);

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
                  Icons.lock_outline,
                  size: 40,
                  color: AppTheme.white,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Welcome Text
              Text(
                'Welcome Back',
                style:
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textDark,
                    ) ??
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: AppTheme.spacingSm),

              // Subtitle
              Text(
                'Sign in to your account to continue',
                style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textLight,
                    ) ??
                    const TextStyle(fontSize: 14, color: AppTheme.textLight),
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Email Input
              CustomTextField(
                label: 'Email',
                placeholder: 'Enter your email',
                value: formState.emailField.value,
                onChanged: _handleEmailChange,
                error:
                    formState.emailField.isTouched
                        ? formState.emailField.errorMessage
                        : null,
                prefixIcon: Icons.email_outlined,
                type: TextFieldType.email,
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Password Input
              CustomTextField(
                label: 'Password',
                placeholder: 'Enter your password',
                value: formState.passwordField.value,
                onChanged: _handlePasswordChange,
                error:
                    formState.passwordField.isTouched
                        ? formState.passwordField.errorMessage
                        : null,
                type: TextFieldType.password,
                prefixIcon: Icons.lock_outline,
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Remember Me & Forgot Password Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Remember Me Checkbox
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rememberMe = !_rememberMe;
                      });
                    },
                    child: Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: AppTheme.primary,
                          side: const BorderSide(
                            color: AppTheme.primary,
                            width: 2,
                          ),
                        ),
                        Text(
                          'Remember me',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.textDark,
                              ) ??
                              const TextStyle(
                                fontSize: 14,
                                color: AppTheme.textDark,
                              ),
                        ),
                      ],
                    ),
                  ),

                  // Forgot Password Link
                  GestureDetector(
                    onTap: _handleForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style:
                          Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ) ??
                          const TextStyle(
                            fontSize: 12,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Login Button
              CustomButton(
                text: 'Login',
                onPressed: _handleLogin,
                isLoading: false,
                isEnabled: true,
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Social Login Divider & Buttons
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppTheme.textLight.withValues(alpha: 0.3),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingMd,
                    ),
                    child: Text(
                      'Or continue with',
                      style:
                          Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: AppTheme.textLight,
                          ) ??
                          const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textLight,
                          ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppTheme.textLight.withValues(alpha: 0.3),
                      thickness: 1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Social Login Buttons
              SocialLoginButtons(
                onGooglePressed: _handleGoogleLogin,
                isLoading: false,
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Sign Up Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textLight,
                        ) ??
                        const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textLight,
                        ),
                  ),
                  GestureDetector(
                    onTap: _handleSignUp,
                    child: Text(
                      'Sign Up',
                      style:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                          ) ??
                          const TextStyle(
                            fontSize: 14,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppTheme.spacingXl),
            ],
          ),
        ),
      ),
    );
  }
}
