import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/session_repository.dart';
import '../../data/repositories/timetable_repository.dart';
import '../../data/repositories/subject_repository.dart';
import '../auth/auth_controller.dart';
import 'widgets/weekly_schedule_dialog.dart';

/// Stream for all active sessions for the student's class
final studentActiveSessionsProvider = StreamProvider.autoDispose<List<dynamic>>(
  (ref) {
    final authState = ref.watch(authStateProvider);
    final classId = authState.user?.classId;
    if (classId == null) return Stream.value([]);

    return ref
        .watch(sessionRepositoryProvider)
        .watchActiveSessionsForClass(classId);
  },
);

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final activeSessionsAsync = ref.watch(studentActiveSessionsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF1E3A8A),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signOut(),
                tooltip: 'Logout',
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, ${user?.name.split(' ').first ?? 'Student'}!',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Scan QR to mark attendance',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user?.classId != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today\'s Schedule',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  WeeklyScheduleDialog(classId: user!.classId!),
                            );
                          },
                          child: Text(
                            'Full Week',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF1E3A8A),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _TodaySchedule(classId: user!.classId!),
                    const SizedBox(height: 32),
                  ],

                  Text(
                    'Active Live Sessions',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  activeSessionsAsync.when(
                    data: (sessions) {
                      if (sessions.isEmpty) {
                        return _NoSessionCard();
                      }
                      return Column(
                        children: sessions
                            .map(
                              (session) => _ActiveSessionCard(
                                session: session,
                                onScan: () {
                                  if (kIsWeb) {
                                    // Web: show QR code entry dialog instead of camera
                                    _showWebAttendanceDialog(
                                      context,
                                      ref,
                                      session.id,
                                    );
                                  } else {
                                    context.push('/student/scan/${session.id}');
                                  }
                                },
                              ),
                            )
                            .toList(),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Text('Error: $e'),
                  ),

                  const SizedBox(height: 24),

                  // Web scanner info card
                  if (kIsWeb) _WebScanInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showWebAttendanceDialog(
    BuildContext context,
    WidgetRef ref,
    String sessionId,
  ) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Enter Attendance Code',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'On Web, type the code shown on the QR screen (or use a mobile device to scan directly).',
              style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'QR Token',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              ctx.pop();
              final authState = ref.read(authControllerProvider);
              final error = await ref
                  .read(sessionRepositoryProvider)
                  .markAttendance(
                    collegeId: authState.user?.collegeId ?? '',
                    sessionId: sessionId,
                    studentUid: authState.user?.uid ?? '',
                    scannedToken: controller.text.trim(),
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error ?? '✅ Attendance marked successfully!'),
                    backgroundColor: error == null
                        ? const Color(0xFF10B981)
                        : Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

class _NoSessionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.qr_code_scanner, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No Active Sessions',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your faculty hasn\'t started a session yet. Check back later or wait for your class to begin.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(color: Colors.grey[500], fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _ActiveSessionCard extends StatelessWidget {
  final dynamic session;
  final VoidCallback onScan;

  const _ActiveSessionCard({required this.session, required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.wifi, color: Color(0xFF10B981), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Live Session',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    'Tap Scan to mark your attendance',
                    style: GoogleFonts.inter(
                      color: Colors.grey[500],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: onScan,
              icon: const Icon(Icons.qr_code_scanner, size: 18),
              label: const Text('Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebScanInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A).withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E3A8A).withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF1E3A8A)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'On Web: use the "Scan" button to enter the QR token manually. For camera scanning, use the mobile app.',
              style: GoogleFonts.inter(
                color: const Color(0xFF1E3A8A),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodaySchedule extends ConsumerWidget {
  final String classId;
  const _TodaySchedule({required this.classId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetableAsync = ref.watch(timetableStreamProvider(classId));
    final subjectsAsync = ref.watch(subjectsStreamProvider);

    return timetableAsync.when(
      data: (allSlots) {
        final currentDay = DateFormat('EEEE').format(DateTime.now());
        final todaySlots = allSlots
            .where((slot) => slot.day == currentDay)
            .toList();

        // Sort slots by start time
        todaySlots.sort((a, b) => a.startTime.compareTo(b.startTime));

        if (todaySlots.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.event_available, color: Colors.green[500], size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "No classes scheduled for today.\nEnjoy your day off!",
                    style: GoogleFonts.inter(color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: todaySlots.map((slot) {
            final subjects = subjectsAsync.valueOrNull ?? [];
            final subject = subjects
                .where((s) => s.id == slot.subjectId)
                .firstOrNull;
            final subjectName = subject?.name ?? 'Unknown Subject';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${slot.startTime} - ${slot.endTime}',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1E3A8A),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subjectName,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Faculty: ${slot.facultyId}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Text('Error: $e'),
    );
  }
}
