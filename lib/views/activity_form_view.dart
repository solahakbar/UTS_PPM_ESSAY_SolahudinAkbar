import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../viewmodels/activity_viewmodel.dart';

class ActivityFormView extends StatefulWidget {
  final ActivityViewModel viewModel;
  final String? activityId;
  const ActivityFormView({super.key, required this.viewModel, this.activityId});

  @override
  State<ActivityFormView> createState() => _ActivityFormViewState();
}

class _ActivityFormViewState extends State<ActivityFormView> {
  late final TextEditingController _controller;
  String? _errorText;
  bool get _isEdit => widget.activityId != null;

  @override
  void initState() {
    super.initState();
    final existing = _isEdit ? widget.viewModel.getById(widget.activityId!) : null;
    _controller = TextEditingController(text: existing?.name ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      setState(() => _errorText = 'Nama aktivitas tidak boleh kosong');
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    if (_isEdit) {
      widget.viewModel.renameActivity(widget.activityId!, name);
    } else {
      widget.viewModel.addActivity(name);
    }
    Navigator.pop(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(_isEdit ? 'Aktivitas berhasil diperbarui' : 'Aktivitas berhasil ditambahkan')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Aktivitas' : 'Aktivitas Baru', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700))),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Container(
                  width: 66, height: 66,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary]), borderRadius: BorderRadius.circular(21)),
                  child: Icon(_isEdit ? Icons.edit_rounded : Icons.add_task_rounded, color: Colors.white, size: 31),
                ),
                const SizedBox(height: 23),
                Text(_isEdit ? 'Perbarui aktivitas' : 'Buat aktivitas baru', style: const TextStyle(color: AppColors.text, fontSize: 25, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text(_isEdit ? 'Ubah nama aktivitas agar tetap sesuai dengan tujuanmu.' : 'Tambahkan hal yang ingin kamu pantau dan tingkatkan setiap hari.', style: const TextStyle(color: AppColors.muted, fontSize: 13, height: 1.6)),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('NAMA AKTIVITAS', style: TextStyle(color: AppColors.muted, fontSize: 10, letterSpacing: 1.3, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 50,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Membaca buku',
                        prefixIcon: const Icon(Icons.edit_note_rounded, color: AppColors.muted),
                        errorText: _errorText,
                        counterStyle: const TextStyle(color: AppColors.muted, fontSize: 10),
                      ),
                      onChanged: (_) { if (_errorText != null) setState(() => _errorText = null); },
                      onSubmitted: (_) => _save(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(width: double.infinity, child: FilledButton.icon(
                      onPressed: _save,
                      icon: const Icon(Icons.check_rounded),
                      label: Text(_isEdit ? 'Simpan Perubahan' : 'Buat Aktivitas'),
                    )),
                  ]),
                ),
                const SizedBox(height: 18),
                const Row(children: [
                  Icon(Icons.info_outline_rounded, color: AppColors.secondary, size: 17),
                  SizedBox(width: 8),
                  Expanded(child: Text('Nama aktivitas dapat diubah kapan saja.', style: TextStyle(color: AppColors.muted, fontSize: 11))),
                ]),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
