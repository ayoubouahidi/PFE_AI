import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

// Create a provider for AuthService (singleton)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Track the current user
final currentUserProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateStream;
});

// Check if user is authenticated
final isAuthenticatedProvider = StreamProvider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user.when(
    data: (user) => Stream.value(user != null),
    loading: () => Stream.value(false),
    error: (error, stackTrace) => Stream.value(false),
  );
});

// Auth state provider (manages loading, error, and success states)
final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<void>>((ref) {
      final authService = ref.watch(authServiceProvider);
      return AuthStateNotifier(authService);
    });

// Email/Password Sign Up
final emailPasswordSignUpProvider =
    FutureProvider.family<void, (String, String, String)>((ref, params) async {
      final authService = ref.watch(authServiceProvider);
      final (email, password, fullName) = params;
      await authService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );
    });

// Email/Password Sign In
final emailPasswordSignInProvider =
    FutureProvider.family<void, (String, String)>((ref, params) async {
      final authService = ref.watch(authServiceProvider);
      final (email, password) = params;
      await authService.signInWithEmail(email: email, password: password);
    });

// Google Sign In
final googleSignInProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.signInWithGoogle();
});

// Google Sign Up
final googleSignUpProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.signUpWithGoogle();
});

// Password Reset
final passwordResetProvider = FutureProvider.family<void, String>((
  ref,
  email,
) async {
  final authService = ref.watch(authServiceProvider);
  await authService.sendPasswordResetEmail(email);
});

// Update Password
final updatePasswordProvider = FutureProvider.family<void, String>((
  ref,
  newPassword,
) async {
  final authService = ref.watch(authServiceProvider);
  await authService.updatePassword(newPassword);
});

// Send Email Verification
final sendEmailVerificationProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.sendEmailVerification();
});

// Update Display Name
final updateDisplayNameProvider = FutureProvider.family<void, String>((
  ref,
  displayName,
) async {
  final authService = ref.watch(authServiceProvider);
  await authService.updateDisplayName(displayName);
});

// Sign Out
final signOutProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.signOut();
});

// Delete Account
final deleteAccountProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  await authService.deleteAccount();
});

/// StateNotifier for managing auth state with loading and error handling
class AuthStateNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(const AsyncValue.data(null));

  /// Sign in with email and password
  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authService.signInWithEmail(email: email, password: password),
    );
  }

  /// Sign up with email and password
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      ),
    );
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authService.signInWithGoogle());
  }

  /// Sign up with Google
  Future<void> signUpWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authService.signUpWithGoogle());
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _authService.sendPasswordResetEmail(email),
    );
  }

  /// Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _authService.signOut());
  }

  /// Reset error state
  void resetError() {
    state = const AsyncValue.data(null);
  }

  /// Get current error message
  String? getErrorMessage() {
    return state.maybeWhen(
      error: (error, stackTrace) {
        if (error is AuthException) {
          return error.message;
        }
        return error.toString();
      },
      orElse: () => null,
    );
  }

  /// Check if currently loading
  bool isLoading() {
    return state.isLoading;
  }
}
