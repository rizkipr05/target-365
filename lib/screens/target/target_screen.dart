import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class TargetScreen extends StatefulWidget {
  const TargetScreen({super.key});

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
    return [
      _buildTargetCard(
        icon: Icons.menu_book_rounded,
        iconBg: const Color(0xFFDCFCE7),
        iconColor: AppColors.primary,
        title: 'Membaca 12 Buku dalam Setahun',
        category: 'Pengembangan Diri',
        categoryColor: AppColors.primary,
        priority: 'Tinggi',
        deadline: '31 Des 2024',
        progress: 0.58,
        progressLabel: '58%',
        status: 'Sedang Berjalan',
        statusColor: AppColors.warning,
      ),
      if (!Uri.base.toString().contains('desktop')) const SizedBox(height: 12),
      _buildTargetCard(
        icon: Icons.fitness_center_rounded,
        iconBg: const Color(0xFFEFF6FF),
        iconColor: AppColors.secondary,
        title: 'Olahraga 4x Seminggu',
        category: 'Kesehatan',
        categoryColor: AppColors.secondary,
        priority: 'Tinggi',
        deadline: '30 Jun 2024',
        progress: 0.75,
        progressLabel: '75%',
        status: 'Sedang Berjalan',
        statusColor: AppColors.warning,
      ),
      if (!Uri.base.toString().contains('desktop')) const SizedBox(height: 12),
      _buildTargetCard(
        icon: Icons.savings_rounded,
        iconBg: const Color(0xFFFFFBEB),
        iconColor: AppColors.warning,
        title: 'Menabung Rp10.000.000',
        category: 'Keuangan',
        categoryColor: AppColors.warning,
        priority: 'Sedang',
        deadline: '31 Des 2024',
        progress: 0.40,
        progressLabel: '40%',
        status: 'Sedang Berjalan',
        statusColor: AppColors.warning,
      ),
      if (!Uri.base.toString().contains('desktop')) const SizedBox(height: 12),
      _buildTargetCard(
        icon: Icons.laptop_rounded,
        iconBg: const Color(0xFFF5F3FF),
        iconColor: AppColors.purple,
        title: 'Belajar UI/UX Design',
        category: 'Karier',
        categoryColor: AppColors.purple,
        priority: 'Sedang',
        deadline: '15 Okt 2024',
        progress: 0.20,
        progressLabel: '20%',
        status: 'Sedang Berjalan',
        statusColor: AppColors.warning,
      ),
      if (!Uri.base.toString().contains('desktop')) const SizedBox(height: 12),
      _buildTargetCard(
        icon: Icons.flight_rounded,
        iconBg: const Color(0xFFFFF1F2),
        iconColor: AppColors.danger,
        title: 'Liburan ke Jepang',
        category: 'Keuangan',
        categoryColor: AppColors.warning,
        priority: 'Rendah',
        deadline: '31 Des 2025',
        progress: 0.10,
        progressLabel: '10%',
        status: 'Belum Dimulai',
        statusColor: AppColors.danger,
      ),
    ];
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
