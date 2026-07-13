import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class TargetScreen extends StatefulWidget {
  final AppBootstrap bootstrap;

  const TargetScreen({super.key, required this.bootstrap});

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  late AppBootstrap _bootstrap;
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Berjalan', 'Selesai', 'Belum Dimulai'];

  @override
  void initState() {
    super.initState();
    _bootstrap = widget.bootstrap;
  }

  List<TargetItem> get _filteredTargets {
    return _bootstrap.targets.where((target) {
      switch (_selectedFilter) {
        case 'Berjalan':
          return target.status == 'Sedang Berjalan';
        case 'Selesai':
          return target.status == 'Selesai';
        case 'Belum Dimulai':
          return target.status == 'Belum Dimulai';
        default:
          return true;
      }
    }).toList();
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
                  title: const Text('Target Saya'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PrimaryButton(
                        label: 'Tambah',
                        icon: Icons.add,
                        onTap: _showAddTargetDialog,
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
                        onTap: _showAddTargetDialog,
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
    final targets = _filteredTargets;
    if (targets.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: const Center(
            child: Text(
              'Tidak ada target yang cocok dengan filter',
              style: AppTextStyles.bodySmall,
            ),
          ),
        ),
      ];
    }

    return targets
        .asMap()
        .entries
        .map(
          (entry) => Padding(
            padding: EdgeInsets.only(bottom: entry.key < targets.length - 1 ? 12 : 0),
            child: _buildTargetCard(
              target: entry.value,
            ),
          ),
        )
        .toList();
  }

  Future<void> _showAddTargetDialog() async {
    final titleController = TextEditingController();
    final deadlineController = TextEditingController();
    final categories = _bootstrap.categories.isNotEmpty
        ? _bootstrap.categories.map((category) => category.name).toList()
        : ['Pengembangan Diri'];
    String selectedCategory = categories.first;
    String selectedPriority = 'Sedang';

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Tambah Target'),
            content: StatefulBuilder(
              builder: (context, setLocalState) {
                return SizedBox(
                  width: 420,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Judul target'),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: const InputDecoration(labelText: 'Kategori'),
                          items: categories
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setLocalState(() => selectedCategory = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedPriority,
                          decoration: const InputDecoration(labelText: 'Prioritas'),
                          items: const ['Rendah', 'Sedang', 'Tinggi']
                              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setLocalState(() => selectedPriority = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: deadlineController,
                          decoration: const InputDecoration(labelText: 'Deadline', hintText: '31 Des 2025'),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
      await AppApi.instance.createTarget({
        'userId': _bootstrap.user.id,
        'title': titleController.text.trim(),
        'category': selectedCategory,
        'priority': selectedPriority,
        'deadline': deadlineController.text.trim(),
      });
      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() => _bootstrap = refreshed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Target berhasil ditambahkan')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      titleController.dispose();
      deadlineController.dispose();
    }
  }

  Future<void> _showEditTargetDialog(TargetItem target) async {
    final titleController = TextEditingController(text: target.title);
    final deadlineController = TextEditingController(text: target.deadline);
    final progressController = TextEditingController(text: (target.progress * 100).round().toString());
    final categories = _bootstrap.categories.isNotEmpty
        ? _bootstrap.categories.map((category) => category.name).toList()
        : [target.category];
    String selectedCategory = categories.contains(target.category) ? target.category : categories.first;
    String selectedPriority = target.priority;
    String selectedStatus = target.status;

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setLocalState) {
              return AlertDialog(
                title: const Text('Edit Target'),
                content: SizedBox(
                  width: 440,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Judul target'),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedCategory,
                          decoration: const InputDecoration(labelText: 'Kategori'),
                          items: categories
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setLocalState(() => selectedCategory = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedPriority,
                          decoration: const InputDecoration(labelText: 'Prioritas'),
                          items: const ['Rendah', 'Sedang', 'Tinggi']
                              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setLocalState(() => selectedPriority = value);
                          },
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: deadlineController,
                          decoration: const InputDecoration(labelText: 'Deadline', hintText: '31 Des 2025'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: progressController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Progress (%)', hintText: '0 - 100'),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedStatus,
                          decoration: const InputDecoration(labelText: 'Status'),
                          items: const ['Belum Dimulai', 'Sedang Berjalan', 'Selesai']
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
        },
      );

      if (result != true) return;

      final progressPercent = double.tryParse(progressController.text.trim()) ?? (target.progress * 100);
      await AppApi.instance.updateTarget({
        'userId': _bootstrap.user.id,
        'id': target.id,
        'title': titleController.text.trim(),
        'category': selectedCategory,
        'priority': selectedPriority,
        'deadline': deadlineController.text.trim(),
        'status': selectedStatus,
        'progress': (progressPercent.clamp(0, 100)) / 100,
      });

      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() => _bootstrap = refreshed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Target berhasil diperbarui')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      titleController.dispose();
      deadlineController.dispose();
      progressController.dispose();
    }
  }

  Future<void> _deleteTarget(TargetItem target) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Target'),
        content: Text('Hapus target "${target.title}"?'),
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
      await AppApi.instance.deleteTarget(userId: _bootstrap.user.id, id: target.id);
      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() => _bootstrap = refreshed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Target berhasil dihapus')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
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
    required TargetItem target,
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
                  color: target.iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(target.icon, color: target.iconColor, size: 22),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(target.title,
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
                            color: target.categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            target.category,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: target.categoryColor),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('📅 ${target.deadline}',
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    size: 18, color: AppColors.textMuted),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditTargetDialog(target);
                  } else if (value == 'delete') {
                    _deleteTarget(target);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Hapus')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _priorityBadge(target.priority),
              const Spacer(),
              StatusBadge(label: target.status, color: target.statusColor),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: target.progress,
                    backgroundColor: AppColors.surface,
                    color: target.iconColor,
                    minHeight: 7,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(target.progressLabel,
                  style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w700, color: target.iconColor)),
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
