import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/college_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../auth/auth_controller.dart';

/// Stream all users in the admin's college
final collegeUsersStreamProvider = StreamProvider.autoDispose<List<UserModel>>((
  ref,
) {
  final authState = ref.watch(authControllerProvider);
  final collegeId = authState.user?.collegeId;

  if (collegeId == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .where('collegeId', isEqualTo: collegeId)
      .snapshots()
      .map(
        (snap) =>
            snap.docs.map((doc) => UserModel.fromJson(doc.data())).toList(),
      );
});

class CollegeSettingsScreen extends ConsumerWidget {
  const CollegeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final collegeId = authState.user?.collegeId;
    final collegeAsync = collegeId != null
        ? ref.watch(_collegeDetailProvider(collegeId))
        : null;
    final usersAsync = ref.watch(collegeUsersStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'College Settings',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage your institution and its members.',
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // ── College Code Card ─────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.vpn_key, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'College Join Code',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                collegeAsync?.when(
                      data: (college) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            college?.name ?? '',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: SelectableText(
                                  collegeId ?? '',
                                  style: GoogleFonts.sourceCodePro(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              IconButton(
                                icon: const Icon(
                                  Icons.copy,
                                  color: Colors.white70,
                                ),
                                tooltip: 'Copy code',
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: collegeId ?? ''),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('College code copied!'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Share this code with faculty and students to let them join your institution.',
                            style: GoogleFonts.inter(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      loading: () =>
                          const CircularProgressIndicator(color: Colors.white),
                      error: (e, _) => Text(
                        'Error: $e',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ) ??
                    const SizedBox(),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // ── Members Header ────────────────────────────────────────
          Row(
            children: [
              Text(
                'Members',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _showAddUserDialog(context, ref),
                icon: const Icon(Icons.person_add, size: 18),
                label: Text(
                  'Add Member',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Members Table ─────────────────────────────────────────
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return Center(
                    child: Text(
                      'No members yet. Share the college code to invite people.',
                      style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                    ),
                  );
                }
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF8FAFC),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text('NAME', style: _headerStyle),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text('EMAIL', style: _headerStyle),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('ROLE', style: _headerStyle),
                              ),
                              SizedBox(
                                width: 60,
                                child: Text('', style: _headerStyle),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.separated(
                            itemCount: users.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 18,
                                            backgroundColor: _roleColor(
                                              user.role,
                                            ).withValues(alpha: 0.1),
                                            child: Text(
                                              user.name.isNotEmpty
                                                  ? user.name[0].toUpperCase()
                                                  : '?',
                                              style: GoogleFonts.inter(
                                                color: _roleColor(user.role),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              user.name,
                                              style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: const Color(0xFF0F172A),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        user.email,
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF64748B),
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _roleColor(
                                            user.role,
                                          ).withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          _roleLabel(user.role),
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: _roleColor(user.role),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(
                                          Icons.more_vert,
                                          size: 18,
                                          color: Color(0xFF64748B),
                                        ),
                                        onSelected: (action) =>
                                            _handleUserAction(
                                              context,
                                              ref,
                                              user,
                                              action,
                                            ),
                                        itemBuilder: (ctx) => [
                                          if (user.role != 'admin')
                                            const PopupMenuItem(
                                              value: 'verify_faculty',
                                              child: Text('Set as Faculty'),
                                            ),
                                          if (user.role != 'admin')
                                            const PopupMenuItem(
                                              value: 'verify_student',
                                              child: Text('Set as Student'),
                                            ),
                                          const PopupMenuItem(
                                            value: 'remove',
                                            child: Text(
                                              'Remove from college',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  static final _headerStyle = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF94A3B8),
    letterSpacing: 1,
  );

  Color _roleColor(String role) {
    switch (role) {
      case 'admin':
        return const Color(0xFFF59E0B);
      case 'faculty':
        return const Color(0xFF3B82F6);
      case 'student':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  String _roleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'faculty':
        return 'Faculty';
      case 'student':
        return 'Student';
      default:
        return 'Unverified';
    }
  }

  void _handleUserAction(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
    String action,
  ) async {
    final userRepo = ref.read(userRepositoryProvider);
    if (action == 'verify_faculty') {
      await userRepo.saveUser(user.copyWith(role: 'faculty'));
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${user.name} set as Faculty')));
      }
    } else if (action == 'verify_student') {
      await userRepo.saveUser(user.copyWith(role: 'student'));
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${user.name} set as Student')));
      }
    } else if (action == 'remove') {
      _confirmRemoveUser(context, ref, user);
    }
  }

  void _confirmRemoveUser(BuildContext context, WidgetRef ref, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove ${user.name}?',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This will unlink this user from your college. They can rejoin with the college code.',
          style: GoogleFonts.inter(color: const Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: const Color(0xFF64748B)),
            ),
          ),
          FilledButton(
            onPressed: () async {
              // Remove college link from user
              await ref
                  .read(userRepositoryProvider)
                  .saveUser(user.copyWith(collegeId: null, role: ''));
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: Text(
              'Remove',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    String selectedRole = 'student';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Add Member',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F9FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          size: 16,
                          color: Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'The user must have already signed in to the app at least once.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF3B82F6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'User Email',
                      hintText: 'e.g. user@example.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'student',
                        child: Text('Student'),
                      ),
                      DropdownMenuItem(
                        value: 'faculty',
                        child: Text('Faculty'),
                      ),
                    ],
                    onChanged: (val) =>
                        setState(() => selectedRole = val ?? 'student'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(color: const Color(0xFF64748B)),
                ),
              ),
              FilledButton(
                onPressed: () async {
                  final email = emailController.text.trim();
                  final collegeId = ref
                      .read(authControllerProvider)
                      .user
                      ?.collegeId;
                  if (email.isEmpty || collegeId == null) return;

                  // Find user by email
                  final snap = await FirebaseFirestore.instance
                      .collection('users')
                      .where('email', isEqualTo: email)
                      .limit(1)
                      .get();

                  if (snap.docs.isEmpty) {
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'User not found. They must sign in first.',
                          ),
                        ),
                      );
                    }
                    return;
                  }

                  final existingUser = UserModel.fromJson(
                    snap.docs.first.data(),
                  );
                  final updated = existingUser.copyWith(
                    collegeId: collegeId,
                    role: selectedRole,
                  );
                  await ref.read(userRepositoryProvider).saveUser(updated);

                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${existingUser.name} added as $selectedRole',
                        ),
                      ),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Add Member',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Fetch college document by ID
final _collegeDetailProvider = FutureProvider.autoDispose.family((
  ref,
  String collegeId,
) {
  return ref.read(collegeRepositoryProvider).getCollege(collegeId);
});
