import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Password strength enum
enum PasswordStrength {
  weak,
  fair,
  good,
  strong,
}

/// Form field state model
class FormFieldState {
  final String value;
  final String? errorMessage;
  final bool isTouched;

  const FormFieldState({
    this.value = '',
    this.errorMessage,
    this.isTouched = false,
  });

  bool get isValid => errorMessage == null;
  bool get hasError => errorMessage != null && isTouched;

  FormFieldState copyWith({
    String? value,
    String? errorMessage,
    bool? isTouched,
  }) {
    return FormFieldState(
      value: value ?? this.value,
      errorMessage: errorMessage,
      isTouched: isTouched ?? this.isTouched,
    );
  }
}

/// Login form state
class LoginFormState {
  final FormFieldState emailField;
  final FormFieldState passwordField;
  final bool rememberMe;

  const LoginFormState({
    this.emailField = const FormFieldState(),
    this.passwordField = const FormFieldState(),
    this.rememberMe = false,
  });

  bool get isFormValid => emailField.isValid && passwordField.isValid;
  bool get hasErrors => emailField.hasError || passwordField.hasError;

  LoginFormState copyWith({
    FormFieldState? emailField,
    FormFieldState? passwordField,
    bool? rememberMe,
  }) {
    return LoginFormState(
      emailField: emailField ?? this.emailField,
      passwordField: passwordField ?? this.passwordField,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

/// Register form state
class RegisterFormState {
  final FormFieldState fullNameField;
  final FormFieldState emailField;
  final FormFieldState passwordField;
  final FormFieldState confirmPasswordField;
  final bool agreedToTerms;

  const RegisterFormState({
    this.fullNameField = const FormFieldState(),
    this.emailField = const FormFieldState(),
    this.passwordField = const FormFieldState(),
    this.confirmPasswordField = const FormFieldState(),
    this.agreedToTerms = false,
  });

  bool get isFormValid =>
      fullNameField.isValid &&
      emailField.isValid &&
      passwordField.isValid &&
      confirmPasswordField.isValid &&
      agreedToTerms;

  bool get hasErrors =>
      fullNameField.hasError ||
      emailField.hasError ||
      passwordField.hasError ||
      confirmPasswordField.hasError;

  RegisterFormState copyWith({
    FormFieldState? fullNameField,
    FormFieldState? emailField,
    FormFieldState? passwordField,
    FormFieldState? confirmPasswordField,
    bool? agreedToTerms,
  }) {
    return RegisterFormState(
      fullNameField: fullNameField ?? this.fullNameField,
      emailField: emailField ?? this.emailField,
      passwordField: passwordField ?? this.passwordField,
      confirmPasswordField: confirmPasswordField ?? this.confirmPasswordField,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
    );
  }
}

/// Form validation service
class FormValidator {
  /// Validate email format
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    // Regular expression for email validation
    const emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);

    if (!regex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate password strength and requirements
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validate full name
  static String? validateFullName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Full name is required';
    }

    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (name.length > 50) {
      return 'Name must not exceed 50 characters';
    }

    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  /// Validate password confirmation
  static String? validatePasswordConfirmation(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Calculate password strength
  static PasswordStrength calculatePasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.length >= 16) score++;

    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.fair;
    if (score <= 6) return PasswordStrength.good;
    return PasswordStrength.strong;
  }

  /// Get password strength color based on strength level
  static String getPasswordStrengthLabel(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.fair:
        return 'Fair';
      case PasswordStrength.good:
        return 'Good';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }

  /// Get password strength percentage (0-1)
  static double getPasswordStrengthPercentage(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 0.25;
      case PasswordStrength.fair:
        return 0.5;
      case PasswordStrength.good:
        return 0.75;
      case PasswordStrength.strong:
        return 1.0;
    }
  }
}

/// Login form notifier
class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(const LoginFormState());

  void updateEmail(String value) {
    final error = FormValidator.validateEmail(value);
    state = state.copyWith(
      emailField: state.emailField.copyWith(
        value: value,
        errorMessage: error,
        isTouched: true,
      ),
    );
  }

  void updatePassword(String value) {
    final error = FormValidator.validatePassword(value);
    state = state.copyWith(
      passwordField: state.passwordField.copyWith(
        value: value,
        errorMessage: error,
        isTouched: true,
      ),
    );
  }

  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  void setEmailTouched(bool touched) {
    state = state.copyWith(
      emailField: state.emailField.copyWith(isTouched: touched),
    );
  }

  void setPasswordTouched(bool touched) {
    state = state.copyWith(
      passwordField: state.passwordField.copyWith(isTouched: touched),
    );
  }

  void reset() {
    state = const LoginFormState();
  }
}

