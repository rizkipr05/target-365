import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import '../../state/app_session.dart';
import '../../widgets/common_widgets.dart';
import '../auth/login_screen.dart';

class BerandaScreen extends StatelessWidget {
  final AppBootstrap bootstrap;
  final VoidCallback? onProfileTap;
  const BerandaScreen({super.key, required this.bootstrap, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 960;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                if (!isDesktop)
                  SliverToBoxAdapter(
                    child: _buildHeader(context),
                  ),
                SliverToBoxAdapter(
                  child: _buildGreeting(),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  sliver: SliverToBoxAdapter(
                    child: _buildStatsGrid(isDesktop),
                  ),
                ),
                if (isDesktop)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildTodayTargets(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: _buildMotivationCard(),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    sliver: SliverToBoxAdapter(
                      child: _buildTodayTargets(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    sliver: SliverToBoxAdapter(
                      child: _buildMotivationCard(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.cardBg,
      child: Row(
        children: [
          // Logo
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.track_changes_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Target365',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textPrimary),
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (dialogContext) {
                      return AlertDialog(
                        title: const Text('Notifikasi'),
                        content: Text(
                          'Ada ${bootstrap.notificationsCount} notifikasi aktif untuk akun Anda.\n\nPengingat target, motivasi harian, dan pembaruan aktivitas akan tampil di sini.',
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
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '3',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            onSelected: (value) {
              if (value == 'profile') {
                if (onProfileTap != null) onProfileTap!();
              } else if (value == 'logout') {
                AppSession.instance.clear();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 18),
                    SizedBox(width: 8),
                    Text('Profil Saya'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 18, color: AppColors.danger),
                    SizedBox(width: 8),
                    Text('Keluar', style: TextStyle(color: AppColors.danger)),
                  ],
                ),
              ),
            ],
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'AP',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${bootstrap.dashboard.greeting}, ',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary),
              ),
              Text(
                '${bootstrap.user.name.split(' ').first}! 👋',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(bootstrap.dashboard.subtitle, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(bool isDesktop) {
    final stats = bootstrap.summary;
    return GridView.count(
      crossAxisCount: isDesktop ? 4 : 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isDesktop ? 1.6 : 1.55,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        StatCard(
          iconBg: Color(0xFFDCFCE7),
          icon: Icons.track_changes_rounded,
          iconColor: AppColors.primary,
          title: 'Total Target',
          value: '${stats.totalTargets}',
          subtitle: 'Semua target aktif',
        ),
        StatCard(
          iconBg: Color(0xFFEFF6FF),
          icon: Icons.check_circle_outline_rounded,
          iconColor: AppColors.secondary,
          title: 'Selesai',
          value: '${stats.completedTargets}',
          subtitle: '${stats.completedPercentLabel} dari total',
        ),
        StatCard(
          iconBg: Color(0xFFFFFBEB),
          icon: Icons.timelapse_rounded,
          iconColor: AppColors.warning,
          title: 'Sedang Berjalan',
          value: '${stats.inProgressTargets}',
          subtitle: '${stats.inProgressPercentLabel} dari total',
        ),
        StatCard(
          iconBg: Color(0xFFFFF1F2),
          icon: Icons.radio_button_unchecked_rounded,
          iconColor: AppColors.danger,
          title: 'Belum Dimulai',
          value: '${stats.notStartedTargets}',
          subtitle: '${stats.notStartedPercentLabel} dari total',
        ),
      ],
    );
  }

  Widget _buildTodayTargets() {
    final targets = bootstrap.dashboard.todayTargets;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Target Aktif Hari Ini'),
        const SizedBox(height: 12),
        ...targets.asMap().entries.map((entry) {
          final index = entry.key;
          final target = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: index < targets.length - 1 ? 10 : 0),
            child: _TargetItem(
              icon: target.icon,
              iconBg: target.iconBg,
              iconColor: target.iconColor,
              title: target.title,
              category: target.category,
              categoryColor: target.categoryColor,
              progress: target.progress,
              progressLabel: target.progressLabel,
              status: target.status,
              statusColor: target.statusColor,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMotivationCard() {
    final motivation = bootstrap.dashboard.motivation;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  motivation.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '"${motivation.quote}"',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '– ${motivation.author}',
            style: const TextStyle(
                color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TargetItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String category;
  final Color categoryColor;
  final double progress;
  final String progressLabel;
  final String status;
  final Color statusColor;

  const _TargetItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.progress,
    required this.progressLabel,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
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
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.body.copyWith(
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(category,
                        style: TextStyle(
                            fontSize: 11,
                            color: categoryColor,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              StatusBadge(label: status, color: statusColor),
            ],
          ),
          const SizedBox(height: 10),
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
              Text(progressLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
