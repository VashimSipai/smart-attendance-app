import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/timetable_model.dart';
import '../../../data/repositories/timetable_repository.dart';
import '../../../data/repositories/subject_repository.dart';

import '../../../data/repositories/class_repository.dart';

class WeeklyScheduleDialog extends ConsumerWidget {
  final String? classId;
  final String? facultyId;

  const WeeklyScheduleDialog({super.key, this.classId, this.facultyId})
    : assert(
        classId != null || facultyId != null,
        'Must provide classId or facultyId',
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<TimetableModel>> timetableAsync;

    if (facultyId != null) {
      timetableAsync = ref.watch(facultyTimetableStreamProvider(facultyId!));
    } else {
      timetableAsync = ref.watch(timetableStreamProvider(classId!));
    }

    final subjectsAsync = ref.watch(subjectsStreamProvider);
    final classesAsync = ref.watch(classesStreamProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: 600,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Schedule',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              facultyId != null
                  ? 'Your full week of assigned classes.'
                  : 'Your full week schedule.',
              style: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: timetableAsync.when(
                data: (slots) {
                  if (slots.isEmpty) {
                    return const Center(
                      child: Text('No schedule found for this week.'),
                    );
                  }

                  // Default order of days
                  const dayOrder = {
                    'Monday': 1,
                    'Tuesday': 2,
                    'Wednesday': 3,
                    'Thursday': 4,
                    'Friday': 5,
                    'Saturday': 6,
                    'Sunday': 7,
                  };

                  // Group by day
                  final grouped = <String, List<TimetableModel>>{};
                  for (final slot in slots) {
                    grouped.putIfAbsent(slot.day, () => []).add(slot);
                  }

                  final sortedDays = grouped.keys.toList()
                    ..sort(
                      (a, b) => (dayOrder[a] ?? 8).compareTo(dayOrder[b] ?? 8),
                    );

                  return ListView.separated(
                    itemCount: sortedDays.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 32),
                    itemBuilder: (context, index) {
                      final day = sortedDays[index];
                      final daySlots = grouped[day]!.toList()
                        ..sort((a, b) => a.startTime.compareTo(b.startTime));

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            day,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E3A8A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...daySlots.map((slot) {
                            final subjects = subjectsAsync.valueOrNull ?? [];
                            final subclassId = slot.classId;
                            final classObj = classesAsync.valueOrNull
                                ?.where((c) => c.id == subclassId)
                                .firstOrNull;
                            final subject = subjects
                                .where((s) => s.id == slot.subjectId)
                                .firstOrNull;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDBEAFE),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      '${slot.startTime} - ${slot.endTime}',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF1D4ED8),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          subject?.name ?? 'Unknown Subject',
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                        if (facultyId != null &&
                                            classObj != null) ...[
                                          const SizedBox(height: 2),
                                          Text(
                                            'Year ${classObj.year} • Sem ${classObj.semester} • Sec ${classObj.section}',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: const Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
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
      ),
    );
  }
}
