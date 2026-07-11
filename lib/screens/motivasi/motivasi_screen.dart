import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class MotivasiScreen extends StatefulWidget {
  const MotivasiScreen({super.key});

  @override
  State<MotivasiScreen> createState() => _MotivasiScreenState();
}

class _MotivasiScreenState extends State<MotivasiScreen> {
  String _activeTab = 'Semua';
  final List<String> _tabs = [
    'Semua', 'Inspirasi', 'Produktivitas', 'Kehidupan', 'Kebiasaan', 'Mindset'
  ];

  final List<_QuoteData> _quotes = const [
    _QuoteData(
      category: 'Inspirasi',
      categoryColor: AppColors.secondary,
      text: '"Jangan menunggu waktu yang tepat, karena waktu tidak akan pernah tepat. Mulailah sekarang."',
      date: '24 Mei 2025',
      liked: false,
    ),
    _QuoteData(
      category: 'Produktivitas',
      categoryColor: AppColors.purple,
      text: '"Fokus pada progres, bukan pada kesempurnaan. Sedikit setiap hari, hasilnya luar biasa."',
      date: '23 Mei 2025',
      liked: true,
    ),
    _QuoteData(
      category: 'Mindset',
      categoryColor: AppColors.pink,
      text: '"Pikiran positif akan membawa kamu ke tempat yang tidak bisa dicapai oleh pikiran negatif."',
      date: '22 Mei 2025',
      liked: false,
    ),
    _QuoteData(
      category: 'Kehidupan',
      categoryColor: AppColors.warning,
      text: '"Hidup bukan tentang menunggu badai berlalu, tapi belajar menari di tengah hujan."',
      date: '21 Mei 2025',
      liked: false,
    ),
    _QuoteData(
      category: 'Kebiasaan',
      categoryColor: AppColors.primary,
      text: '"Kebiasaan kecil yang konsisten akan menghasilkan perubahan besar dalam hidupmu."',
      date: '20 Mei 2025',
      liked: true,
    ),
    _QuoteData(
      category: 'Inspirasi',
      categoryColor: AppColors.secondary,
      text: '"Percayalah pada dirimu sendiri dan semua hal akan mungkin terjadi."',
      date: '19 Mei 2025',
      liked: false,
    ),
  ];

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
                  title: const Text('Motivasi Harian'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PrimaryButton(
                        label: 'Arsip',
                        icon: Icons.bookmark_border_rounded,
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
                          Text('Motivasi Harian', style: AppTextStyles.h1),
                          SizedBox(height: 4),
                          Text('Temukan kutipan harian untuk menjaga semangat dan fokus pada targetmu.',
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const Spacer(),
                      PrimaryButton(
                        label: 'Arsip Motivasi',
                        icon: Icons.bookmark_border_rounded,
                        outlined: true,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column: Quote Banner, Categories tab chips, quotes grid
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTodayCard(),
                          const SizedBox(height: 16),
                          _buildTabs(),
                          const SizedBox(height: 14),
                          ..._buildQuoteGridResponsive(isDesktop),
                          const SizedBox(height: 16),
                          _buildPagination(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Right Column: Streak, Category Stats, Send Quote Action
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStreakCard(),
                          const SizedBox(height: 16),
                          _buildCategoryListCard(),
                          const SizedBox(height: 16),
                          _buildKirimMotivasiCard(),
                        ],
                      ),
                    ),
                  ],
                )
              else ...[
                // Mobile
                _buildTodayCard(),
                const SizedBox(height: 16),
                _buildStreakCard(),
                const SizedBox(height: 16),
                _buildTabs(),
                const SizedBox(height: 14),
                ..._buildQuoteGrid(),
                const SizedBox(height: 12),
                _buildPagination(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryListCard() {
    final categories = [
      {'name': 'Semua Motivasi', 'count': 24},
      {'name': 'Inspirasi', 'count': 6},
      {'name': 'Produktivitas', 'count': 5},
      {'name': 'Kehidupan', 'count': 4},
      {'name': 'Kebiasaan', 'count': 5},
      {'name': 'Mindset', 'count': 4},
    ];

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
          const Text('Kategori Motivasi', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          ...categories.map((c) => InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Text(c['name'] as String, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${c['count']}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.chevron_right, size: 16, color: AppColors.textMuted),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildKirimMotivasiCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('✨ Punya Kutipan Favorit?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
            ],
          ),
          const SizedBox(height: 6),
          const Text('Bagikan motivasi favoritmu untuk menyemangati pengguna lain di komunitas Target365.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.4)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Tulis kutipan motivasimu di sini...',
                hintStyle: TextStyle(fontSize: 12, color: AppColors.textMuted),
                border: InputBorder.none,
                isDense: true,
              ),
              maxLines: 2,
              style: TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              label: 'Kirim Motivasi',
              icon: Icons.send_rounded,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQuoteGridResponsive(bool isDesktop) {
    if (!isDesktop) return _buildQuoteGrid();
    
    // Grid of quote cards, 3 columns on desktop
    final widgets = <Widget>[];
    for (int i = 0; i < _quotes.length; i += 3) {
      widgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _QuoteCard(data: _quotes[i])),
            const SizedBox(width: 10),
            Expanded(
              child: i + 1 < _quotes.length
                  ? _QuoteCard(data: _quotes[i + 1])
                  : const SizedBox(),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: i + 2 < _quotes.length
                  ? _QuoteCard(data: _quotes[i + 2])
                  : const SizedBox(),
            ),
          ],
        ),
      );
      if (i + 3 < _quotes.length) widgets.add(const SizedBox(height: 10));
    }
    return widgets;
  }