/// Register form notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super(const RegisterFormState());

  void updateFullName(String value) {
    final error = FormValidator.validateFullName(value);
    state = state.copyWith(
      fullNameField: state.fullNameField.copyWith(
        value: value,
        errorMessage: error,
        isTouched: true,
      ),
    );
  }

  void updateEmail(String value) {
    final error = FormValidator.validateEmail(value);
    state = state.copyWith(
      emailField: state.emailField.copyWith(
        value: value,
        errorMessage: error,
        isTouched: true,
      ),
    );
  }

  void updatePassword(String value) {
    final error = FormValidator.validatePassword(value);
    state = state.copyWith(
      passwordField: state.passwordField.copyWith(
        value: value,
        errorMessage: error,
        isTouched: true,
      ),
    );
  }

  void updateConfirmPassword(String value) {
    final error = FormValidator.validatePasswordConfirmation(
      state.passwordField.value,
      value,
    );
    state = state.copyWith(
      confirmPasswordField: state.confirmPasswordField.copyWith(
        value: value,
        errorMessage: error,
        isTouched: true,
      ),
    );
  }

  void toggleAgreedToTerms() {
    state = state.copyWith(agreedToTerms: !state.agreedToTerms);
  }

  void setFullNameTouched(bool touched) {
    state = state.copyWith(
      fullNameField: state.fullNameField.copyWith(isTouched: touched),
    );
  }

  void setEmailTouched(bool touched) {
    state = state.copyWith(
      emailField: state.emailField.copyWith(isTouched: touched),
    );
  }

  void setPasswordTouched(bool touched) {
    state = state.copyWith(
      passwordField: state.passwordField.copyWith(isTouched: touched),
    );
  }

  void setConfirmPasswordTouched(bool touched) {
    state = state.copyWith(
      confirmPasswordField: state.confirmPasswordField.copyWith(isTouched: touched),
    );
  }

  void reset() {
    state = const RegisterFormState();
  }
}

/// Password strength notifier
class PasswordStrengthNotifier extends StateNotifier<PasswordStrength> {
  PasswordStrengthNotifier() : super(PasswordStrength.weak);

  void updatePasswordStrength(String password) {
    state = FormValidator.calculatePasswordStrength(password);
  }

  void reset() {
    state = PasswordStrength.weak;
  }
}

// ============== PROVIDERS ==============

/// Login form provider
final loginFormProvider =
    StateNotifierProvider<LoginFormNotifier, LoginFormState>(
  (ref) => LoginFormNotifier(),
);

/// Register form provider
final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, RegisterFormState>(
  (ref) => RegisterFormNotifier(),
);

/// Password strength provider
final passwordStrengthProvider =
    StateNotifierProvider<PasswordStrengthNotifier, PasswordStrength>(
  (ref) => PasswordStrengthNotifier(),
);

/// Validate all login form fields
final validateLoginFormProvider = Provider<bool>((ref) {
  final form = ref.watch(loginFormProvider);
  return form.isFormValid;
});

/// Validate all register form fields
final validateRegisterFormProvider = Provider<bool>((ref) {
  final form = ref.watch(registerFormProvider);
  return form.isFormValid;
});

/// Get login form error state
final loginFormHasErrorsProvider = Provider<bool>((ref) {
  final form = ref.watch(loginFormProvider);
  return form.hasErrors;
});

/// Get register form error state
final registerFormHasErrorsProvider = Provider<bool>((ref) {
  final form = ref.watch(registerFormProvider);
  return form.hasErrors;
});

/// Get password strength label
final passwordStrengthLabelProvider = Provider<String>((ref) {
  final strength = ref.watch(passwordStrengthProvider);
  return FormValidator.getPasswordStrengthLabel(strength);
});

/// Get password strength percentage (0-1)
final passwordStrengthPercentageProvider = Provider<double>((ref) {
  final strength = ref.watch(passwordStrengthProvider);
  return FormValidator.getPasswordStrengthPercentage(strength);
});
