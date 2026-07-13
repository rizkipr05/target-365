import 'package:flutter/material.dart';
import 'common_widgets.dart';
import '../theme/app_theme.dart';
import '../models/app_models.dart';
import '../services/app_api.dart';
import '../state/app_session.dart';
import '../screens/beranda/beranda_screen.dart';
import '../screens/target/target_screen.dart';
import '../screens/kategori/kategori_screen.dart';
import '../screens/motivasi/motivasi_screen.dart';
import '../screens/laporan/laporan_screen.dart';
import '../screens/kalender/kalender_screen.dart';
import '../screens/profil/profil_screen.dart';
import '../screens/auth/login_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  late Future<AppBootstrap> _bootstrapFuture;

  @override
  void initState() {
    super.initState();
    _bootstrapFuture = _loadBootstrap();
  }

  Future<AppBootstrap> _loadBootstrap() {
    final session = AppSession.instance;
    if (!session.isLoggedIn || session.user == null) {
      throw StateError('Sesi login tidak ditemukan');
    }

    return AppApi.instance.bootstrap(session.user!.id);
  }

  final List<_NavItem> _navItems = const [
    _NavItem(icon: Icons.home_rounded, label: 'Beranda'),
    _NavItem(icon: Icons.track_changes_rounded, label: 'Target Saya'),
    _NavItem(icon: Icons.grid_view_rounded, label: 'Kategori'),
    _NavItem(icon: Icons.emoji_emotions_rounded, label: 'Motivasi'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Laporan'),
    _NavItem(icon: Icons.calendar_month_rounded, label: 'Kalender'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 960;
        return FutureBuilder<AppBootstrap>(
          future: _bootstrapFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, size: 44, color: AppColors.danger),
                        const SizedBox(height: 12),
                        Text(
                          'Gagal memuat data backend',
                          style: AppTextStyles.h2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.error.toString(),
                          style: AppTextStyles.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          label: 'Coba Lagi',
                          icon: Icons.refresh_rounded,
                          onTap: () => setState(() {
                            _bootstrapFuture = _loadBootstrap();
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final bootstrap = snapshot.data!;
            final screens = [
              BerandaScreen(
                bootstrap: bootstrap,
                onProfileTap: () => setState(() => _currentIndex = 6),
              ),
              TargetScreen(bootstrap: bootstrap),
              KategoriScreen(bootstrap: bootstrap),
              MotivasiScreen(bootstrap: bootstrap),
              LaporanScreen(bootstrap: bootstrap),
              KalenderScreen(bootstrap: bootstrap),
              ProfilScreen(bootstrap: bootstrap),
            ];

            return Scaffold(
              body: Column(
                children: [
                  if (isDesktop) _buildDesktopHeader(bootstrap),
                  Expanded(
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: isDesktop ? 1200 : double.infinity,
                        ),
                        child: IndexedStack(
                          index: _currentIndex,
                          children: screens,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: isDesktop
                  ? null
                  : Container(
                      decoration: const BoxDecoration(
                        color: AppColors.cardBg,
                        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
                      ),
                      child: SafeArea(
                        child: SizedBox(
                          height: 62,
                          child: Row(
                            children: List.generate(_navItems.length, (index) {
                              final item = _navItems[index];
                              final isActive = _currentIndex == index;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _currentIndex = index),
                                  behavior: HitTestBehavior.opaque,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        item.icon,
                                        size: 22,
                                        color: isActive ? AppColors.primary : AppColors.textMuted,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        item.label,
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                                          color: isActive ? AppColors.primary : AppColors.textMuted,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        width: isActive ? 18 : 0,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  Widget _buildDesktopHeader(AppBootstrap bootstrap) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
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
              const SizedBox(width: 40),
              // Menu
              Expanded(
                child: Row(
                  children: List.generate(_navItems.length, (index) {
                    final item = _navItems[index];
                    final isActive = _currentIndex == index;
                    return InkWell(
                      onTap: () => setState(() => _currentIndex = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  item.icon,
                                  size: 16,
                                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  item.label,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                    color: isActive ? AppColors.primary : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              // Profile & Notification
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                    onPressed: () {},
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
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              PopupMenuButton<String>(
                offset: const Offset(0, 50),
                onSelected: (value) {
                  if (value == 'profile') {
                    setState(() => _currentIndex = 6);
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            bootstrap.user.initials,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            bootstrap.user.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            bootstrap.user.role,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
