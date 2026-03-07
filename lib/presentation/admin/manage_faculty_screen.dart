import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/faculty_assignment_model.dart';
import '../../data/repositories/faculty_assignment_repository.dart';
import '../../data/repositories/class_repository.dart';
import '../../data/repositories/subject_repository.dart';
import '../../data/repositories/program_repository.dart';
import '../auth/auth_controller.dart';

class ManageFacultyScreen extends ConsumerWidget {
  const ManageFacultyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentsAsync = ref.watch(assignmentsStreamProvider);
    final facultyAsync = ref.watch(facultyMembersStreamProvider);
    final classesAsync = ref.watch(classesStreamProvider);
    final subjectsAsync = ref.watch(subjectsStreamProvider);
    final programsAsync = ref.watch(programsStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Faculty Assignments',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Assign faculty members to subjects and classes.',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF64748B),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => _showAssignDialog(context, ref),
                icon: const Icon(Icons.person_add_alt, size: 18),
                label: Text(
                  'Assign Faculty',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Faculty count card
          _FacultyCountCard(facultyAsync: facultyAsync),
          const SizedBox(height: 24),

          // Assignments table
          Expanded(
            child: assignmentsAsync.when(
              data: (assignments) {
                final faculty = facultyAsync.valueOrNull ?? [];
                final classes = classesAsync.valueOrNull ?? [];
                final subjects = subjectsAsync.valueOrNull ?? [];
                final programs = programsAsync.valueOrNull ?? [];

                if (assignments.isEmpty) {
                  return _EmptyState(
                    onAdd: () => _showAssignDialog(context, ref),
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
                                child: Text('FACULTY', style: _headerStyle),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('SUBJECT', style: _headerStyle),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('CLASS', style: _headerStyle),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text('PROGRAM', style: _headerStyle),
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
                            itemCount: assignments.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final a = assignments[index];
                              final f = faculty
                                  .where((u) => u.uid == a.facultyId)
                                  .firstOrNull;
                              final s = subjects
                                  .where((x) => x.id == a.subjectId)
                                  .firstOrNull;
                              final c = classes
                                  .where((x) => x.id == a.classId)
                                  .firstOrNull;
                              final p = c != null
                                  ? programs
                                        .where((x) => x.id == c.programId)
                                        .firstOrNull
                                  : null;

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
                                            backgroundColor: const Color(
                                              0xFF3B82F6,
                                            ).withValues(alpha: 0.1),
                                            child: Text(
                                              (f?.name ?? 'U')[0].toUpperCase(),
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFF3B82F6),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  f?.name ?? 'Unknown',
                                                  style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                    color: const Color(
                                                      0xFF0F172A,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  f?.email ?? '',
                                                  style: GoogleFonts.inter(
                                                    color: const Color(
                                                      0xFF94A3B8,
                                                    ),
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: _Badge(
                                        label: s?.name ?? 'Unknown',
                                        color: const Color(0xFF8B5CF6),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        c != null
                                            ? '${c.year} — Sec ${c.section}'
                                            : 'Unknown',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF64748B),
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: _Badge(
                                        label: p?.name ?? '—',
                                        color: const Color(0xFF1E3A8A),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 18,
                                          color: Color(0xFFEF4444),
                                        ),
                                        tooltip: 'Remove',
                                        onPressed: () =>
                                            _confirmRemove(context, ref, a),
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

  // ── Assign dialog with cascading program → class/subject filter ──
  void _showAssignDialog(BuildContext context, WidgetRef ref) {
    String? selectedProgramId;
    String? selectedFacultyId;
    String? selectedClassId;
    String? selectedSubjectId;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final programsAsync = ref.watch(programsStreamProvider);
          final facultyAsync = ref.watch(facultyMembersStreamProvider);
          final classesAsync = ref.watch(classesStreamProvider);
          final subjectsAsync = ref.watch(subjectsStreamProvider);

          // Filter classes and subjects by selected program
          final filteredClasses =
              classesAsync.valueOrNull
                  ?.where(
                    (c) =>
                        selectedProgramId == null ||
                        c.programId == selectedProgramId,
                  )
                  .toList() ??
              [];
          final filteredSubjects =
              subjectsAsync.valueOrNull
                  ?.where(
                    (s) =>
                        selectedProgramId == null ||
                        s.programId == selectedProgramId,
                  )
                  .toList() ??
              [];

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Assign Faculty to Subject',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: 460,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step 1: Select Program (filter)
                  Text(
                    'Step 1 — Select Program',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  programsAsync.when(
                    data: (programs) => DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedProgramId,
                      decoration: _dropdownDecor('Program'),
                      items: programs
                          .map(
                            (p) => DropdownMenuItem(
                              value: p.id,
                              child: Text(p.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setState(() {
                        selectedProgramId = val;
                        selectedClassId = null;
                        selectedSubjectId = null;
                      }),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => const Text('Error'),
                  ),
                  const SizedBox(height: 20),

                  // Step 2: Select Faculty
                  Text(
                    'Step 2 — Select Faculty',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  facultyAsync.when(
                    data: (list) => DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: selectedFacultyId,
                      decoration: _dropdownDecor('Faculty Member'),
                      items: list
                          .map(
                            (f) => DropdownMenuItem(
                              value: f.uid,
                              child: Text('${f.name} (${f.email})'),
                            ),
                          )
                          .toList(),
                      onChanged: (val) =>
                          setState(() => selectedFacultyId = val),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => const Text('Error'),
                  ),
                  const SizedBox(height: 20),

                  // Step 3: Select Subject (filtered by program)
                  Text(
                    'Step 3 — Select Subject',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedSubjectId,
                    decoration: _dropdownDecor('Subject'),
                    items: filteredSubjects
                        .map(
                          (s) => DropdownMenuItem(
                            value: s.id,
                            child: Text(s.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedSubjectId = val),
                  ),
                  const SizedBox(height: 20),

                  // Step 4: Select Class (filtered by program)
                  Text(
                    'Step 4 — Select Class',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedClassId,
                    decoration: _dropdownDecor('Class'),
                    items: filteredClasses
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(
                              '${c.year} — Sec ${c.section} (Sem ${c.semester})',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedClassId = val),
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
                  final collegeId = ref
                      .read(authControllerProvider)
                      .user
                      ?.collegeId;
                  if (collegeId != null &&
                      selectedFacultyId != null &&
                      selectedClassId != null &&
                      selectedSubjectId != null) {
                    final assignment = FacultyAssignmentModel(
                      id: '',
                      collegeId: collegeId,
                      facultyId: selectedFacultyId!,
                      classId: selectedClassId!,
                      subjectId: selectedSubjectId!,
                    );
                    await ref
                        .read(facultyAssignmentRepositoryProvider)
                        .assignFaculty(collegeId, assignment);
                    if (ctx.mounted) Navigator.pop(ctx);
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Assign',
                  style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _dropdownDecor(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  void _confirmRemove(
    BuildContext context,
    WidgetRef ref,
    FacultyAssignmentModel assignment,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove Assignment?',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'This faculty member will be unassigned from the subject and class.',
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
              final collegeId = ref
                  .read(authControllerProvider)
                  .user
                  ?.collegeId;
              if (collegeId != null) {
                await ref
                    .read(facultyAssignmentRepositoryProvider)
                    .removeAssignment(collegeId, assignment.id);
              }
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
}

// ── Reusable UI widgets ────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _FacultyCountCard extends StatelessWidget {
  final AsyncValue<dynamic> facultyAsync;
  const _FacultyCountCard({required this.facultyAsync});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: facultyAsync.when(
        data: (list) {
          final members = list as List;
          return Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people,
                  color: Color(0xFF10B981),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${members.length}',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'Registered Faculty Members',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('Error: $e'),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'No assignments yet',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Assign faculty to subjects and classes.',
            style: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.person_add_alt, size: 18),
            label: Text(
              'Assign Faculty',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
