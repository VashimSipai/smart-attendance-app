import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/role_selection_screen.dart';
import '../../presentation/auth/college_code_screen.dart';
import '../../presentation/auth/create_college_screen.dart';
import '../../presentation/auth/profile_setup_screen.dart';
import '../../presentation/auth/auth_controller.dart';
import '../../presentation/dashboards/student_dashboard.dart';
import '../../presentation/dashboards/faculty_dashboard.dart';
import '../../presentation/dashboards/admin_dashboard.dart';
import '../../presentation/faculty/session_screens.dart';
import '../../presentation/student/qr_scanner_screen.dart';
import '../../data/models/faculty_assignment_model.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authStatus = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggingIn = state.uri.path == '/login';
      final isSelectingRole = state.uri.path == '/role-selection';
      final isEnteringCode = state.uri.path == '/college-code';
      final isCreatingCollege = state.uri.path == '/create-college';
      final isProfileSetup = state.uri.path == '/profile-setup';

      final isAuthFlow =
          isLoggingIn ||
          isSelectingRole ||
          isEnteringCode ||
          isCreatingCollege ||
          isProfileSetup;

      if (authStatus.status == AuthStatus.initial) {
        return '/login';
      }

      if (authStatus.status == AuthStatus.unauthenticated) {
        return isAuthFlow ? null : '/login';
      }

      if (authStatus.status == AuthStatus.collegeLinkingRequired) {
        if (isSelectingRole || isEnteringCode || isCreatingCollege) return null;
        return '/role-selection';
      }

      if (authStatus.status == AuthStatus.profileSetupRequired) {
        if (isProfileSetup) return null;
        return '/profile-setup';
      }

      if (authStatus.status == AuthStatus.authenticated) {
        if (isAuthFlow) {
          final role = authStatus.user?.role;
          if (role == 'admin') return '/admin-dashboard';
          if (role == 'faculty') return '/faculty-dashboard';
          return '/student-dashboard';
        }
      }

      return null;
    },
    routes: [
      // ── Auth ────────────────────────────────────────────────────────
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/college-code',
        builder: (context, state) {
          final role = state.extra as String? ?? 'student';
          return CollegeCodeScreen(role: role);
        },
      ),
      GoRoute(
        path: '/create-college',
        builder: (context, state) => const CreateCollegeScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),

      // ── Student ─────────────────────────────────────────────────────
      GoRoute(
        path: '/student-dashboard',
        builder: (context, state) => const StudentDashboard(),
      ),
      GoRoute(
        path: '/student/scan/:sessionId',
        builder: (context, state) => StudentQrScannerScreen(
          sessionId: state.pathParameters['sessionId']!,
        ),
      ),

      // ── Faculty ─────────────────────────────────────────────────────
      GoRoute(
        path: '/faculty-dashboard',
        builder: (context, state) => const FacultyDashboard(),
      ),
      GoRoute(
        path: '/faculty/start-session',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return StartSessionScreen(
            assignment: extra['assignment'] as FacultyAssignmentModel,
            subjectName: extra['subjectName'] as String,
          );
        },
      ),
      GoRoute(
        path: '/faculty/active-session/:sessionId',
        builder: (context, state) =>
            ActiveSessionScreen(sessionId: state.pathParameters['sessionId']!),
      ),

      // ── Admin (single-page shell with sidebar navigation) ──────────
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const AdminDashboard(),
      ),
    ],
  );
});
