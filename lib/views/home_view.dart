import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../viewmodels/activity_viewmodel.dart';
import 'activity_detail_view.dart';
import 'activity_form_view.dart';

class HomeView extends StatelessWidget {
  final ActivityViewModel viewModel;
  const HomeView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => ActivityFormView(viewModel: viewModel),
        )),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 5,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Aktivitas', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            final items = viewModel.activities;
            final total = items.fold<int>(0, (sum, item) => sum + item.counter);
            final highest = items.isEmpty
                ? 0
                : items.map((item) => item.counter).reduce((a, b) => a > b ? a : b);

            return LayoutBuilder(builder: (context, constraints) {
              final wide = constraints.maxWidth >= 760;
              final horizontal = wide ? 42.0 : 20.0;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1120),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(horizontal, 28, horizontal, 16),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Row(children: [
                              Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.secondary]),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: .25), blurRadius: 18, offset: const Offset(0, 7))],
                                ),
                                child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 13),
                              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('ACTIVITY COUNTER', style: TextStyle(color: AppColors.text, fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: .8)),
                                SizedBox(height: 4),
                                Text('Personal productivity space', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                              ])),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(30), border: Border.all(color: AppColors.border)),
                                child: const Row(children: [Icon(Icons.circle, color: AppColors.green, size: 8), SizedBox(width: 7), Text('TRACKING AKTIF', style: TextStyle(color: AppColors.muted, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: .7))]),
                              ),
                            ]),
                            const SizedBox(height: 38),
                            Text('Halo, tetap produktif!', style: TextStyle(color: AppColors.primary.withValues(alpha: .95), fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: .5)),
                            const SizedBox(height: 8),
                            Text('Satu langkah kecil,\nkemajuan yang berarti.', style: TextStyle(color: AppColors.text, fontSize: wide ? 34 : 29, height: 1.12, fontWeight: FontWeight.w800, letterSpacing: -1)),
                            const SizedBox(height: 10),
                            const Text('Catat aktivitasmu, pantau jumlahnya, dan lihat progres yang sudah kamu capai.', style: TextStyle(color: AppColors.muted, fontSize: 13, height: 1.55)),
                            const SizedBox(height: 25),
                            LayoutBuilder(builder: (context, statConstraints) {
                              final statWide = statConstraints.maxWidth >= 560;
                              return Wrap(spacing: 12, runSpacing: 12, children: [
                                _StatCard(width: statWide ? (statConstraints.maxWidth - 24) / 3 : statConstraints.maxWidth, icon: Icons.insights_rounded, label: 'TOTAL PENCAPAIAN', value: '$total', tint: AppColors.primary),
                                _StatCard(width: statWide ? (statConstraints.maxWidth - 24) / 3 : (statConstraints.maxWidth - 12) / 2, icon: Icons.flag_outlined, label: 'AKTIVITAS', value: '${items.length}', tint: AppColors.secondary),
                                _StatCard(width: statWide ? (statConstraints.maxWidth - 24) / 3 : (statConstraints.maxWidth - 12) / 2, icon: Icons.emoji_events_outlined, label: 'COUNTER TERTINGGI', value: '$highest', tint: AppColors.green),
                              ]);
                            }),
                            const SizedBox(height: 34),
                            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('Daftar aktivitas', style: TextStyle(color: AppColors.text, fontSize: 21, fontWeight: FontWeight.w800, letterSpacing: -.4)),
                                SizedBox(height: 5),
                                Text('Pilih aktivitas untuk melihat dan memperbarui counter.', style: TextStyle(color: AppColors.muted, fontSize: 11)),
                              ])),
                              Text('${items.length.toString().padLeft(2, '0')} TOTAL', style: const TextStyle(color: AppColors.muted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
                            ]),
                            const SizedBox(height: 15),
                          ]),
                        ),
                      ),
                    ),
                  ),
                  if (items.isEmpty)
                    SliverToBoxAdapter(child: Center(child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1120),
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: horizontal), child: _EmptyState()),
                    )))
                  else
                    SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1120),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 110),
                            child: LayoutBuilder(builder: (context, listConstraints) {
                              final columns = listConstraints.maxWidth >= 760 ? 2 : 1;
                              final cardWidth = columns == 2 ? (listConstraints.maxWidth - 14) / 2 : listConstraints.maxWidth;
                              return Wrap(
                                spacing: 14,
                                runSpacing: 14,
                                children: List.generate(items.length, (index) {
                                  final activity = items[index];
                                  final colors = [AppColors.primary, AppColors.secondary, AppColors.green, const Color(0xFFFFB86B)];
                                  return SizedBox(
                                    width: cardWidth,
                                    child: _ActivityCard(
                                      name: activity.name,
                                      count: activity.counter,
                                      color: colors[index % colors.length],
                                      onOpen: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ActivityDetailView(viewModel: viewModel, activityId: activity.id))),
                                      onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ActivityFormView(viewModel: viewModel, activityId: activity.id))),
                                    ),
                                  );
                                }),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            });
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String label;
  final String value;
  final Color tint;
  const _StatCard({required this.width, required this.icon, required this.label, required this.value, required this.tint});

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    padding: const EdgeInsets.all(17),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.border)),
    child: Row(children: [
      Container(width: 42, height: 42, decoration: BoxDecoration(color: tint.withValues(alpha: .13), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: tint, size: 21)),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: .7)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: AppColors.text, fontSize: 23, fontWeight: FontWeight.w800)),
      ])),
    ]),
  );
}

class _ActivityCard extends StatelessWidget {
  final String name;
  final int count;
  final Color color;
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  const _ActivityCard({required this.name, required this.count, required this.color, required this.onOpen, required this.onEdit});

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 43, height: 43, decoration: BoxDecoration(color: color.withValues(alpha: .13), borderRadius: BorderRadius.circular(14)), child: Icon(Icons.track_changes_rounded, color: color, size: 22)),
            const Spacer(),
            IconButton(onPressed: onEdit, tooltip: 'Edit aktivitas', icon: const Icon(Icons.edit_outlined, color: AppColors.muted, size: 19)),
            const Icon(Icons.arrow_outward_rounded, color: AppColors.muted, size: 17),
          ]),
          const SizedBox(height: 15),
          Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          const Text('Aktivitas yang sedang kamu pantau', style: TextStyle(color: AppColors.muted, fontSize: 11)),
          const SizedBox(height: 18),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('TOTAL COUNTER', style: TextStyle(color: AppColors.muted, fontSize: 9, letterSpacing: .8, fontWeight: FontWeight.w700)),
              const SizedBox(height: 3),
              Text('$count', style: TextStyle(color: color, fontSize: 30, fontWeight: FontWeight.w800, height: 1.1)),
            ])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7), decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(10)), child: Text('LIHAT DETAIL  ›', style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .4))),
          ]),
        ]),
      ),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 38, horizontal: 20),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)),
    child: const Column(children: [
      Icon(Icons.inbox_rounded, size: 42, color: AppColors.muted),
      SizedBox(height: 12),
      Text('Belum ada aktivitas', style: TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w700)),
      SizedBox(height: 6),
      Text('Tekan tombol Tambah Aktivitas untuk mulai mencatat progresmu.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.muted, fontSize: 12)),
    ]),
  );
}
