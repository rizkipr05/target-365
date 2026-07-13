import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class LaporanScreen extends StatelessWidget {
  final AppBootstrap bootstrap;

  const LaporanScreen({super.key, required this.bootstrap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 960;
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: isDesktop
              ? null
              : AppBar(
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Laporan Progres'),
                      Text(
                        'Pantau perkembangan targetmu secara keseluruhan',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  toolbarHeight: 64,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PrimaryButton(
                        label: 'Unduh',
                        icon: Icons.download_rounded,
                        outlined: true,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
          body: ListView(
            padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, 12, isDesktop ? 24 : 16, 80),
            children: [
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 8),
                  child: Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Laporan Progres', style: AppTextStyles.h1),
                          SizedBox(height: 4),
                          Text('Analisis detail perkembangan dan pencapaian target Anda',
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 250,
                        child: _buildDatePicker(),
                      ),
                      const SizedBox(width: 12),
                      PrimaryButton(
                        label: 'Unduh Laporan',
                        icon: Icons.download_rounded,
                        outlined: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              if (!isDesktop) ...[
                _buildDatePicker(),
                const SizedBox(height: 14),
              ],
              // Stats Cards
              GridView.count(
                crossAxisCount: isDesktop ? 5 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isDesktop ? 1.4 : 1.55,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    iconBg: Color(0xFFDCFCE7),
                    icon: Icons.track_changes_rounded,
                    iconColor: AppColors.primary,
                    title: 'Total Target',
                    value: '${bootstrap.summary.totalTargets}',
                    subtitle: 'Semua target aktif',
                  ),
                  StatCard(
                    iconBg: Color(0xFFEFF6FF),
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: AppColors.secondary,
                    title: 'Selesai',
                    value: '${bootstrap.summary.completedTargets}',
                    subtitle: '${bootstrap.summary.completedPercentLabel} dari total',
                  ),
                  StatCard(
                    iconBg: Color(0xFFFFFBEB),
                    icon: Icons.timelapse_rounded,
                    iconColor: AppColors.warning,
                    title: 'Sedang Berjalan',
                    value: '${bootstrap.summary.inProgressTargets}',
                    subtitle: '${bootstrap.summary.inProgressPercentLabel} dari total',
                  ),
                  StatCard(
                    iconBg: Color(0xFFFFF1F2),
                    icon: Icons.radio_button_unchecked_rounded,
                    iconColor: AppColors.danger,
                    title: 'Belum Dimulai',
                    value: '${bootstrap.summary.notStartedTargets}',
                    subtitle: '${bootstrap.summary.notStartedPercentLabel} dari total',
                  ),
                  if (isDesktop)
                    _buildAverageCardItem()
                ],
              ),
              if (!isDesktop) ...[
                const SizedBox(height: 14),
                _buildAverageCard(),
              ],
              const SizedBox(height: 16),
              // Filter section
              _buildFilterResponsive(isDesktop),
              const SizedBox(height: 16),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column (flex: 3): Persentase donut, target list table
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDonutChartCard(),
                          const SizedBox(height: 16),
                          _buildTargetList(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right Column (flex: 2): Progres per kategori, Ringkasan list, Pencapaian, Tren
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildProgresPerKategoriCard(),
                          const SizedBox(height: 16),
                          _buildRingkasanPerKategoriCard(),
                          const SizedBox(height: 16),
                          _buildAchievement(),
                          const SizedBox(height: 16),
                          _buildTrenProgres(),
                        ],
                      ),
                    ),
                  ],
                )
              else ...[
                // Mobile stacked layout fallback
                _buildChartSection(),
                const SizedBox(height: 14),
                _buildTargetList(),
                const SizedBox(height: 14),
                _buildAchievement(),
                const SizedBox(height: 14),
                _buildTrenProgres(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildAverageCardItem() {
    final stats = bootstrap.summary;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.bar_chart_rounded, color: AppColors.purple, size: 18),
          ),
          const SizedBox(height: 8),
          const Text('Rata-rata', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text('${stats.averageCompletion.toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const Text('Dari semua target', style: TextStyle(fontSize: 9, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _buildFilterResponsive(bool isDesktop) {
    if (!isDesktop) return _buildFilter();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          const Text('Filter Laporan', style: AppTextStyles.h3),
          const SizedBox(width: 24),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Expanded(child: Text('Semua Kategori', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                        Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Expanded(child: Text('Semua Status', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                        Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Expanded(child: Text('Semua Prioritas', style: TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                        Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          PrimaryButton(
            label: 'Terapkan Filter',
            icon: Icons.filter_alt,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          TextButton(
            onPressed: () {},
            child: const Text('Reset', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartCard() {
    final stats = bootstrap.summary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Persentase Penyelesaian', style: AppTextStyles.h3),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 130,
                    child: CircularProgressIndicator(
                        value: stats.averageCompletion / 100,
                        strokeWidth: 16,
                        backgroundColor: AppColors.danger.withOpacity(0.3),
                        color: AppColors.primary,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${stats.averageCompletion.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        const Text('Selesai', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LegendItem(color: AppColors.primary, label: 'Selesai', value: '${stats.completedPercentLabel} (${stats.completedTargets} target)'),
                    SizedBox(height: 8),
                    _LegendItem(color: AppColors.warning, label: 'Sedang Berjalan', value: '${stats.inProgressPercentLabel} (${stats.inProgressTargets} target)'),
                    SizedBox(height: 8),
                    _LegendItem(color: AppColors.danger, label: 'Belum Dimulai', value: '${stats.notStartedPercentLabel} (${stats.notStartedTargets} target)'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgresPerKategoriCard() {
    final categories = bootstrap.report.categoryProgress;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progres per Kategori', style: AppTextStyles.h3),
          SizedBox(height: 16),
          ...categories.map((item) => CategoryProgressBar(dotColor: item.color, label: item.name, percent: item.percent, barColor: item.color)),
        ],
      ),
    );
  }

  Widget _buildRingkasanPerKategoriCard() {
    final list = bootstrap.report.categoryProgress.take(3).toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan per Kategori', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          ...list.map((item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text(item.targetSummary, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                    const Spacer(),
                    Text('${item.percent}%', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
                  ],
                ),
              )),
        ],
      ),
    );
  }


  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          Icon(Icons.calendar_today_rounded,
              size: 16, color: AppColors.textSecondary),
          SizedBox(width: 8),
          Text('01 Mei 2025 – 31 Mei 2025', style: AppTextStyles.body),
          Spacer(),
          Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildAverageCard() {
    final stats = bootstrap.summary;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F3FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bar_chart_rounded,
                color: AppColors.purple, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Rata-rata Penyelesaian', style: AppTextStyles.bodySmall),
              SizedBox(height: 2),
              Text(
                '${stats.averageCompletion.toStringAsFixed(0)}%',
                style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary),
              ),
              Text('Dari semua target', style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilter() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _DropdownItem(label: 'Kategori', value: 'Semua Kategori')),
              const SizedBox(width: 8),
              Expanded(child: _DropdownItem(label: 'Status', value: 'Semua Status')),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _DropdownItem(label: 'Prioritas', value: 'Semua Prioritas')),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.filter_alt_rounded, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text('Terapkan Filter',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Progres per Kategori', style: AppTextStyles.h3),
          const SizedBox(height: 14),
          // Donut chart placeholder + legend
          Row(
            children: [
              // Donut
              SizedBox(
                width: 90,
                height: 90,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CircularProgressIndicator(
                        value: 0.62,
                        strokeWidth: 14,
                        backgroundColor: AppColors.danger.withOpacity(0.3),
                        color: AppColors.primary,
                      ),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('62%',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary)),
                        Text('Selesai',
                            style: TextStyle(
                                fontSize: 9, color: AppColors.textMuted)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Legend
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LegendItem(
                        color: AppColors.primary,
                        label: 'Selesai',
                        value: '41.67% (5)'),
                    SizedBox(height: 6),
                    _LegendItem(
                        color: AppColors.warning,
                        label: 'Sedang Berjalan',
                        value: '50.00% (6)'),
                    SizedBox(height: 6),
                    _LegendItem(
                        color: AppColors.danger,
                        label: 'Belum Dimulai',
                        value: '8.33% (1)'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          const Text('Progres per Kategori', style: AppTextStyles.h3),
          const SizedBox(height: 10),
          const CategoryProgressBar(
              dotColor: AppColors.primary,
              label: 'Pengembangan Diri',
              percent: 75,
              barColor: AppColors.primary),
          const CategoryProgressBar(
              dotColor: AppColors.secondary,
              label: 'Kesehatan',
              percent: 68,
              barColor: AppColors.secondary),
          const CategoryProgressBar(
              dotColor: AppColors.warning,
              label: 'Keuangan',
              percent: 55,
              barColor: AppColors.warning),
          const CategoryProgressBar(
              dotColor: AppColors.purple,
              label: 'Karier',
              percent: 40,
              barColor: AppColors.purple),
          const CategoryProgressBar(
              dotColor: AppColors.pink,
              label: 'Hubungan',
              percent: 30,
              barColor: AppColors.pink),
        ],
      ),
    );
  }

  Widget _buildTargetList() {
    final targets = bootstrap.report.targets;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Daftar Progres Target'),
          const SizedBox(height: 12),
          ...targets.asMap().entries.expand((entry) {
            final isLast = entry.key == targets.length - 1;
            final target = entry.value;
            return [
              _buildTargetRow(
                icon: target.icon,
                iconColor: target.iconColor,
                title: target.title,
                category: target.category,
                categoryColor: target.categoryColor,
                deadline: target.deadline,
                progress: target.progress,
                status: target.status,
                statusColor: target.statusColor,
              ),
              if (!isLast) const Divider(height: 20),
            ];
          }),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Menampilkan 1 - ${targets.length} dari ${bootstrap.summary.totalTargets} target',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String category,
    required Color categoryColor,
    required String deadline,
    required double progress,
    required String status,
    required Color statusColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(title,
                  style: AppTextStyles.body
                      .copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ),
            StatusBadge(label: status, color: statusColor),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(category,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: categoryColor)),
            ),
            const SizedBox(width: 8),
            Text('📅 $deadline', style: AppTextStyles.caption),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.surface,
                  color: iconColor,
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w700, color: iconColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAchievement() {
    final stats = bootstrap.summary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Pencapaian Bulan Ini', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('🏆', style: TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${stats.completedTargets} target berhasil diselesaikan!',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 3),
                    const Text('Pertahankan semangatmu!',
                        style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary),
              ),
              child: const Center(
                child: Text(
                  'Lihat Detail Pencapaian',
                  style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrenProgres() {
    final months = bootstrap.report.trends.map((item) => item['label'] ?? '').toList();
    final values = bootstrap.report.trends.map((item) => int.tryParse(item['value'] ?? '0') ?? 0).toList();
    final maxVal = values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tren Progres (6 Bulan Terakhir)',
              style: AppTextStyles.h3),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(months.length, (i) {
                final barHeight = (values[i] / maxVal) * 80;
                final isLast = i == months.length - 1;
                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${values[i]}%',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: isLast ? AppColors.primary : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: barHeight,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: isLast
                              ? AppColors.primary
                              : AppColors.primary.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(months[i], style: AppTextStyles.caption),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem(
      {required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(label, style: AppTextStyles.bodySmall),
        ),
        Text(value,
            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _DropdownItem extends StatelessWidget {
  final String label;
  final String value;

  const _DropdownItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(value,
                    style: AppTextStyles.bodySmall,
                    overflow: TextOverflow.ellipsis),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 14, color: AppColors.textMuted),
            ],
          ),
        ),
      ],
    );
  }
}
