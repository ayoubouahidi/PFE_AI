import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/foundation.dart';

/// Custom Exception Classes
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AuthException: $message';
}

/// Authentication Service
/// Handles all Firebase authentication operations including:
/// - Email/Password sign up and login
/// - Google Sign-In
/// - Apple Sign-In
/// - Password reset
/// - Logout
/// - User session management
class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Private variables
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get currentUserEmail => _currentUser?.email;
  String? get currentUserDisplayName => _currentUser?.displayName;
  String? get currentUserPhotoUrl => _currentUser?.photoURL;
  bool get isEmailVerified => _currentUser?.emailVerified ?? false;

  // Constructor
  AuthService() {
    _initializeAuthStateListener();
  }

  /// Initialize authentication state listener
  void _initializeAuthStateListener() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  /// Set loading state and notify listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Set error message
  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void _clearError() {
    _errorMessage = null;
  }

  /// Handle Firebase Auth exceptions and return user-friendly messages
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'operation-not-allowed':
        return 'Operation not allowed. Please contact support.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method.';
      case 'invalid-credential':
        return 'The credential provided is invalid.';
      case 'user-mismatch':
        return 'The user credentials do not match.';
      case 'requires-recent-login':
        return 'Please log in again to perform this operation.';
      default:
        return 'An authentication error occurred: ${e.message}';
    }
  }

  // ==================== EMAIL/PASSWORD AUTHENTICATION ====================

  /// Sign up with email and password
  /// 
  /// Parameters:
  /// - [email]: User's email address
  /// - [password]: User's password (min 8 characters recommended)
  /// - [fullName]: User's full name (optional)
  /// 
  /// Returns: User object if successful, throws AuthException on failure
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        throw AuthException(message: 'Email and password are required.');
      }

      if (password.length < 8) {
        throw AuthException(message: 'Password must be at least 8 characters long.');
      }

      // Create user with email and password
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        // Update user profile with display name if provided
        if (fullName != null && fullName.isNotEmpty) {
          await user.updateDisplayName(fullName.trim());
        }

        // Send email verification
        await user.sendEmailVerification();

        _currentUser = user;
        _setLoading(false);
        return user;
      }

      throw AuthException(message: 'Failed to create user account.');
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  /// Sign in with email and password
  /// 
  /// Parameters:
  /// - [email]: User's email address
  /// - [password]: User's password
  /// 
  /// Returns: User object if successful, throws AuthException on failure
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        throw AuthException(message: 'Email and password are required.');
      }

      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        _currentUser = user;
        _setLoading(false);
        return user;
      }

      throw AuthException(message: 'Failed to sign in user.');
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  // ==================== GOOGLE SIGN-IN ====================

  /// Sign in with Google
  /// 
  /// Returns: User object if successful, throws AuthException on failure
  Future<User?> signInWithGoogle() async {
    try {
      _setLoading(true);
      _clearError();

      // Trigger the Google sign-in process
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        _setLoading(false);
        throw AuthException(message: 'Google sign in cancelled by user.');
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      // Create credentials
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        _currentUser = user;
        _setLoading(false);
        return user;
      }

      throw AuthException(message: 'Failed to sign in with Google.');
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  /// Sign up with Google
  /// 
  /// Returns: User object if successful, throws AuthException on failure
  Future<User?> signUpWithGoogle() async {
    // Google sign-up is handled the same as sign-in
    // Firebase creates a new user if the email doesn't exist
    return signInWithGoogle();
  }

  // ==================== APPLE SIGN-IN ====================

  /// Sign in with Apple (iOS only)
  /// 
  /// Returns: User object if successful, throws AuthException on failure
  Future<User?> signInWithApple() async {
    try {
      _setLoading(true);
      _clearError();

      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // Create OAuthCredential with Apple sign-in
      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
      final AuthCredential credential = oAuthProvider.credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase with Apple credentials
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        // Update display name if available
        if ((appleCredential.givenName ?? '').isNotEmpty ||
            (appleCredential.familyName ?? '').isNotEmpty) {
          final displayName =
              '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
                  .trim();
          if (displayName.isNotEmpty) {
            await user.updateDisplayName(displayName);
          }
        }

        _currentUser = user;
        _setLoading(false);
        return user;
      }

      throw AuthException(message: 'Failed to sign in with Apple.');
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        _setError('Apple sign in cancelled by user.');
      } else {
        _setError('Apple sign in failed: ${e.message}');
      }
      _setLoading(false);
      throw AuthException(message: _errorMessage ?? 'Apple sign in failed.');
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  /// Sign up with Apple (iOS only)
  /// 
  /// Returns: User object if successful, throws AuthException on failure
  Future<User?> signUpWithApple() async {
    // Apple sign-up is handled the same as sign-in
    // Firebase creates a new user if the email doesn't exist
    return signInWithApple();
  }

  // ==================== PASSWORD MANAGEMENT ====================

  /// Send password reset email
  /// 
  /// Parameters:
  /// - [email]: User's email address
  /// 
  /// Throws AuthException on failure
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _clearError();

      if (email.isEmpty) {
        throw AuthException(message: 'Email is required.');
      }

      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());

      _setLoading(false);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  /// Update password for current user
  /// 
  /// Parameters:
  /// - [newPassword]: New password for the user
  /// 
  /// Note: User must have recently logged in
  /// Throws AuthException on failure
  Future<void> updatePassword(String newPassword) async {
    try {
      _setLoading(true);
      _clearError();

      if (newPassword.isEmpty) {
        throw AuthException(message: 'Password is required.');
      }

      if (newPassword.length < 8) {
        throw AuthException(
            message: 'Password must be at least 8 characters long.');
      }

      if (_currentUser == null) {
        throw AuthException(message: 'No user is currently logged in.');
      }

      await _currentUser!.updatePassword(newPassword);

      _setLoading(false);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  /// Update email for current user
  /// 
  /// Parameters:
  /// - [newEmail]: New email address for the user
  /// 
  /// Note: User must have recently logged in
  /// Throws AuthException on failure
  Future<void> updateEmail(String newEmail) async {
    try {
      _setLoading(true);
      _clearError();

      if (newEmail.isEmpty) {
        throw AuthException(message: 'Email is required.');
      }

      if (_currentUser == null) {
        throw AuthException(message: 'No user is currently logged in.');
      }

      await _currentUser!.updateEmail(newEmail.trim());

      _setLoading(false);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  // ==================== EMAIL VERIFICATION ====================

  /// Send email verification
  /// 
  /// Throws AuthException on failure
  Future<void> sendEmailVerification() async {
    try {
      _setLoading(true);
      _clearError();

      if (_currentUser == null) {
        throw AuthException(message: 'No user is currently logged in.');
      }

      await _currentUser!.sendEmailVerification();

      _setLoading(false);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  /// Check if email is verified
  /// 
  /// Returns: true if email is verified, false otherwise
  Future<bool> checkEmailVerified() async {
    try {
      await _currentUser?.reload();
      _currentUser = _firebaseAuth.currentUser;
      return _currentUser?.emailVerified ?? false;
    } catch (e) {
      return false;
    }
  }

  // ==================== USER PROFILE MANAGEMENT ====================

  /// Update user display name
  /// 
  /// Parameters:
  /// - [displayName]: New display name for the user
  /// 
  /// Throws AuthException on failure
  Future<void> updateDisplayName(String displayName) async {
    try {
      _setLoading(true);
      _clearError();

      if (displayName.isEmpty) {
        throw AuthException(message: 'Display name is required.');
      }

      if (_currentUser == null) {
        throw AuthException(message: 'No user is currently logged in.');
      }

      await _currentUser!.updateDisplayName(displayName.trim());
      await _currentUser?.reload();
      _currentUser = _firebaseAuth.currentUser;

      _setLoading(false);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  /// Update user profile photo
  /// 
  /// Parameters:
  /// - [photoUrl]: URL of the new profile photo
  /// 
  /// Throws AuthException on failure
  Future<void> updatePhotoUrl(String photoUrl) async {
    try {
      _setLoading(true);
      _clearError();

      if (photoUrl.isEmpty) {
        throw AuthException(message: 'Photo URL is required.');
      }

      if (_currentUser == null) {
        throw AuthException(message: 'No user is currently logged in.');
      }

      await _currentUser!.updatePhotoURL(photoUrl.trim());
      await _currentUser?.reload();
      _currentUser = _firebaseAuth.currentUser;

      _setLoading(false);
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  /// Reload user data from Firebase
  /// 
  /// Throws AuthException on failure
  Future<void> reloadUser() async {
    try {
      if (_currentUser == null) {
        throw AuthException(message: 'No user is currently logged in.');
      }

      await _currentUser!.reload();
      _currentUser = _firebaseAuth.currentUser;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      throw AuthException(message: errorMessage);
    }
  }

  // ==================== SESSION MANAGEMENT ====================

  /// Sign out current user
  /// 
  /// Also signs out from Google and clears all session data
  /// Throws AuthException on failure
  Future<void> signOut() async {
    try {
      _setLoading(true);
      _clearError();

      // Sign out from Google if user was signed in with Google
      await _googleSignIn.signOut();

      // Sign out from Firebase
      await _firebaseAuth.signOut();

      _currentUser = null;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      final errorMessage = 'Failed to sign out: ${e.toString()}';
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  /// Delete current user account
  /// 
  /// Note: User must have recently logged in
  /// Throws AuthException on failure
  Future<void> deleteAccount() async {
    try {
      _setLoading(true);
      _clearError();

      if (_currentUser == null) {
        throw AuthException(message: 'No user is currently logged in.');
      }

      // Delete user from Firebase Authentication
      await _currentUser!.delete();

      _currentUser = null;
      _setLoading(false);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      final errorMessage = _handleAuthException(e);
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage, code: e.code);
    } catch (e) {
      final errorMessage = e.toString();
      _setError(errorMessage);
      _setLoading(false);
      throw AuthException(message: errorMessage);
    }
  }

  /// Check if user session is still active
  /// 
  /// Returns: true if user is authenticated, false otherwise
  bool isSessionActive() {
    return _firebaseAuth.currentUser != null;
  }

  /// Get current user authentication state stream
  /// 
  /// Returns: Stream of User? that emits when auth state changes
  Stream<User?> get authStateStream => _firebaseAuth.authStateChanges();

  /// Get current user ID token stream
  /// 
  /// Returns: Stream of ID tokens
  Stream<String?> get idTokenStream =>
      _firebaseAuth.idTokenChanges().asyncMap((user) async {
        if (user == null) return null;
        return await user.getIdToken();
      });

  @override
  void dispose() {
    super.dispose();
  }
}
