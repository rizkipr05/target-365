import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/app_models.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class MotivasiScreen extends StatefulWidget {
  final AppBootstrap bootstrap;

  const MotivasiScreen({super.key, required this.bootstrap});

  @override
  State<MotivasiScreen> createState() => _MotivasiScreenState();
}

class _MotivasiScreenState extends State<MotivasiScreen> {
  late AppBootstrap _bootstrap;
  String _activeTab = 'Semua';
  bool _showLikedOnly = false;
  int _currentPage = 0;
  final List<String> _tabs = [
    'Semua', 'Inspirasi', 'Produktivitas', 'Kehidupan', 'Kebiasaan', 'Mindset'
  ];

  @override
  void initState() {
    super.initState();
    _bootstrap = widget.bootstrap;
  }

  List<_QuoteData> get _quotes => _bootstrap.quotes
      .map(
        (q) => _QuoteData(
          id: q.id,
          category: q.category,
          categoryColor: q.categoryColor,
          text: q.text,
          date: q.date,
          liked: q.liked,
        ),
      )
      .toList();

  List<_QuoteData> get _filteredQuotes {
    final filtered = _quotes.where((quote) {
      final matchesTab = _activeTab == 'Semua' || quote.category == _activeTab;
      final matchesArchive = !_showLikedOnly || quote.liked;
      return matchesTab && matchesArchive;
    }).toList();

    return filtered;
  }

  int get _pageSize => 6;

  int get _pageCount => max(1, (_filteredQuotes.length / _pageSize).ceil());

  List<_QuoteData> get _pagedQuotes {
    final start = (_currentPage * _pageSize)
        .clamp(0, max(0, _filteredQuotes.length))
        .toInt();
    final end = min(start + _pageSize, _filteredQuotes.length).toInt();
    if (start >= end) {
      return const [];
    }
    return _filteredQuotes.sublist(start, end);
  }

  void _applyTab(String tab) {
    setState(() {
      _activeTab = tab;
      _currentPage = 0;
    });
  }

  void _toggleArchiveView() {
    setState(() {
      _showLikedOnly = !_showLikedOnly;
      _currentPage = 0;
    });
  }

