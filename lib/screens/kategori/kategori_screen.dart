import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class KategoriScreen extends StatelessWidget {
  final AppBootstrap bootstrap;

  const KategoriScreen({super.key, required this.bootstrap});

  List<_KategoriData> get _categories => bootstrap.categories
      .map(
        (c) => _KategoriData(
          icon: c.icon,
          iconBg: c.iconBg,
          iconColor: c.iconColor,
          name: c.name,
          description: c.description,
          jumlahTarget: c.jumlahTarget,
          status: c.status,
        ),
      )
      .toList();

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
                  title: const Text('Kategori'),
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
                          Text('Kategori', style: AppTextStyles.h1),
                          SizedBox(height: 4),
                          Text('Kelola kategori target untuk mengorganisasikan tujuanmu dengan lebih terstruktur.',
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const Spacer(),
                      PrimaryButton(
                        label: 'Tambah Kategori',
                        icon: Icons.add,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              // Stats
              GridView.count(
                crossAxisCount: isDesktop ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isDesktop ? 1.6 : 1.6,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    iconBg: Color(0xFFDCFCE7),
                    icon: Icons.grid_view_rounded,
                    iconColor: AppColors.primary,
                    title: 'Total Kategori',
                    value: '${_categories.length}',
                    subtitle: 'Semua kategori aktif',
                  ),
                  StatCard(
                    iconBg: Color(0xFFEFF6FF),
                    icon: Icons.folder_open_rounded,
                    iconColor: AppColors.secondary,
                    title: 'Kategori Modul',
                    value: '${_categories.length}',
                    subtitle: 'Kategori aktif',
                  ),
                  StatCard(
                    iconBg: Color(0xFFFFFBEB),
                    icon: Icons.visibility_rounded,
                    iconColor: AppColors.warning,
                    title: 'Total Digunakan',
                    value: '${bootstrap.targets.length}',
                    subtitle: 'Target menggunakan',
                  ),
                  StatCard(
                    iconBg: Color(0xFFF5F3FF),
                    icon: Icons.inventory_2_rounded,
                    iconColor: AppColors.purple,
                    title: 'Nonaktif',
                    value: '${_categories.where((item) => item.status != 'Aktif').length}',
                    subtitle: 'Kategori dinonaktifkan',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Filter Kategori (desktop sidebar)
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
                                const Icon(Icons.filter_alt_outlined,
                                    size: 18, color: AppColors.textSecondary),
                                const SizedBox(width: 8),
                                const Text('Filter Kategori',
                                    style: AppTextStyles.h3),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Reset', style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text('Status', style: AppTextStyles.label),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Row(
                                children: [
                                  Expanded(child: Text('Semua Status', style: AppTextStyles.bodySmall)),
                                  Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textMuted),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text('Urutan', style: AppTextStyles.label),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Row(
                                children: [
                                  Expanded(child: Text('Nama A - Z', style: AppTextStyles.bodySmall)),
                                  Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textMuted),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right: Category List table
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.all(16),
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
                                const Text('Daftar Kategori', style: AppTextStyles.h3),
                                const Spacer(),
                                SizedBox(
                                  width: 200,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: const TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Cari kategori...',
                                        hintStyle: AppTextStyles.bodySmall,
                                        border: InputBorder.none,
                                        isDense: true,
                                        icon: Icon(Icons.search, color: AppColors.textMuted, size: 14),
                                      ),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ...List.generate(_categories.length, (index) {
                              final cat = _categories[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _buildCategoryRow(cat),
                              );
                            }),
                            const SizedBox(height: 12),
                            const Center(
                              child: Text(
                                'Menampilkan 1 - 5 dari 8 kategori',
                                style: AppTextStyles.caption,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              else ...[
                // Mobile Layout fallback
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.filter_alt_outlined,
                          size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      const Text('Filter Kategori',
                          style: AppTextStyles.h3),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Reset Filter',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                const SectionHeader(title: 'Daftar Kategori'),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari kategori...',
                      hintStyle: AppTextStyles.bodySmall,
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: AppColors.textMuted, size: 18),
                    ),
                    style: AppTextStyles.body,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(_categories.length, (index) {
                  final cat = _categories[index];
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: index < _categories.length - 1 ? 10 : 0),
                    child: _CategoryCard(data: cat),
                  );
                }),
                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Menampilkan 1 - 5 dari 8 kategori',
                    style: AppTextStyles.caption,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryRow(_KategoriData data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: data.iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(data.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            flex: 4,
            child: Text(data.description, style: AppTextStyles.bodySmall),
          ),
          Expanded(
            flex: 1,
            child: Text(data.jumlahTarget, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          ),
          const Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(label: 'Aktif', color: AppColors.primary),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textMuted),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 16, color: AppColors.textMuted),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class _KategoriData {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String name;
  final String description;
  final String jumlahTarget;
  final String status;

  const _KategoriData({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.name,
    required this.description,
    required this.jumlahTarget,
    required this.status,
  });
}

class _CategoryCard extends StatelessWidget {
  final _KategoriData data;

  const _CategoryCard({required this.data});

  @override
  Widget build(BuildContext context) {
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
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: data.iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name,
                    style: AppTextStyles.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Text(data.description,
                    style: AppTextStyles.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(data.jumlahTarget,
                        style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    const StatusBadge(label: 'Aktif', color: AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    size: 16, color: AppColors.textMuted),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.more_vert,
                    size: 16, color: AppColors.textMuted),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