  Widget _buildTodayCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF0FFF4), Color(0xFFDCFCE7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
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
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 12, color: AppColors.primaryDark),
                    SizedBox(width: 4),
                    Text(
                      'Motivasi Hari Ini',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '"Disiplin hari ini adalah\nkeberhasilan masa depanmu."',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '– Target365',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.bookmark_border_rounded,
                    color: AppColors.textSecondary, size: 20),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.share_rounded,
                    color: AppColors.textSecondary, size: 20),
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

  Widget _buildStreakCard() {
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
              const Text('Streak Motivasi 🔥', style: AppTextStyles.h3),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '7 Hari',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.warning),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Pertahankan streak-mu!',
              style: AppTextStyles.bodySmall),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min']
                .asMap()
                .entries
                .map((e) {
              final done = e.key < 5;
              return Column(
                children: [
                  Text(e.value, style: AppTextStyles.caption),
                  const SizedBox(height: 4),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: done
                          ? AppColors.primary
                          : AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      done ? Icons.check_rounded : Icons.remove_rounded,
                      size: 14,
                      color: done ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tabs.map((tab) {
          final isActive = _activeTab == tab;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _activeTab = tab),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildQuoteGrid() {
    final widgets = <Widget>[];
    for (int i = 0; i < _quotes.length; i += 2) {
      widgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _QuoteCard(data: _quotes[i])),
            const SizedBox(width: 10),
            Expanded(
              child: i + 1 < _quotes.length
                  ? _QuoteCard(data: _quotes[i + 1])
                  : const SizedBox(),
            ),
          ],
        ),
      );
      if (i + 2 < _quotes.length) widgets.add(const SizedBox(height: 10));
    }
    return widgets;
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon:
              const Icon(Icons.chevron_left_rounded, color: AppColors.textMuted),
          onPressed: () {},
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Center(
            child: Text('1',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(width: 4),
        ...[2, 3].map(
          (n) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text('$n',
                      style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded,
              color: AppColors.textMuted),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _QuoteData {
  final String category;
  final Color categoryColor;
  final String text;
  final String date;
  final bool liked;

  const _QuoteData({
    required this.category,
    required this.categoryColor,
    required this.text,
    required this.date,
    required this.liked,
  });
}

class _QuoteCard extends StatelessWidget {
  final _QuoteData data;

  const _QuoteCard({required this.data});

  @override
  Widget build(BuildContext context) {
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
              const Icon(Icons.format_quote_rounded,
                  size: 14, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: data.categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  data.category,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: data.categoryColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            data.text,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(data.date, style: AppTextStyles.caption),
              const Spacer(),
              Icon(
                Icons.bookmark_border_rounded,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 8),
              Icon(
                data.liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 14,
                color: data.liked ? AppColors.danger : AppColors.textMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