  void _goToPage(int page) {
    final next = page.clamp(0, _pageCount - 1);
    if (next == _currentPage) {
      return;
    }
    setState(() => _currentPage = next);
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
                  title: const Text('Motivasi Harian'),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PrimaryButton(
                        label: _showLikedOnly ? 'Semua' : 'Arsip',
                        icon: Icons.bookmark_border_rounded,
                        outlined: true,
                        onTap: _toggleArchiveView,
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
                        label: _showLikedOnly ? 'Semua Motivasi' : 'Arsip Motivasi',
                        icon: Icons.bookmark_border_rounded,
                        outlined: true,
                        onTap: _toggleArchiveView,
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
    final grouped = <String, int>{};
    for (final quote in _bootstrap.quotes) {
      grouped[quote.category] = (grouped[quote.category] ?? 0) + 1;
    }
    final categories = [
      {'name': 'Semua Motivasi', 'count': _bootstrap.quotes.length},
      ...grouped.entries.map((e) => {'name': e.key, 'count': e.value}),
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
                onTap: () {
                  final categoryName = c['name'] as String;
                  if (categoryName == 'Semua Motivasi') {
                    setState(() {
                      _activeTab = 'Semua';
                      _showLikedOnly = false;
                      _currentPage = 0;
                    });
                    return;
                  }

                  if (_tabs.contains(categoryName)) {
                    _applyTab(categoryName);
                  } else {
                    setState(() {
                      _showLikedOnly = false;
                      _currentPage = 0;
                    });
                  }
                },
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
              onTap: _showSendMotivationDialog,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSendMotivationDialog() async {
    final quoteController = TextEditingController();
    String selectedCategory = _tabs[1];

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Kirim Motivasi'),
            content: StatefulBuilder(
              builder: (context, setLocalState) {
                return SizedBox(
                  width: 420,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(labelText: 'Kategori'),
                        items: _tabs
                            .skip(1)
                            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;
                          setLocalState(() => selectedCategory = value);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: quoteController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Kutipan',
                          hintText: 'Tulis kutipan motivasi di sini...',
                        ),
                      ),
                    ],
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
                child: const Text('Kirim'),
              ),
            ],
          );
        },
      );

      if (result != true) return;
      await AppApi.instance.createMotivation({
        'userId': _bootstrap.user.id,
        'category': selectedCategory,
        'quote': quoteController.text.trim(),
      });
      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() => _bootstrap = refreshed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Motivasi berhasil dikirim')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      quoteController.dispose();
    }
  }

  List<Widget> _buildQuoteGridResponsive(bool isDesktop) {
    if (!isDesktop) return _buildQuoteGrid();
    
    // Grid of quote cards, 3 columns on desktop
    final widgets = <Widget>[];
    final quotes = _pagedQuotes;
    for (int i = 0; i < quotes.length; i += 3) {
      widgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _QuoteCard(data: quotes[i], onToggleLike: _toggleLike, onShare: _shareQuote)),
            const SizedBox(width: 10),
            Expanded(
              child: i + 1 < quotes.length
                  ? _QuoteCard(data: quotes[i + 1], onToggleLike: _toggleLike, onShare: _shareQuote)
                  : const SizedBox(),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: i + 2 < quotes.length
                  ? _QuoteCard(data: quotes[i + 2], onToggleLike: _toggleLike, onShare: _shareQuote)
                  : const SizedBox(),
            ),
          ],
        ),
      );
      if (i + 3 < quotes.length) widgets.add(const SizedBox(height: 10));
    }
    return widgets;
  }


  Widget _buildTodayCard() {
    final motivation = _bootstrap.dashboard.motivation;
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
          Text(
            '"${motivation.quote}"',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '– ${motivation.author}',
            style: const TextStyle(
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
                onPressed: _toggleArchiveView,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.share_rounded,
                    color: AppColors.textSecondary, size: 20),
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(text: '${motivation.quote}\n- ${motivation.author}'),
                  );
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Motivasi disalin ke clipboard')),
                  );
                },
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
    final quotes = _pagedQuotes;
    for (int i = 0; i < quotes.length; i += 2) {
      widgets.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _QuoteCard(data: quotes[i], onToggleLike: _toggleLike, onShare: _shareQuote)),
            const SizedBox(width: 10),
            Expanded(
              child: i + 1 < quotes.length
                  ? _QuoteCard(data: quotes[i + 1], onToggleLike: _toggleLike, onShare: _shareQuote)
                  : const SizedBox(),
            ),
          ],
        ),
      );
      if (i + 2 < quotes.length) widgets.add(const SizedBox(height: 10));
    }
    return widgets;
  }

  Widget _buildPagination() {
    if (_filteredQuotes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon:
              const Icon(Icons.chevron_left_rounded, color: AppColors.textMuted),
          onPressed: _currentPage > 0 ? () => _goToPage(_currentPage - 1) : null,
        ),
        ...List.generate(_pageCount, (index) {
          final isActive = index == _currentPage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: GestureDetector(
              onTap: () => _goToPage(index),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        IconButton(
          icon: const Icon(Icons.chevron_right_rounded,
              color: AppColors.textMuted),
          onPressed: _currentPage < _pageCount - 1 ? () => _goToPage(_currentPage + 1) : null,
        ),
      ],
    );
  }

  Future<void> _toggleLike(_QuoteData quote) async {
    try {
      await AppApi.instance.toggleMotivationLike(
        userId: _bootstrap.user.id,
        quoteId: quote.id,
        liked: !quote.liked,
      );
      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() {
        _bootstrap = refreshed;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  Future<void> _shareQuote(_QuoteData quote) async {
    await Clipboard.setData(
      ClipboardData(text: '${quote.text}\n- ${quote.category}'),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Kutipan disalin ke clipboard')),
    );
  }
}

class _QuoteData {
  final int id;
  final String category;
  final Color categoryColor;
  final String text;
  final String date;
  final bool liked;

  const _QuoteData({
    required this.id,
    required this.category,
    required this.categoryColor,
    required this.text,
    required this.date,
    required this.liked,
  });
}

class _QuoteCard extends StatelessWidget {
  final _QuoteData data;
  final Future<void> Function(_QuoteData quote) onToggleLike;
  final Future<void> Function(_QuoteData quote) onShare;

  const _QuoteCard({
    required this.data,
    required this.onToggleLike,
    required this.onShare,
  });

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
              IconButton(
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  data.liked ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: data.liked ? AppColors.primary : AppColors.textMuted,
                ),
                onPressed: () => onToggleLike(data),
              ),
              const SizedBox(width: 8),
              IconButton(
                iconSize: 16,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.share_rounded,
                  color: AppColors.textMuted,
                ),
                onPressed: () => onShare(data),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
