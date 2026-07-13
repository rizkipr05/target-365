import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class KategoriScreen extends StatefulWidget {
  final AppBootstrap bootstrap;

  const KategoriScreen({super.key, required this.bootstrap});

  @override
  State<KategoriScreen> createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  late AppBootstrap _bootstrap;
  String _searchQuery = '';
  String _statusFilter = 'Semua Status';

  @override
  void initState() {
    super.initState();
    _bootstrap = widget.bootstrap;
  }

  List<_KategoriData> get _categories => _bootstrap.categories
      .map(
        (c) => _KategoriData(
          id: c.id,
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

  List<_KategoriData> get _filteredCategories {
    final query = _searchQuery.trim().toLowerCase();
    return _categories.where((category) {
      final matchesSearch = query.isEmpty ||
          category.name.toLowerCase().contains(query) ||
          category.description.toLowerCase().contains(query);
      final matchesStatus =
          _statusFilter == 'Semua Status' || category.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  List<String> get _statusOptions {
    final values = <String>{'Semua Status'};
    for (final category in _categories) {
      values.add(category.status);
    }
    return values.toList();
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
                  title: const Text('Kategori'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PrimaryButton(
                        label: 'Tambah',
                        icon: Icons.add,
                        onTap: _showAddCategoryDialog,
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
                        onTap: _showAddCategoryDialog,
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
                    value: '${_bootstrap.targets.length}',
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
                                  onPressed: () => setState(() {
                                    _searchQuery = '';
                                    _statusFilter = 'Semua Status';
                                  }),
                                  child: const Text('Reset', style: TextStyle(fontSize: 12)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Text('Status', style: AppTextStyles.label),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _statusFilter,
                              items: _statusOptions
                                  .map((status) => DropdownMenuItem(
                                        value: status,
                                        child: Text(status, overflow: TextOverflow.ellipsis),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _statusFilter = value);
                              },
                            ),
                            const SizedBox(height: 16),
                            const Text('Cari', style: AppTextStyles.label),
                            const SizedBox(height: 6),
                            TextField(
                              decoration: const InputDecoration(
                                hintText: 'Cari kategori...',
                                isDense: true,
                              ),
                              onChanged: (value) => setState(() => _searchQuery = value),
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
                            ...List.generate(_filteredCategories.length, (index) {
                              final cat = _filteredCategories[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _buildCategoryRow(cat),
                              );
                            }),
                            const SizedBox(height: 12),
                            const Center(
                              child: Text('Menampilkan kategori yang cocok dengan filter', style: AppTextStyles.caption),
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
                        onPressed: () => setState(() {
                          _searchQuery = '';
                          _statusFilter = 'Semua Status';
                        }),
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
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari kategori...',
                      hintStyle: AppTextStyles.bodySmall,
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: AppColors.textMuted, size: 18),
                    ),
                    style: AppTextStyles.body,
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(_filteredCategories.length, (index) {
                  final cat = _filteredCategories[index];
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: index < _filteredCategories.length - 1 ? 10 : 0),
                    child: _CategoryCard(
                      data: cat,
                      onEdit: () => _showEditCategoryDialog(cat),
                      onDelete: () => _deleteCategory(cat),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                const Center(child: Text('Gunakan pencarian dan filter status untuk menyaring kategori', style: AppTextStyles.caption)),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _showAddCategoryDialog() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Tambah Kategori'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nama kategori'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Deskripsi'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      );

      if (result != true) return;
      await AppApi.instance.createCategory({
        'userId': _bootstrap.user.id,
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'jumlahTarget': '0 target',
      });
      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() => _bootstrap = refreshed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil ditambahkan')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      nameController.dispose();
      descriptionController.dispose();
    }
  }

  Future<void> _showEditCategoryDialog(_KategoriData data) async {
    final nameController = TextEditingController(text: data.name);
    final descriptionController = TextEditingController(text: data.description);
    final jumlahTargetController = TextEditingController(text: data.jumlahTarget);
    String selectedStatus = data.status;

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Edit Kategori'),
            content: StatefulBuilder(
              builder: (context, setLocalState) {
                return SizedBox(
                  width: 420,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(labelText: 'Nama kategori'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: descriptionController,
                          maxLines: 3,
                          decoration: const InputDecoration(labelText: 'Deskripsi'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: jumlahTargetController,
                          decoration: const InputDecoration(labelText: 'Jumlah target'),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedStatus,
                          decoration: const InputDecoration(labelText: 'Status'),
                          items: const ['Aktif', 'Nonaktif']
                              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setLocalState(() => selectedStatus = value);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      );

      if (result != true) return;
      await AppApi.instance.updateCategory({
        'userId': _bootstrap.user.id,
        'id': data.id,
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
        'jumlahTarget': jumlahTargetController.text.trim(),
        'status': selectedStatus,
      });
      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() => _bootstrap = refreshed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil diperbarui')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      nameController.dispose();
      descriptionController.dispose();
      jumlahTargetController.dispose();
    }
  }

  Future<void> _deleteCategory(_KategoriData data) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: Text('Hapus kategori "${data.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await AppApi.instance.deleteCategory(userId: _bootstrap.user.id, id: data.id);
      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() => _bootstrap = refreshed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori berhasil dihapus')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
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
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(
                label: data.status,
                color: data.status == 'Aktif' ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16, color: AppColors.textMuted),
                onPressed: () => _showEditCategoryDialog(data),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.more_vert, size: 16, color: AppColors.textMuted),
                onPressed: () => _deleteCategory(data),
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
  final int id;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String name;
  final String description;
  final String jumlahTarget;
  final String status;

  const _KategoriData({
    required this.id,
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
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.data,
    required this.onEdit,
    required this.onDelete,
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
                    StatusBadge(
                      label: data.status,
                      color: data.status == 'Aktif'
                          ? AppColors.primary
                          : AppColors.textMuted,
                    ),
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
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.more_vert,
                    size: 16, color: AppColors.textMuted),
                onPressed: onDelete,
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
