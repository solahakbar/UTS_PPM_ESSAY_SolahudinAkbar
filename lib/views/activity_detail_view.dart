import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../viewmodels/activity_viewmodel.dart';
import 'activity_form_view.dart';

class ActivityDetailView extends StatelessWidget {
  final ActivityViewModel viewModel;
  final String activityId;
  const ActivityDetailView({super.key, required this.viewModel, required this.activityId});

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }

  Future<void> _confirmReset(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Reset Counter?'),
        content: const Text('Nilai hitungan aktivitas ini akan dikembalikan ke 0.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Reset')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      viewModel.reset(activityId);
      _snack(context, 'Counter berhasil di-reset');
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Hapus Aktivitas?'),
        content: const Text('Aktivitas ini akan dihapus dari daftar.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(style: FilledButton.styleFrom(backgroundColor: AppColors.red), onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      // Ambil ScaffoldMessenger sebelum halaman detail ditutup agar SnackBar
      // tampil pada halaman Home dan tidak memakai BuildContext yang sudah dilepas.
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      viewModel.deleteActivity(activityId);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Aktivitas berhasil dihapus')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final activity = viewModel.getById(activityId);
        if (activity == null) return const Scaffold();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Detail Aktivitas', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
            actions: [
              IconButton(
                tooltip: 'Edit aktivitas',
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ActivityFormView(viewModel: viewModel, activityId: activityId))),
                icon: const Icon(Icons.edit_outlined),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(children: [
                    Container(
                      width: 76, height: 76,
                      decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary]), borderRadius: BorderRadius.circular(24)),
                      child: const Icon(Icons.track_changes_rounded, color: Colors.white, size: 38),
                    ),
                    const SizedBox(height: 20),
                    Text(activity.name, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.text, fontSize: 25, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 7),
                    const Text('PROGRES AKTIVITAS', style: TextStyle(color: AppColors.muted, fontSize: 10, letterSpacing: 1.8, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 28),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF203B6B), Color(0xFF17243E)]),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: const Color(0xFF38558A)),
                      ),
                      child: Column(children: [
                        const Text('TOTAL HITUNGAN', style: TextStyle(color: Color(0xFFB7C9E8), fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 10),
                        Text('${activity.counter}', style: const TextStyle(color: Colors.white, fontSize: 72, height: 1.05, fontWeight: FontWeight.w800, letterSpacing: -2)),
                        const SizedBox(height: 8),
                        const Text('Terus jaga konsistensimu!', style: TextStyle(color: Color(0xFFB7C9E8), fontSize: 12)),
                      ]),
                    ),
                    const SizedBox(height: 22),
                    Row(children: [
                      Expanded(child: _CounterButton(icon: Icons.remove_rounded, label: 'Kurangi', color: AppColors.surfaceLight, onTap: () {
                        final ok = viewModel.decrement(activityId);
                        _snack(context, ok ? 'Counter dikurangi' : 'Counter tidak boleh kurang dari 0');
                      })),
                      const SizedBox(width: 12),
                      Expanded(child: _CounterButton(icon: Icons.add_rounded, label: 'Tambah', color: AppColors.primary, onTap: () {
                        viewModel.increment(activityId);
                        _snack(context, 'Counter ditambahkan');
                      })),
                    ]),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
                      child: Row(children: [
                        const Icon(Icons.tips_and_updates_outlined, color: AppColors.secondary),
                        const SizedBox(width: 12),
                        const Expanded(child: Text('Gunakan tombol tambah dan kurangi untuk memperbarui progres aktivitas.', style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.5))),
                      ]),
                    ),
                    const SizedBox(height: 22),
                    Row(children: [
                      Expanded(child: OutlinedButton.icon(
                        onPressed: () => _confirmReset(context),
                        icon: const Icon(Icons.restart_alt_rounded), label: const Text('Reset'),
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.muted, side: const BorderSide(color: AppColors.border), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: OutlinedButton.icon(
                        onPressed: () => _confirmDelete(context),
                        icon: const Icon(Icons.delete_outline_rounded), label: const Text('Hapus'),
                        style: OutlinedButton.styleFrom(foregroundColor: AppColors.red, side: BorderSide(color: AppColors.red.withValues(alpha: .4)), padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
                      )),
                    ]),
                  ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CounterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _CounterButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    onPressed: onTap,
    icon: Icon(icon, size: 21),
    label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    style: FilledButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
  );
}
