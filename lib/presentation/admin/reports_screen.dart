import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/session_model.dart';
import '../../data/repositories/class_repository.dart';
import '../../data/repositories/program_repository.dart';
import '../../data/repositories/subject_repository.dart';
import '../../data/repositories/faculty_assignment_repository.dart';
import '../auth/auth_controller.dart';

/// Streams all sessions (active & ended) for the college
final _allSessionsProvider = StreamProvider.autoDispose<List<SessionModel>>((
  ref,
) {
  final collegeId = ref.watch(authControllerProvider).user?.collegeId;
  if (collegeId == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('colleges')
      .doc(collegeId)
      .collection('sessions')
      .orderBy('startTime', descending: true)
      .limit(100)
      .snapshots()
      .map(
        (snap) => snap.docs
            .map((d) => SessionModel.fromJson({'id': d.id, ...d.data()}))
            .toList(),
      );
});

/// Counts attendance records for a session
final _attendanceCountProvider = FutureProvider.autoDispose.family<int, String>(
  (ref, sessionId) async {
    final collegeId = ref.read(authControllerProvider).user?.collegeId;
    if (collegeId == null) return 0;
    final snap = await FirebaseFirestore.instance
        .collection('colleges')
        .doc(collegeId)
        .collection('sessions')
        .doc(sessionId)
        .collection('attendance')
        .count()
        .get();
    return snap.count ?? 0;
  },
);

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String? filterProgramId;
  String? filterClassId;

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(_allSessionsProvider);
    final classesAsync = ref.watch(classesStreamProvider);
    final subjectsAsync = ref.watch(subjectsStreamProvider);
    final programsAsync = ref.watch(programsStreamProvider);
    final faculty = ref.watch(facultyMembersStreamProvider).valueOrNull ?? [];
    final classes = classesAsync.valueOrNull ?? [];
    final subjects = subjectsAsync.valueOrNull ?? [];
    final programs = programsAsync.valueOrNull ?? [];

    final filteredClasses = classes
        .where((c) => filterProgramId == null || c.programId == filterProgramId)
        .toList();

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports & Analytics',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Session history and attendance insights for your institution.',
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),

          // ── Summary cards ──────────────────────────────────────────
          sessionsAsync.when(
            data: (sessions) {
              final total = sessions.length;
              final active = sessions.where((s) => s.isActive).length;
              final ended = total - active;
              return Row(
                children: [
                  _SummaryCard(
                    label: 'Total Sessions',
                    value: '$total',
                    icon: Icons.event_note,
                    color: const Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 16),
                  _SummaryCard(
                    label: 'Active Now',
                    value: '$active',
                    icon: Icons.radio_button_checked,
                    color: const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 16),
                  _SummaryCard(
                    label: 'Completed',
                    value: '$ended',
                    icon: Icons.check_circle_outline,
                    color: const Color(0xFF8B5CF6),
                  ),
                  const SizedBox(width: 16),
                  _SummaryCard(
                    label: 'Faculty',
                    value: '${faculty.length}',
                    icon: Icons.people,
                    color: const Color(0xFFF59E0B),
                  ),
                ],
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 24),

          // ── Filters ────────────────────────────────────────────────
          Row(
            children: [
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  value: filterProgramId,
                  decoration: _filterDecor('Filter by Program'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Programs'),
                    ),
                    ...programs.map(
                      (p) => DropdownMenuItem(
                        value: p.id,
                        child: Text(p.name, overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ],
                  onChanged: (val) => setState(() {
                    filterProgramId = val;
                    filterClassId = null;
                  }),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  value: filterClassId,
                  decoration: _filterDecor('Filter by Class'),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Classes'),
                    ),
                    ...filteredClasses.map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text('${c.year} — Sec ${c.section}'),
                      ),
                    ),
                  ],
                  onChanged: (val) => setState(() => filterClassId = val),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Session history table ──────────────────────────────────
          Expanded(
            child: sessionsAsync.when(
              data: (sessions) {
                var filtered = sessions;
                if (filterClassId != null) {
                  filtered = filtered
                      .where((s) => s.classId == filterClassId)
                      .toList();
                } else if (filterProgramId != null) {
                  final classIds = filteredClasses.map((c) => c.id).toSet();
                  filtered = filtered
                      .where((s) => classIds.contains(s.classId))
                      .toList();
                }

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No sessions found',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sessions will appear here once faculty start attendance.',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
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
                                flex: 2,
                                child: Text('DATE', style: _hStyle),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('SUBJECT', style: _hStyle),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('FACULTY', style: _hStyle),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('CLASS', style: _hStyle),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('STATUS', style: _hStyle),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text('ATTENDANCE', style: _hStyle),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: ListView.separated(
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final session = filtered[index];
                              final sub = subjects
                                  .where((s) => s.id == session.subjectId)
                                  .firstOrNull;
                              final fac = faculty
                                  .where((f) => f.uid == session.facultyId)
                                  .firstOrNull;
                              final cls = classes
                                  .where((c) => c.id == session.classId)
                                  .firstOrNull;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _formatDate(session.startTime),
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                          Text(
                                            _formatTime(session.startTime),
                                            style: GoogleFonts.inter(
                                              fontSize: 11,
                                              color: const Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        sub?.name ?? '—',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        fac?.name ?? '—',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        cls != null
                                            ? '${cls.year} — Sec ${cls.section}'
                                            : '—',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          color: const Color(0xFF64748B),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: session.isActive
                                              ? const Color(
                                                  0xFF10B981,
                                                ).withValues(alpha: 0.1)
                                              : const Color(
                                                  0xFF64748B,
                                                ).withValues(alpha: 0.08),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          session.isActive ? 'Live' : 'Ended',
                                          style: GoogleFonts.inter(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: session.isActive
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFF64748B),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: _AttendanceCount(
                                        sessionId: session.id,
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

  static final _hStyle = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF94A3B8),
    letterSpacing: 1,
  );

  InputDecoration _filterDecor(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}

// ── Attendance count cell (lazy-loaded) ─────────────────────────────

class _AttendanceCount extends ConsumerWidget {
  final String sessionId;
  const _AttendanceCount({required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(_attendanceCountProvider(sessionId));
    return countAsync.when(
      data: (count) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.people_outline, size: 14, color: Color(0xFF3B82F6)),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (_, __) => const Text('—'),
    );
  }
}

// ── Summary card ────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
