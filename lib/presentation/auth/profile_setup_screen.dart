import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/program_repository.dart';
import '../../data/repositories/class_repository.dart';
import 'auth_controller.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _rollController;

  String? _selectedProgramId;
  String? _selectedClassId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _rollController = TextEditingController(text: user?.rollNumber ?? '');
    _selectedProgramId = user?.programId;
    _selectedClassId = user?.classId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rollController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(UserModel currentUser) async {
    if (!_formKey.currentState!.validate()) return;

    if (currentUser.role == 'student' &&
        (_selectedProgramId == null || _selectedClassId == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your Program and Class')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final updatedUser = currentUser.copyWith(
        name: _nameController.text.trim(),
        rollNumber: currentUser.role == 'student'
            ? _rollController.text.trim()
            : null,
        programId: _selectedProgramId,
        classId: _selectedClassId,
        profileCompleted: true,
      );

      await ref
          .read(authControllerProvider.notifier)
          .completeProfile(updatedUser);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).user;
    if (user == null)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final isStudent = user.role == 'student';
    final isFaculty = user.role == 'faculty';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Complete Your Profile',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: const Color(0xFF0F172A),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        ),
                        child: Icon(
                          isStudent ? Icons.school : Icons.person,
                          size: 48,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome, ${user.name.split(' ').first}',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please confirm your details before jumping into the dashboard.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      // NAME (Common)
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF1F5F9),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // ALMOST READ-ONLY EMAIL
                      TextFormField(
                        initialValue: user.email,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFE2E8F0),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // STUDENT SPECIFIC
                      if (isStudent) ...[
                        const Divider(height: 32),
                        Text(
                          'Academic Details',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _rollController,
                          decoration: InputDecoration(
                            labelText: 'Roll Number / University ID',
                            prefixIcon: const Icon(Icons.pin_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF1F5F9),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Roll number is required'
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Program Dropdown
                        Consumer(
                          builder: (context, ref, _) {
                            final programsAsync = ref.watch(
                              programsStreamProvider,
                            );
                            return programsAsync.when(
                              data: (programs) => DropdownButtonFormField<String>(
                                value: _selectedProgramId,
                                decoration: InputDecoration(
                                  labelText: 'Select Program',
                                  prefixIcon: const Icon(
                                    Icons.category_outlined,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xFFF1F5F9),
                                ),
                                items: programs
                                    .map(
                                      (p) => DropdownMenuItem(
                                        value: p.id,
                                        child: Text(p.name),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  setState(() {
                                    _selectedProgramId = val;
                                    _selectedClassId =
                                        null; // reset class when program changes
                                  });
                                },
                                validator: (val) =>
                                    val == null ? 'Required' : null,
                              ),
                              loading: () => const LinearProgressIndicator(),
                              error: (e, _) => Text('Error: $e'),
                            );
                          },
                        ),
                        const SizedBox(height: 16),

                        // Class Dropdown
                        Consumer(
                          builder: (context, ref, _) {
                            if (_selectedProgramId == null)
                              return const SizedBox.shrink();
                            final classesAsync = ref.watch(
                              classesStreamProvider,
                            );
                            return classesAsync.when(
                              data: (classes) {
                                final filtered = classes
                                    .where(
                                      (c) => c.programId == _selectedProgramId,
                                    )
                                    .toList();
                                if (filtered.isEmpty)
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'No classes found for this program.',
                                      style: TextStyle(color: Colors.red[400]),
                                    ),
                                  );

                                return DropdownButtonFormField<String>(
                                  value: _selectedClassId,
                                  decoration: InputDecoration(
                                    labelText: 'Select Class & Semester',
                                    prefixIcon: const Icon(
                                      Icons.class_outlined,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFFF1F5F9),
                                  ),
                                  items: filtered
                                      .map(
                                        (c) => DropdownMenuItem(
                                          value: c.id,
                                          child: Text(
                                            'Year ${c.year} • Sem ${c.semester} • Sec ${c.section}',
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => _selectedClassId = val),
                                  validator: (val) =>
                                      val == null ? 'Required' : null,
                                );
                              },
                              loading: () => const LinearProgressIndicator(),
                              error: (e, _) => Text('Error: $e'),
                            );
                          },
                        ),
                      ],

                      const SizedBox(height: 32),
                      SizedBox(
                        height: 56,
                        child: FilledButton(
                          onPressed: _isLoading
                              ? null
                              : () => _saveProfile(user),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1E3A8A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  isFaculty
                                      ? 'Confirm & Continue'
                                      : 'Save Profile',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
