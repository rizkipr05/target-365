import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class TargetScreen extends StatefulWidget {
  final AppBootstrap bootstrap;

  const TargetScreen({super.key, required this.bootstrap});

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Berjalan', 'Selesai', 'Belum Dimulai'];

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
                  title: const Text('Target Saya'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PrimaryButton(
                        label: 'Tambah',
                        icon: Icons.add,
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isDesktop)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                  child: Row(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target Saya', style: AppTextStyles.h1),
                          SizedBox(height: 4),
                          Text('Kelola dan pantau semua target aktif Anda',
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const Spacer(),
                      PrimaryButton(
                        label: 'Tambah Target',
                        icon: Icons.add,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              _buildFilterTabs(),
              Expanded(
                child: isDesktop
                    ? GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.45,
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 80),
                        children: _buildTargetList(),
                      )
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
                        children: _buildTargetList(),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildTargetList() {
    final targets = widget.bootstrap.targets;
    return targets
        .asMap()
        .entries
        .map(
          (entry) => Padding(
            padding: EdgeInsets.only(bottom: entry.key < targets.length - 1 ? 12 : 0),
            child: _buildTargetCard(
              icon: entry.value.icon,
              iconBg: entry.value.iconBg,
              iconColor: entry.value.iconColor,
              title: entry.value.title,
              category: entry.value.category,
              categoryColor: entry.value.categoryColor,
              priority: entry.value.priority,
              deadline: entry.value.deadline,
              progress: entry.value.progress,
              progressLabel: entry.value.progressLabel,
              status: entry.value.status,
              statusColor: entry.value.statusColor,
            ),
          ),
        )
        .toList();
  }

  Widget _buildFilterTabs() {
    return Container(
      color: AppColors.cardBg,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((f) {
            final isSelected = _selectedFilter == f;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilter = f),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    f,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTargetCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String category,
    required Color categoryColor,
    required String priority,
    required String deadline,
    required double progress,
    required String progressLabel,
    required String status,
    required Color statusColor,
  }) {
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.h3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: categoryColor),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('📅 $deadline',
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert,
                    size: 18, color: AppColors.textMuted),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _priorityBadge(priority),
              const Spacer(),
              StatusBadge(label: status, color: statusColor),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.surface,
                    color: iconColor,
                    minHeight: 7,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(progressLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700, color: iconColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priorityBadge(String priority) {
    Color color;
    IconData icon;
    switch (priority) {
      case 'Tinggi':
        color = AppColors.danger;
        icon = Icons.flag_rounded;
        break;
      case 'Sedang':
        color = AppColors.warning;
        icon = Icons.flag_rounded;
        break;
      default:
        color = AppColors.textMuted;
        icon = Icons.flag_outlined;
    }
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(
          'Prioritas: $priority',
          style: TextStyle(
              fontSize: 11, color: color, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
