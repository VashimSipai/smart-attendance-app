import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/timetable_model.dart';
import '../../data/repositories/timetable_repository.dart';
import '../../data/repositories/class_repository.dart';
import '../../data/repositories/program_repository.dart';
import '../../data/repositories/faculty_assignment_repository.dart';
import '../../data/repositories/subject_repository.dart';
import '../auth/auth_controller.dart';

class ManageTimetableScreen extends ConsumerStatefulWidget {
  const ManageTimetableScreen({super.key});

  @override
  ConsumerState<ManageTimetableScreen> createState() =>
      _ManageTimetableScreenState();
}

class _ManageTimetableScreenState extends ConsumerState<ManageTimetableScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? selectedProgramId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final programsAsync = ref.watch(programsStreamProvider);

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Timetable Management',
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Configure working days, time slots, holidays, and build weekly schedules per program.',
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // ── Program Selection (Required first) ───────────────────
          Row(
            children: [
              Text(
                'Select Program:',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 300,
                child: programsAsync.when(
                  data: (programs) => DropdownButtonFormField<String>(
                    value: selectedProgramId,
                    decoration: InputDecoration(
                      hintText: 'Choose a program to manage',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                    items: programs
                        .map(
                          (p) => DropdownMenuItem(
                            value: p.id,
                            child: Text(
                              p.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedProgramId = val),
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => const Text('Error loading programs'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Tabs (Only show if program is selected) ──────────────
          if (selectedProgramId == null)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Select a program to configure its timetable',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: const Color(0xFF1E3A8A),
                unselectedLabelColor: const Color(0xFF64748B),
                indicatorColor: const Color(0xFF1E3A8A),
                indicatorWeight: 3,
                labelStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                tabs: const [
                  Tab(icon: Icon(Icons.grid_on), text: 'Weekly Schedule'),
                  Tab(icon: Icon(Icons.tune), text: 'Timetable Settings'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _TimetableManager(programId: selectedProgramId!),
                  _TimetableSettings(programId: selectedProgramId!),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Tab 1: Timetable Builder ──────────────────────────────────────────

class _TimetableManager extends ConsumerStatefulWidget {
  final String programId;
  const _TimetableManager({required this.programId});

  @override
  ConsumerState<_TimetableManager> createState() => _TimetableManagerState();
}

class _TimetableManagerState extends ConsumerState<_TimetableManager> {
  String? selectedClassId;

  @override
  Widget build(BuildContext context) {
    final classesAsync = ref.watch(classesStreamProvider);
    final subjectsAsync = ref.watch(subjectsStreamProvider);
    final configAsync = ref.watch(timetableConfigProvider(widget.programId));

    final filteredClasses =
        classesAsync.valueOrNull
            ?.where((c) => c.programId == widget.programId)
            .toList() ??
        [];

    return configAsync.when(
      data: (config) {
        if (config.workingDays.isEmpty || config.timeSlots.isEmpty) {
          return Center(
            child: Text(
              'Please configure Working Days and Time Slots in settings first.',
              style: GoogleFonts.inter(color: const Color(0xFF64748B)),
            ),
          );
        }

        return Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    value: selectedClassId,
                    decoration: InputDecoration(
                      labelText: 'Select Class',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
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
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: selectedClassId == null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Select a class to build its schedule',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SubjectsPanel(
                          classId: selectedClassId!,
                          subjectsAsync: subjectsAsync,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _TimetableGrid(
                            classId: selectedClassId!,
                            subjectsAsync: subjectsAsync,
                            config: config,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}

class _SubjectsPanel extends ConsumerWidget {
  final String classId;
  final AsyncValue<dynamic> subjectsAsync;
  const _SubjectsPanel({required this.classId, required this.subjectsAsync});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignmentsAsync = ref.watch(assignmentsStreamProvider);
    final subjects = (subjectsAsync.valueOrNull as List?) ?? [];
    final faculty = ref.watch(facultyMembersStreamProvider).valueOrNull ?? [];

    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Icon(
                  Icons.drag_indicator,
                  size: 16,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 6),
                Text(
                  'Drag to Schedule',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: assignmentsAsync.when(
              data: (assignments) {
                final classAssignments = assignments
                    .where((a) => a.classId == classId)
                    .toList();
                if (classAssignments.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'No faculty assigned to this class yet.',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: classAssignments.length,
                  itemBuilder: (context, index) {
                    final a = classAssignments[index];
                    final sub = subjects
                        .where((s) => s.id == a.subjectId)
                        .firstOrNull;
                    final fac = faculty
                        .where((f) => f.uid == a.facultyId)
                        .firstOrNull;

                    return Draggable<Map<String, String>>(
                      data: {
                        'subjectId': a.subjectId,
                        'facultyId': a.facultyId,
                      },
                      feedback: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E3A8A),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            sub?.name ?? 'Subject',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      childWhenDragging: _subjectCard(
                        sub?.name ?? '?',
                        fac?.name ?? '?',
                        dimmed: true,
                      ),
                      child: _subjectCard(
                        sub?.name ?? '?',
                        fac?.name ?? '?',
                        dimmed: false,
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _subjectCard(String subject, String faculty, {required bool dimmed}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: dimmed ? const Color(0xFFE2E8F0) : const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: dimmed ? Colors.transparent : const Color(0xFF93C5FD),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: dimmed ? const Color(0xFFA0AEC0) : const Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            faculty,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: dimmed ? const Color(0xFFA0AEC0) : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimetableGrid extends ConsumerWidget {
  final String classId;
  final AsyncValue<dynamic> subjectsAsync;
  final TimetableConfig config;
  const _TimetableGrid({
    required this.classId,
    required this.subjectsAsync,
    required this.config,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (config.workingDays.isEmpty || config.timeSlots.isEmpty)
      return const SizedBox();

    final timetableAsync = ref.watch(timetableStreamProvider(classId));
    final subjects = (subjectsAsync.valueOrNull as List?) ?? [];
    final faculty = ref.watch(facultyMembersStreamProvider).valueOrNull ?? [];

    return timetableAsync.when(
      data: (slots) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(
                  color: const Color(0xFFE2E8F0),
                  width: 1,
                ),
                columnWidths: {
                  0: const FixedColumnWidth(110),
                  for (int i = 1; i <= config.workingDays.length; i++)
                    i: const FlexColumnWidth(),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
                    children: [
                      _headerCell('Time'),
                      ...config.workingDays.map((d) => _headerCell(d)),
                    ],
                  ),
                  ...config.timeSlots.map((time) {
                    final isBreak =
                        time.toLowerCase().contains('break') ||
                        time.toLowerCase().contains('lunch');

                    if (isBreak) {
                      return TableRow(
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8FAFC),
                        ),
                        children: [
                          _timeCell(time),
                          ...config.workingDays.map(
                            (_) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  'BREAK',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF94A3B8),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return TableRow(
                      children: [
                        _timeCell(time),
                        ...config.workingDays.map((day) {
                          final slot = slots.where((s) {
                            final parts = time.split('-');
                            final lookupStart = parts.isNotEmpty
                                ? parts[0].trim()
                                : time.trim();
                            return s.day == day && s.startTime == lookupStart;
                          }).firstOrNull;

                          return _ScheduleCell(
                            slot: slot,
                            day: day,
                            timeSlot: time,
                            classId: classId,
                            subjects: subjects,
                            faculty: faculty,
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF475569),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _timeCell(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      color: const Color(0xFFFAFAFA),
      child: Text(
        time,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF64748B),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ScheduleCell extends ConsumerWidget {
  final TimetableModel? slot;
  final String day;
  final String timeSlot;
  final String classId;
  final List subjects;
  final List faculty;

  const _ScheduleCell({
    required this.slot,
    required this.day,
    required this.timeSlot,
    required this.classId,
    required this.subjects,
    required this.faculty,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DragTarget<Map<String, String>>(
      onAcceptWithDetails: (details) {
        final data = details.data;
        final collegeId = ref.read(authStateProvider).user?.collegeId;
        if (collegeId != null) {
          Future.delayed(const Duration(milliseconds: 100), () async {
            if (slot != null && slot!.id.isNotEmpty) {
              await ref
                  .read(timetableRepositoryProvider)
                  .deleteTimetableSlot(collegeId, slot!.id);
            }
            final parts = timeSlot.split('-');
            final start = parts.isNotEmpty ? parts[0].trim() : timeSlot;
            final end = parts.length > 1 ? parts[1].trim() : '';

            final newSlot = TimetableModel(
              id: '',
              collegeId: collegeId,
              classId: classId,
              day: day,
              startTime: start,
              endTime: end,
              subjectId: data['subjectId']!,
              facultyId: data['facultyId']!,
            );
            await ref
                .read(timetableRepositoryProvider)
                .saveTimetableSlot(collegeId, newSlot);
          });
        }
      },
      builder: (context, candidateData, rejectedData) {
        final isHover = candidateData.isNotEmpty;

        if (slot != null && slot!.id.isNotEmpty) {
          final sub = subjects
              .where((s) => s.id == slot!.subjectId)
              .firstOrNull;
          final fac = faculty
              .where((f) => f.uid == slot!.facultyId)
              .firstOrNull;

          return GestureDetector(
            onDoubleTap: () {
              final collegeId = ref.read(authStateProvider).user?.collegeId;
              if (collegeId != null) {
                Future.delayed(const Duration(milliseconds: 100), () async {
                  await ref
                      .read(timetableRepositoryProvider)
                      .deleteTimetableSlot(collegeId, slot!.id);
                });
              }
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(minHeight: 60),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                border: Border.all(
                  color: const Color(0xFF93C5FD).withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub?.name ?? '?',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E3A8A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    fac?.name ?? '?',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          constraints: const BoxConstraints(minHeight: 60),
          decoration: BoxDecoration(
            color: isHover ? const Color(0xFFFEF9C3) : Colors.transparent,
            border: isHover ? Border.all(color: const Color(0xFFFBBF24)) : null,
          ),
        );
      },
    );
  }
}

// ── Tab 2: Settings (Slots, Days, Holidays) ──────────────────────────

class _TimetableSettings extends ConsumerStatefulWidget {
  final String programId;
  const _TimetableSettings({required this.programId});

  @override
  ConsumerState<_TimetableSettings> createState() => _TimetableSettingsState();
}

class _TimetableSettingsState extends ConsumerState<_TimetableSettings> {
  final _slotController = TextEditingController();
  final _holidayNameController = TextEditingController();
  final _holidayDateController = TextEditingController();

  final List<String> _allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  Future<void> _updateConfig(
    WidgetRef ref,
    TimetableConfig oldConfig,
    TimetableConfig newConfig,
  ) async {
    final collegeId = ref.read(authControllerProvider).user?.collegeId;
    if (collegeId != null) {
      await ref
          .read(timetableRepositoryProvider)
          .saveConfig(collegeId, widget.programId, newConfig);
    }
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(timetableConfigProvider(widget.programId));

    return configAsync.when(
      data: (config) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Column: Time Slots & Working Days
            Expanded(
              child: ListView(
                children: [
                  _buildSectionCard(
                    title: 'Time Slots',
                    icon: Icons.access_time,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _slotController,
                                decoration: InputDecoration(
                                  hintText:
                                      'e.g. 09:00 - 10:00 (or "Lunch Break")',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 0,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton.icon(
                              onPressed: () {
                                final text = _slotController.text.trim();
                                if (text.isNotEmpty &&
                                    !config.timeSlots.contains(text)) {
                                  _updateConfig(
                                    ref,
                                    config,
                                    TimetableConfig(
                                      workingDays: config.workingDays,
                                      timeSlots: [...config.timeSlots, text],
                                      holidays: config.holidays,
                                    ),
                                  );
                                  _slotController.clear();
                                }
                              },
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: config.timeSlots
                              .map(
                                (slot) => Chip(
                                  label: Text(
                                    slot,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor:
                                      slot.toLowerCase().contains('break')
                                      ? const Color(0xFFFEF3C7)
                                      : const Color(0xFFF1F5F9),
                                  deleteIcon: const Icon(Icons.close, size: 16),
                                  onDeleted: () {
                                    final updated = config.timeSlots
                                        .where((s) => s != slot)
                                        .toList();
                                    _updateConfig(
                                      ref,
                                      config,
                                      TimetableConfig(
                                        workingDays: config.workingDays,
                                        timeSlots: updated,
                                        holidays: config.holidays,
                                      ),
                                    );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Working Days',
                    icon: Icons.calendar_view_week,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allDays.map((day) {
                        final isSelected = config.workingDays.contains(day);
                        return FilterChip(
                          selected: isSelected,
                          showCheckmark: false,
                          label: Text(day),
                          selectedColor: const Color(0xFFDBEAFE),
                          labelStyle: GoogleFonts.inter(
                            color: isSelected
                                ? const Color(0xFF1E3A8A)
                                : const Color(0xFF64748B),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            List<String> updated;
                            if (selected) {
                              updated = [...config.workingDays, day];
                              // sort by week order
                              updated.sort(
                                (a, b) => _allDays
                                    .indexOf(a)
                                    .compareTo(_allDays.indexOf(b)),
                              );
                            } else {
                              updated = config.workingDays
                                  .where((d) => d != day)
                                  .toList();
                            }
                            _updateConfig(
                              ref,
                              config,
                              TimetableConfig(
                                workingDays: updated,
                                timeSlots: config.timeSlots,
                                holidays: config.holidays,
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            // Right Column: Holidays
            Expanded(
              child: _buildSectionCard(
                title: 'Holidays',
                icon: Icons.celebration,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _holidayNameController,
                            decoration: InputDecoration(
                              hintText: 'Holiday Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _holidayDateController,
                            decoration: InputDecoration(
                              hintText: 'YYYY-MM-DD',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          onPressed: () {
                            final name = _holidayNameController.text.trim();
                            final date = _holidayDateController.text.trim();
                            if (name.isNotEmpty && date.isNotEmpty) {
                              final updated = [
                                ...config.holidays,
                                {'name': name, 'date': date},
                              ];
                              _updateConfig(
                                ref,
                                config,
                                TimetableConfig(
                                  workingDays: config.workingDays,
                                  timeSlots: config.timeSlots,
                                  holidays: updated,
                                ),
                              );
                              _holidayNameController.clear();
                              _holidayDateController.clear();
                            }
                          },
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: config.holidays.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final h = config.holidays[i];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEE2E2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.event_busy,
                              color: Color(0xFFEF4444),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            h['name'] ?? '',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            h['date'] ?? '',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Color(0xFFEF4444),
                              size: 20,
                            ),
                            onPressed: () {
                              final updated = List<Map<String, dynamic>>.from(
                                config.holidays,
                              )..removeAt(i);
                              _updateConfig(
                                ref,
                                config,
                                TimetableConfig(
                                  workingDays: config.workingDays,
                                  timeSlots: config.timeSlots,
                                  holidays: updated,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
