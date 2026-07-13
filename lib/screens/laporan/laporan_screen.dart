import 'dart:io';

import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class LaporanScreen extends StatefulWidget {
  final AppBootstrap bootstrap;

  const LaporanScreen({super.key, required this.bootstrap});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  late AppBootstrap _bootstrap;
  String _selectedCategory = 'Semua Kategori';
  String _selectedStatus = 'Semua Status';
  String _selectedPriority = 'Semua Prioritas';

  @override
  void initState() {
    super.initState();
    _bootstrap = widget.bootstrap;
  }

  List<ReportTargetRow> get _filteredTargets {
    return _bootstrap.report.targets.where((target) {
      final categoryMatches = _selectedCategory == 'Semua Kategori' || target.category == _selectedCategory;
      final statusMatches = _selectedStatus == 'Semua Status' || target.status == _selectedStatus;
      final priorityMatches = _selectedPriority == 'Semua Prioritas' || target.priority == _selectedPriority;
      return categoryMatches && statusMatches && priorityMatches;
    }).toList();
  }

  List<String> get _categoryOptions {
    final options = <String>{'Semua Kategori'};
    for (final target in _bootstrap.report.targets) {
      options.add(target.category);
    }
    return options.toList();
  }

  List<String> get _statusOptions {
    final options = <String>{'Semua Status'};
    for (final target in _bootstrap.report.targets) {
      options.add(target.status);
    }
    return options.toList();
  }

  List<String> get _priorityOptions {
    final options = <String>{'Semua Prioritas'};
    for (final target in _bootstrap.report.targets) {
      options.add(target.priority);
    }
    return options.toList();
  }

  void _resetFilters() {
    setState(() {
      _selectedCategory = 'Semua Kategori';
      _selectedStatus = 'Semua Status';
      _selectedPriority = 'Semua Prioritas';
    });
  }

  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }

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
                        onTap: () => _exportReport(context),
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
                        onTap: () => _exportReport(context),
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
                    value: '${_bootstrap.summary.totalTargets}',
                    subtitle: 'Semua target aktif',
                  ),
                  StatCard(
                    iconBg: Color(0xFFEFF6FF),
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: AppColors.secondary,
                    title: 'Selesai',
                    value: '${_bootstrap.summary.completedTargets}',
                    subtitle: '${_bootstrap.summary.completedPercentLabel} dari total',
                  ),
                  StatCard(
                    iconBg: Color(0xFFFFFBEB),
                    icon: Icons.timelapse_rounded,
                    iconColor: AppColors.warning,
                    title: 'Sedang Berjalan',
                    value: '${_bootstrap.summary.inProgressTargets}',
                    subtitle: '${_bootstrap.summary.inProgressPercentLabel} dari total',
                  ),
                  StatCard(
                    iconBg: Color(0xFFFFF1F2),
                    icon: Icons.radio_button_unchecked_rounded,
                    iconColor: AppColors.danger,
                    title: 'Belum Dimulai',
                    value: '${_bootstrap.summary.notStartedTargets}',
                    subtitle: '${_bootstrap.summary.notStartedPercentLabel} dari total',
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
              _buildFilterResponsive(context, isDesktop),
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
                          _buildAchievement(context),
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
                _buildAchievement(context),
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
    final stats = _bootstrap.summary;
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

  Widget _buildFilterResponsive(BuildContext context, bool isDesktop) {
    if (!isDesktop) return _buildFilter();

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
          const Row(
            children: [
              Icon(Icons.filter_alt_outlined, size: 18, color: AppColors.textSecondary),
              SizedBox(width: 8),
              Text('Filter Laporan', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Kategori',
                  value: _selectedCategory,
                  items: _categoryOptions,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedCategory = value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Status',
                  value: _selectedStatus,
                  items: _statusOptions,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedStatus = value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Prioritas',
                  value: _selectedPriority,
                  items: _priorityOptions,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _selectedPriority = value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              PrimaryButton(
                label: 'Terapkan Filter',
                icon: Icons.filter_alt,
                onTap: () {
                  final count = _filteredTargets.length;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Menampilkan $count target sesuai filter')),
                  );
                },
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: _resetFilters,
                child: const Text('Reset', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonutChartCard() {
    final stats = _bootstrap.summary;
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
    final categories = _bootstrap.report.categoryProgress;
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
    final list = _bootstrap.report.categoryProgress.take(3).toList();
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
    final stats = _bootstrap.summary;
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
          _buildFilterDropdown(
            label: 'Kategori',
            value: _selectedCategory,
            items: _categoryOptions,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedCategory = value);
            },
          ),
          const SizedBox(height: 10),
          _buildFilterDropdown(
            label: 'Status',
            value: _selectedStatus,
            items: _statusOptions,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedStatus = value);
            },
          ),
          const SizedBox(height: 10),
          _buildFilterDropdown(
            label: 'Prioritas',
            value: _selectedPriority,
            items: _priorityOptions,
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedPriority = value);
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  label: 'Terapkan Filter',
                  icon: Icons.filter_alt,
                  onTap: () {
                    final count = _filteredTargets.length;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Menampilkan $count target sesuai filter')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: _resetFilters,
                child: const Text('Reset', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
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
    final targets = _filteredTargets;
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
              targets.isEmpty
                  ? 'Tidak ada target yang cocok dengan filter'
                  : 'Menampilkan ${targets.length} target dari ${_bootstrap.summary.totalTargets}',
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

  Widget _buildAchievement(BuildContext context) {
    final stats = _bootstrap.summary;
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
            onTap: () => _showAchievementDetails(context),
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
    final months = _bootstrap.report.trends.map((item) => item.label).toList();
    final values = _bootstrap.report.trends.map((item) => item.value).toList();
    if (values.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Text('Data tren belum tersedia', style: AppTextStyles.bodySmall),
      );
    }
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

  Future<void> _exportReport(BuildContext context) async {
    try {
      final export = await AppApi.instance.exportReport(userId: _bootstrap.user.id);
      final file = File('${Directory.systemTemp.path}/${export.filename}');
      await file.writeAsString(export.content, flush: true);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Laporan disimpan ke ${file.path}')),
      );
    } on ApiException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengekspor laporan: $e')),
      );
    }
  }

  Future<void> _showAchievementDetails(BuildContext context) async {
    final stats = _bootstrap.summary;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Detail Pencapaian'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total target: ${stats.totalTargets}'),
              Text('Selesai: ${stats.completedTargets}'),
              Text('Sedang berjalan: ${stats.inProgressTargets}'),
              Text('Belum dimulai: ${stats.notStartedTargets}'),
              Text('Rata-rata penyelesaian: ${stats.averageCompletion.toStringAsFixed(0)}%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
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
