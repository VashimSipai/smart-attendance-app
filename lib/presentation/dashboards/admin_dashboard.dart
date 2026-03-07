import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/auth_controller.dart';
import '../admin/manage_programs_screen.dart';
import '../admin/manage_classes_screen.dart';
import '../admin/manage_subjects_screen.dart';
import '../admin/manage_faculty_screen.dart';
import '../admin/manage_timetable_screen.dart';
import '../admin/reports_screen.dart';
import '../admin/college_settings_screen.dart';

/// The currently selected admin page index
final adminPageIndexProvider = StateProvider<int>((ref) => 0);

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  static const _navItems = [
    _NavItem(
      icon: Icons.school_outlined,
      activeIcon: Icons.school,
      label: 'Programs',
    ),
    _NavItem(
      icon: Icons.class_outlined,
      activeIcon: Icons.class_,
      label: 'Classes',
    ),
    _NavItem(
      icon: Icons.book_outlined,
      activeIcon: Icons.book,
      label: 'Subjects',
    ),
    _NavItem(
      icon: Icons.people_outline,
      activeIcon: Icons.people,
      label: 'Faculty',
    ),
    _NavItem(
      icon: Icons.schedule_outlined,
      activeIcon: Icons.schedule,
      label: 'Timetable',
    ),
    _NavItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart,
      label: 'Reports',
    ),
    _NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  static const _pages = [
    ManageProgramsScreen(),
    ManageClassesScreen(),
    ManageSubjectsScreen(),
    ManageFacultyScreen(),
    ManageTimetableScreen(),
    ReportsScreen(),
    CollegeSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(adminPageIndexProvider);
    final authState = ref.watch(authControllerProvider);
    final collegeName = authState.user?.name ?? 'Admin Panel';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Row(
        children: [
          // ── Sidebar ────────────────────────────────────────────────
          Container(
            width: 260,
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Logo area
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF10B981)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.fingerprint,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Smart Attend',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Admin Panel',
                              style: GoogleFonts.inter(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                // Navigation items
                ...List.generate(_navItems.length, (i) {
                  final item = _navItems[i];
                  final isSelected = selectedIndex == i;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    child: Material(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () =>
                            ref.read(adminPageIndexProvider.notifier).state = i,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? item.activeIcon : item.icon,
                                color: isSelected
                                    ? const Color(0xFF3B82F6)
                                    : Colors.white38,
                                size: 20,
                              ),
                              const SizedBox(width: 14),
                              Text(
                                item.label,
                                style: GoogleFonts.inter(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white54,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const Spacer(),
                // User card at bottom
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xFF3B82F6),
                        child: Text(
                          collegeName.isNotEmpty
                              ? collegeName[0].toUpperCase()
                              : 'A',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              collegeName,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'College Admin',
                              style: GoogleFonts.inter(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white38,
                          size: 18,
                        ),
                        onPressed: () =>
                            ref.read(authControllerProvider.notifier).signOut(),
                        tooltip: 'Logout',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),

          // ── Main content ───────────────────────────────────────────
          Expanded(child: _pages[selectedIndex]),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
