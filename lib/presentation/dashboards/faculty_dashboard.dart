import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../data/repositories/timetable_repository.dart';
import '../../data/repositories/subject_repository.dart';
import '../../data/repositories/class_repository.dart';
import '../../data/repositories/session_repository.dart';
import '../../data/models/faculty_assignment_model.dart';
import '../auth/auth_controller.dart';
import 'widgets/weekly_schedule_dialog.dart';

class FacultyDashboard extends ConsumerWidget {
  const FacultyDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final activeSessionAsync = ref.watch(facultyActiveSessionProvider);

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
                    'Hello, ${user?.name.split(' ').first ?? 'Professor'}!',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Manage your sessions',
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

          // Active session banner
          activeSessionAsync.when(
            data: (activeSession) {
              if (activeSession == null)
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: _ActiveSessionBanner(
                    session: activeSession,
                    onTap: () => context.push(
                      '/faculty/active-session/${activeSession.id}',
                    ),
                  ),
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (e, s) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          // Section header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
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
                            WeeklyScheduleDialog(facultyId: user!.uid),
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
            ),
          ),

          // Today's schedule list
          _TodaySchedule(facultyId: user?.uid ?? ''),
        ],
      ),
    );
  }
}

class _ActiveSessionBanner extends StatelessWidget {
  final dynamic session;
  final VoidCallback onTap;

  const _ActiveSessionBanner({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF10B981).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.qr_code, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔴 LIVE SESSION ACTIVE',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Tap to view QR & attendance',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

class _TodaySchedule extends ConsumerWidget {
  final String facultyId;
  const _TodaySchedule({required this.facultyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timetableAsync = ref.watch(facultyTimetableStreamProvider(facultyId));
    final subjectsAsync = ref.watch(subjectsStreamProvider);
    final classesAsync = ref.watch(classesStreamProvider);

    return timetableAsync.when(
      data: (allSlots) {
        final currentDay = DateFormat('EEEE').format(DateTime.now());
        final todaySlots = allSlots
            .where((slot) => slot.day == currentDay)
            .toList();

        // Sort dynamically based on start time string HH:MM
        todaySlots.sort((a, b) => a.startTime.compareTo(b.startTime));

        if (todaySlots.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_available,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No classes scheduled today',
                    style: GoogleFonts.inter(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Enjoy your free time.',
                    style: GoogleFonts.inter(
                      color: Colors.grey[400],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final slot = todaySlots[index];
              final subjects = subjectsAsync.valueOrNull ?? [];
              final classes = classesAsync.valueOrNull ?? [];

              final subject = subjects
                  .where((s) => s.id == slot.subjectId)
                  .firstOrNull;
              final classData = classes
                  .where((c) => c.id == slot.classId)
                  .firstOrNull;

              final pseudoAssignment = FacultyAssignmentModel(
                id: slot.id,
                collegeId: slot.collegeId,
                facultyId: slot.facultyId,
                classId: slot.classId,
                subjectId: slot.subjectId,
              );

              return _AssignmentCard(
                timeSlot: '${slot.startTime} - ${slot.endTime}',
                subjectName: subject?.name ?? slot.subjectId,
                className: classData != null
                    ? '${classData.year} - ${classData.section}'
                    : slot.classId,
                onStartSession: () => context.push(
                  '/faculty/start-session',
                  extra: {
                    'assignment': pseudoAssignment,
                    'subjectName': subject?.name ?? 'Subject',
                  },
                ),
              );
            }, childCount: todaySlots.length),
          ),
        );
      },
      loading: () => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) =>
          SliverFillRemaining(child: Center(child: Text('Error: $e'))),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final String timeSlot;
  final String subjectName;
  final String className;
  final VoidCallback onStartSession;

  const _AssignmentCard({
    required this.timeSlot,
    required this.subjectName,
    required this.className,
    required this.onStartSession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                timeSlot,
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
                      fontSize: 16,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    className,
                    style: GoogleFonts.inter(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: onStartSession,
              icon: const Icon(Icons.play_arrow, size: 18),
              label: const Text('Start'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
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
