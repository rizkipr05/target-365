import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/beranda/beranda_screen.dart';
import '../screens/target/target_screen.dart';
import '../screens/kategori/kategori_screen.dart';
import '../screens/motivasi/motivasi_screen.dart';
import '../screens/laporan/laporan_screen.dart';
import '../screens/kalender/kalender_screen.dart';
import '../screens/profil/profil_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      BerandaScreen(onProfileTap: () => setState(() => _currentIndex = 6)),
      const TargetScreen(),
      const KategoriScreen(),
      const MotivasiScreen(),
      const LaporanScreen(),
      const KalenderScreen(),
      const ProfilScreen(),
    ];
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
        return Scaffold(
          body: Column(
            children: [
              if (isDesktop) _buildDesktopHeader(),
              Expanded(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: isDesktop ? 1200 : double.infinity,
                    ),
                    child: IndexedStack(
                      index: _currentIndex,
                      children: _screens,
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
                                    color: isActive
                                        ? AppColors.primary
                                        : AppColors.textMuted,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item.label,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: isActive
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                      color: isActive
                                          ? AppColors.primary
                                          : AppColors.textMuted,
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
  }

  Widget _buildDesktopHeader() {
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
              InkWell(
                onTap: () => setState(() => _currentIndex = 6),
                borderRadius: BorderRadius.circular(8),
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
                      const SizedBox(width: 8),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Andi Pratama',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Pengguna',
                            style: TextStyle(
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
