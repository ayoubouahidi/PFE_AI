import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/form_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/password_strength_indicator.dart';
import '../../widgets/social_login_buttons.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  bool _agreedToTerms = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fullNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  bool _isSigningUp = false;

  void _handleSignUp() async {
    if (_isSigningUp) return;

    // Validate all fields
    final registerFormNotifier = ref.read(registerFormProvider.notifier);

    // Validate full name
    final fullNameError = FormValidator.validateFullName(
      _fullNameController.text,
    );
    registerFormNotifier.updateFullName(_fullNameController.text);

    // Validate email
    final emailError = FormValidator.validateEmail(_emailController.text);
    registerFormNotifier.updateEmail(_emailController.text);

    // Validate password
    final passwordError = FormValidator.validatePassword(
      _passwordController.text,
    );
    registerFormNotifier.updatePassword(_passwordController.text);

    // Validate confirm password
    final confirmPasswordError = FormValidator.validatePasswordConfirmation(
      _passwordController.text,
      _confirmPasswordController.text,
    );
    registerFormNotifier.updateConfirmPassword(_confirmPasswordController.text);

    // Check if form has errors
    if (fullNameError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(fullNameError),
          backgroundColor: AppTheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

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

    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(passwordError),
          backgroundColor: AppTheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    if (confirmPasswordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(confirmPasswordError),
          backgroundColor: AppTheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Check if terms accepted
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please accept the terms and conditions'),
          backgroundColor: AppTheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    // Proceed with sign up
    setState(() {
      _isSigningUp = true;
    });

    try {
      await ref.read(
        emailPasswordSignUpProvider.call((
          _emailController.text.trim(),
          _passwordController.text,
          _fullNameController.text.trim(),
        )).future,
      );

      if (mounted) {
        setState(() {
          _isSigningUp = false;
        });
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSigningUp = false;
        });
        String errorMessage = e.toString();
        if (errorMessage.contains('AuthException:')) {
          errorMessage = errorMessage.replaceAll('AuthException: ', '');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.error,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _handleGoogleSignUp() async {
    try {
      await ref.read(googleSignUpProvider.future);
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _handleAppleSignUp() async {
    try {
      await ref.read(appleSignUpProvider.future);
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppTheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _handleLoginNavigation() {
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final registerForm = ref.watch(registerFormProvider);
    final passwordStrength = FormValidator.calculatePasswordStrength(
      _passwordController.text,
    );

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
                  Icons.person_add_outlined,
                  size: 40,
                  color: AppTheme.white,
                ),
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Welcome Text
              Text(
                'Create Account',
                style:
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppTheme.textDark,
                    ) ??
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: AppTheme.spacingSm),

              // Subtitle
              Text(
                'Sign up to get started',
                style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textLight,
                    ) ??
                    const TextStyle(fontSize: 14, color: AppTheme.textLight),
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Full Name Input
              CustomTextField(
                label: 'Full Name',
                placeholder: 'Enter your full name',
                value: registerForm.fullNameField.value,
                onChanged: (value) {
                  ref.read(registerFormProvider.notifier).updateFullName(value);
                },
                error:
                    registerForm.fullNameField.isTouched
                        ? registerForm.fullNameField.errorMessage
                        : null,
                prefixIcon: Icons.person_outlined,
                type: TextFieldType.text,
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Email Input
              CustomTextField(
                label: 'Email',
                placeholder: 'Enter your email',
                value: registerForm.emailField.value,
                onChanged: (value) {
                  ref.read(registerFormProvider.notifier).updateEmail(value);
                },
                error:
                    registerForm.emailField.isTouched
                        ? registerForm.emailField.errorMessage
                        : null,
                prefixIcon: Icons.email_outlined,
                type: TextFieldType.email,
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Password Input
              CustomTextField(
                label: 'Password',
                placeholder: 'Enter your password',
                value: registerForm.passwordField.value,
                onChanged: (value) {
                  ref.read(registerFormProvider.notifier).updatePassword(value);
                  _passwordController.text = value;
                },
                error:
                    registerForm.passwordField.isTouched
                        ? registerForm.passwordField.errorMessage
                        : null,
                type: TextFieldType.password,
                prefixIcon: Icons.lock_outline,
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Password Strength Indicator
              if (registerForm.passwordField.value.isNotEmpty)
                PasswordStrengthIndicator(
                  password: registerForm.passwordField.value,
                  strengthPercentage:
                      FormValidator.getPasswordStrengthPercentage(
                        passwordStrength,
                      ),
                  label: FormValidator.getPasswordStrengthLabel(
                    passwordStrength,
                  ),
                ),

              const SizedBox(height: AppTheme.spacingMd),

              // Confirm Password Input
              CustomTextField(
                label: 'Confirm Password',
                placeholder: 'Confirm your password',
                value: registerForm.confirmPasswordField.value,
                onChanged: (value) {
                  ref
                      .read(registerFormProvider.notifier)
                      .updateConfirmPassword(value);
                },
                error:
                    registerForm.confirmPasswordField.isTouched
                        ? registerForm.confirmPasswordField.errorMessage
                        : null,
                type: TextFieldType.password,
                prefixIcon: Icons.lock_outline,
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Terms & Conditions Checkbox
              GestureDetector(
                onTap: () {
                  setState(() {
                    _agreedToTerms = !_agreedToTerms;
                  });
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: _agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreedToTerms = value ?? false;
                        });
                      },
                      activeColor: AppTheme.primary,
                      side: const BorderSide(color: AppTheme.primary, width: 2),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style:
                              Theme.of(context).textTheme.bodySmall ??
                              const TextStyle(
                                fontSize: 12,
                                color: AppTheme.textDark,
                              ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Sign Up Button
              CustomButton(
                text: 'Sign Up',
                onPressed: _handleSignUp,
                isLoading: _isSigningUp,
                isEnabled: !_isSigningUp,
              ),

              const SizedBox(height: AppTheme.spacingMd),

              // Social Sign Up Divider & Buttons
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
                      'Or sign up with',
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

              // Social Sign Up Buttons
              SocialLoginButtons(
                onGooglePressed: _handleGoogleSignUp,
                onApplePressed: _handleAppleSignUp,
                isLoading: false,
              ),

              const SizedBox(height: AppTheme.spacingXl),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
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
                    onTap: _handleLoginNavigation,
                    child: Text(
                      'Login',
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
