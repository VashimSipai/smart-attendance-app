import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../data/repositories/user_repository.dart';
import '../../data/repositories/college_repository.dart';
import '../../data/models/user_model.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  collegeLinkingRequired,
  profileSetupRequired,
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;

  const AuthState({required this.status, this.user});

  AuthState copyWith({AuthStatus? status, UserModel? user}) {
    return AuthState(status: status ?? this.status, user: user ?? this.user);
  }
}

/// Derived provider that gives access to the current AuthState.
/// All stream providers (programs, classes, subjects, etc.) use this
/// to retrieve the user's collegeId.
final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authControllerProvider);
});

class AuthController extends StateNotifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserRepository _userRepository;
  final CollegeRepository _collegeRepository;

  late final GoogleSignIn _googleSignIn;

  AuthController(this._userRepository, this._collegeRepository)
    : super(const AuthState(status: AuthStatus.initial)) {
    _googleSignIn = GoogleSignIn(
      clientId: kIsWeb ? dotenv.env['WEB_CLIENT_ID'] : null,
    );
    _checkAuthState();
  }

  void _checkAuthState() {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        state = const AuthState(status: AuthStatus.unauthenticated);
      } else {
        final userModel = await _userRepository.getUser(firebaseUser.uid);
        if (userModel == null ||
            userModel.collegeId == null ||
            userModel.role.isEmpty) {
          state = AuthState(
            status: AuthStatus.collegeLinkingRequired,
            user: userModel,
          );
        } else if (!userModel.profileCompleted) {
          state = AuthState(
            status: AuthStatus.profileSetupRequired,
            user: userModel,
          );
        } else {
          state = AuthState(status: AuthStatus.authenticated, user: userModel);
        }
      }
    });
  }

  Future<void> signInWithGoogle() async {
    try {
      UserCredential? credentialResult;

      if (kIsWeb) {
        GoogleAuthProvider authProvider = GoogleAuthProvider();
        authProvider.addScope('email');
        credentialResult = await _auth.signInWithPopup(authProvider);
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          // User canceled the sign-in
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        credentialResult = await _auth.signInWithCredential(credential);
      }

      // Create initial empty document if first time login (now runs for Web & Mobile)
      if (credentialResult.user != null) {
        final userProfile = await _userRepository.getUser(
          credentialResult.user!.uid,
        );
        if (userProfile == null) {
          final newUser = UserModel(
            uid: credentialResult.user!.uid,
            name: credentialResult.user!.displayName ?? '',
            email: credentialResult.user!.email ?? '',
            role: '', // Needs to be selected
            createdAt: DateTime.now(),
          );
          await _userRepository.saveUser(newUser);
        }
      }
    } catch (e) {
      debugPrint('Error during Google Sign In: $e');
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> linkCollegeAndRole(String collegeId, String role) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final collegeExists = await _collegeRepository.getCollege(collegeId);
      if (collegeExists == null) {
        throw Exception("Invalid College Code");
      }

      var existingUser = await _userRepository.getUser(user.uid);

      // Fallback: If user doc was never created, create it now
      if (existingUser == null) {
        final newUser = UserModel(
          uid: user.uid,
          name: user.displayName ?? 'Unknown User',
          email: user.email ?? 'No Email',
          role: role,
          collegeId: collegeId,
          createdAt: DateTime.now(),
        );
        await _userRepository.saveUser(newUser);
        state = AuthState(
          status: AuthStatus.profileSetupRequired,
          user: newUser,
        );
      } else {
        final updatedUser = existingUser.copyWith(
          collegeId: collegeId,
          role: role,
        );
        await _userRepository.saveUser(updatedUser);
        state = AuthState(
          status: updatedUser.profileCompleted
              ? AuthStatus.authenticated
              : AuthStatus.profileSetupRequired,
          user: updatedUser,
        );
      }
    } catch (e) {
      debugPrint("Error linking college: $e");
      rethrow;
    }
  }

  Future<void> completeProfile(UserModel updatedUser) async {
    try {
      await _userRepository.saveUser(updatedUser);
      state = AuthState(status: AuthStatus.authenticated, user: updatedUser);
    } catch (e) {
      debugPrint("Error completing profile: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final userRepository = ref.watch(userRepositoryProvider);
    final collegeRepository = ref.watch(collegeRepositoryProvider);
    return AuthController(userRepository, collegeRepository);
  },
);
