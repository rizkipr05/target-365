import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class KalenderScreen extends StatefulWidget {
  final AppBootstrap bootstrap;

  const KalenderScreen({super.key, required this.bootstrap});

  @override
  State<KalenderScreen> createState() => _KalenderScreenState();
}

class _KalenderScreenState extends State<KalenderScreen> {
  late AppBootstrap _bootstrap;
  late int _selectedDay;
  late int _currentMonth;
  late int _currentYear;
  String _selectedTypeFilter = 'Semua Jenis';
  String _selectedDayFilter = 'Semua Hari';

  Map<int, List<_EventData>> get _events => _bootstrap.calendar.groupedEntries.map(
        (day, entries) => MapEntry(
          day,
          entries
              .map((entry) => _EventData(day, entry.id, entry.title, entry.color, entry.time, entry.type))
              .where(_matchesFilter)
              .toList(),
        ),
      );

  List<_EventData> get _allFilteredEvents {
    final events = <_EventData>[];
    for (final entry in _bootstrap.calendar.groupedEntries.entries) {
      for (final event in entry.value) {
        final data = _EventData(entry.key, event.id, event.title, event.color, event.time, event.type);
        if (_matchesFilter(data)) {
          events.add(data);
        }
      }
    }
    return events;
  }

  List<String> get _typeOptions {
    final values = <String>{'Semua Jenis'};
    for (final event in _allFilteredOrAllEntries()) {
      values.add(event.type);
    }
    return values.toList();
  }

  List<String> get _dayOptions {
    final values = <String>{'Semua Hari'};
    for (final event in _allFilteredOrAllEntries()) {
      values.add('${event.day}');
    }
    final list = values.toList();
    list.sort((a, b) {
      if (a == 'Semua Hari') return -1;
      if (b == 'Semua Hari') return 1;
      return int.parse(a).compareTo(int.parse(b));
    });
    return list;
  }

  List<_EventData> _allFilteredOrAllEntries() {
    final events = <_EventData>[];
    for (final entry in _bootstrap.calendar.groupedEntries.entries) {
      for (final event in entry.value) {
        events.add(_EventData(entry.key, event.id, event.title, event.color, event.time, event.type));
      }
    }
    return events;
  }

  bool _matchesFilter(_EventData event) {
    final typeMatches = _selectedTypeFilter == 'Semua Jenis' || event.type == _selectedTypeFilter;
    final dayMatches = _selectedDayFilter == 'Semua Hari' || '${event.day}' == _selectedDayFilter;
    return typeMatches && dayMatches;
  }

  String get _monthLabel => _monthName(_currentMonth, _currentYear);

  @override
  void initState() {
    super.initState();
    _bootstrap = widget.bootstrap;
    final calendar = _bootstrap.calendar;
    _selectedDay = calendar.selectedDay;
    _currentMonth = calendar.currentMonth;
    _currentYear = calendar.currentYear;
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
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kalender'),
                      Text('Jadwal target dan aktivitasmu',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w400)),
                    ],
                  ),
                  toolbarHeight: 64,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: PrimaryButton(
                        label: 'Tambah',
                        icon: Icons.add,
                        onTap: () => _showCalendarEventDialog(day: _selectedDay),
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
                          Text('Kalender', style: AppTextStyles.h1),
                          SizedBox(height: 4),
                          Text('Lihat jadwal target dan agenda produktivitas Anda Bulan ini.',
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                      const Spacer(),
                      PrimaryButton(
                        label: 'Tambah Kegiatan',
                        icon: Icons.add,
                        onTap: () => _showCalendarEventDialog(day: _selectedDay),
                      ),
                    ],
                  ),
                ),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column 1 (Left): Mini Calendar Nav, Filters, Legenda
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              children: [
                                _buildMonthNav(),
                                const SizedBox(height: 12),
                                _buildCalendarGrid(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildFilterGroupCard(),
                          const SizedBox(height: 16),
                          _buildLegenda(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Column 2 (Center): Desk Calendar Grid showing labels inside cells, Tips
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDesktopCalendarGrid(),
                          const SizedBox(height: 16),
                          _buildTips(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Column 3 (Right): Ringkasan Bulan Ini, Kegiatan Hari Ini, Deadline Terdekat
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMonthSummary(),
                          const SizedBox(height: 16),
                          _buildTodayEvents(),
                          const SizedBox(height: 16),
                          _buildDeadlines(),
                        ],
                      ),
                    ),
                  ],
                )
              else ...[
                // Mobile stacked layout fallback
                _buildMonthNav(),
                const SizedBox(height: 12),
                _buildCalendarGrid(),
                const SizedBox(height: 14),
                _buildTodayEvents(),
                const SizedBox(height: 14),
                _buildMonthSummary(),
                const SizedBox(height: 14),
                _buildDeadlines(),
                const SizedBox(height: 14),
                _buildLegenda(),
                const SizedBox(height: 14),
                _buildTips(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterGroupCard() {
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
              const Icon(Icons.filter_alt_outlined, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              const Expanded(child: Text('Filter Kegiatan', style: AppTextStyles.h3)),
              TextButton(
                onPressed: () => setState(() {
                  _selectedTypeFilter = 'Semua Jenis';
                  _selectedDayFilter = 'Semua Hari';
                }),
                child: const Text('Reset', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Hari', style: AppTextStyles.label),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedDayFilter,
            items: _dayOptions
                .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedDayFilter = value);
            },
          ),
          const SizedBox(height: 12),
          const Text('Jenis', style: AppTextStyles.label),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedTypeFilter,
            items: _typeOptions
                .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _selectedTypeFilter = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopCalendarGrid() {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    const startOffset = 3;
    const daysInMonth = 31;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: days.map((d) {
              return Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ..._buildDesktopRows(startOffset, daysInMonth),
        ],
      ),
    );
  }

  List<Widget> _buildDesktopRows(int startOffset, int daysInMonth) {
    final rows = <Widget>[];
    int dayCounter = 1;
    int firstWeekOffset = startOffset;
    int totalCells = startOffset + daysInMonth;
    int totalRows = (totalCells / 7).ceil();

    for (int row = 0; row < totalRows; row++) {
      final rowCells = <Widget>[];
      for (int col = 0; col < 7; col++) {
        int cellIndex = row * 7 + col;
        if (cellIndex < firstWeekOffset || dayCounter > daysInMonth) {
          rowCells.add(
            const Expanded(
              child: SizedBox(
                height: 80,
                child: Center(child: Text('')),
              ),
            ),
          );
        } else {
          final day = dayCounter;
          final isSelected = day == _selectedDay;
          final hasEvents = _events.containsKey(day);
          rowCells.add(
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: Container(
                  height: 80,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green.withOpacity(0.05) : Colors.transparent,
                    border: Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$day',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (hasEvents)
                        ..._events[day]!.take(2).map((e) => Container(
                              margin: const EdgeInsets.only(bottom: 2),
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: e.color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                e.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 8, color: e.color, fontWeight: FontWeight.bold),
                              ),
                            )),
                    ],
                  ),
                ),
              ),
            ),
          );
          dayCounter++;
        }
      }
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rowCells,
      ));
    }
    return rows;
  }


  Widget _buildMonthNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _monthLabel,
          style: AppTextStyles.h2,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () => _moveMonth(-1),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chevron_left_rounded,
                    color: AppColors.textSecondary, size: 18),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _moveMonth(1),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textSecondary, size: 18),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    // May 2025 starts on Thursday (day 3 in 0-indexed Mon=0)
    const startOffset = 3;
    const daysInMonth = 31;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Day headers
          Row(
            children: days.map((d) {
              return Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w700),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Calendar cells
          ..._buildRows(startOffset, daysInMonth),
        ],
      ),
    );
  }

  List<Widget> _buildRows(int startOffset, int daysInMonth) {
    final rows = <Widget>[];
    int dayCounter = 1;
    int firstWeekOffset = startOffset;

    // Calculate total cells
    int totalCells = startOffset + daysInMonth;
    int totalRows = (totalCells / 7).ceil();

    for (int row = 0; row < totalRows; row++) {
      final rowCells = <Widget>[];
      for (int col = 0; col < 7; col++) {
        int cellIndex = row * 7 + col;
        if (cellIndex < firstWeekOffset || dayCounter > daysInMonth) {
          // Previous/next month
          int prevDay = 28 + (cellIndex - firstWeekOffset);
          if (cellIndex < firstWeekOffset) prevDay = 30 - (firstWeekOffset - cellIndex - 1);
          int nextDay = dayCounter - daysInMonth;
          rowCells.add(
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Text(
                    cellIndex < firstWeekOffset
                        ? '${30 - (firstWeekOffset - cellIndex - 1)}'
                        : '${dayCounter++ - daysInMonth}',
                    style: AppTextStyles.caption.copyWith(),
                  ),
                ),
              ),
            ),
          );
          if (cellIndex >= firstWeekOffset) dayCounter++;
        } else {
          final day = dayCounter;
          final isSelected = day == _selectedDay;
          final hasEvents = _events.containsKey(day);
          rowCells.add(
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDay = day),
                child: Column(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    if (hasEvents) ...[
                      const SizedBox(height: 2),
                      ..._events[day]!.take(2).map((e) => Container(
                            margin: const EdgeInsets.only(bottom: 1),
                            height: 4,
                            width: 28,
                            decoration: BoxDecoration(
                              color: e.color,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          )),
                    ] else
                      const SizedBox(height: 6),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          );
          dayCounter++;
        }
      }
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rowCells,
      ));
    }
    return rows;
  }

  Widget _buildTodayEvents() {
    final events = _eventsForDay(_selectedDay);
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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('$_selectedDay',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              Text('$_selectedDay $_monthLabel',
                  style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 12),
          if (events.isEmpty)
            const Text('Tidak ada kegiatan pada hari ini', style: AppTextStyles.bodySmall)
          else
            ...events.asMap().entries.map((entry) {
              return Padding(
                padding: EdgeInsets.only(bottom: entry.key < events.length - 1 ? 8 : 0),
                child: _buildEventItem(
                  _EventData(
                    _selectedDay,
                    entry.value.id,
                    entry.value.title,
                    entry.value.color,
                    entry.value.time,
                    entry.value.type,
                  ),
                ),
              );
            }),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showAllEventsDialog,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary),
              ),
              child: const Center(
                child: Text('Lihat Semua Kegiatan',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(_EventData event) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 36,
          decoration: BoxDecoration(
            color: event.color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.title,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              Text(event.time, style: AppTextStyles.caption),
            ],
          ),
        ),
        PopupMenuButton<String>(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: const Icon(Icons.more_vert, size: 18, color: AppColors.textMuted),
          onSelected: (value) {
            if (value == 'edit') {
              _showCalendarEventDialog(day: _selectedDay, event: event);
            } else if (value == 'delete') {
              _deleteCalendarEvent(event);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Hapus')),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthSummary() {
    final summary = _bootstrap.calendar.summary;
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
          const Text('Ringkasan Bulan Ini', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          _summaryRow(AppColors.primary, Icons.track_changes_rounded, 'Total Target', '${summary.totalTargets}'),
          _summaryRow(AppColors.secondary, Icons.check_circle_outline_rounded, 'Selesai', '${summary.completedTargets}'),
          _summaryRow(AppColors.warning, Icons.timelapse_rounded, 'Sedang Berjalan', '${summary.inProgressTargets}'),
          _summaryRow(AppColors.danger, Icons.radio_button_unchecked_rounded, 'Belum Dimulai', '${summary.notStartedTargets}'),
        ],
      ),
    );
  }

  Widget _summaryRow(Color color, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: AppTextStyles.body)),
          Text(value,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildDeadlines() {
    final deadlines = _bootstrap.calendar.deadlines;
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
          const Text('Deadline Terdekat', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          ...deadlines.asMap().entries.expand((entry) {
            final isLast = entry.key == deadlines.length - 1;
            return [
              _deadlineRow(entry.value.color, entry.value.title, entry.value.date, entry.value.remaining),
              if (!isLast) const Divider(height: 16),
            ];
          }),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: _showDeadlinesDialog,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary),
              ),
              child: const Center(
                child: Text('Lihat Semua Deadline',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deadlineRow(Color color, String title, String date, String remaining) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              Text(date, style: AppTextStyles.caption),
            ],
          ),
        ),
        Text(remaining,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }

  Widget _buildLegenda() {
    final items = [
      _LegendaItem(AppColors.primary, 'Target'),
      _LegendaItem(AppColors.secondary, 'Kegiatan'),
      _LegendaItem(AppColors.danger, 'Deadline'),
      _LegendaItem(AppColors.purple, 'Kebiasaan'),
      _LegendaItem(AppColors.warning, 'Motivasi'),
    ];
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
          const Text('Legenda', style: AppTextStyles.h3),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 8,
            children: items.map((item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: item.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(item.label, style: AppTextStyles.bodySmall),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTips() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Text('📅', style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tips Produktif', style: AppTextStyles.h3),
                SizedBox(height: 3),
                Text(
                  'Rencanakan harimu, fokus pada prioritas, dan rayakan setiap pencapaianmu! 🎉',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCalendarEventDialog({
    required int day,
    _EventData? event,
  }) async {
    final titleController = TextEditingController(text: event?.title ?? '');
    final timeController = TextEditingController(text: event?.time ?? '08:00 - 09:00');
    final dayController = TextEditingController(text: '$day');
    final typeOptions = const ['Target', 'Aktivitas', 'Kebiasaan', 'Motivasi', 'Deadline'];
    String selectedType = event?.type ?? 'Target';

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(
            builder: (context, setLocalState) {
              return AlertDialog(
                title: Text(event == null ? 'Tambah Kegiatan' : 'Edit Kegiatan'),
                content: SizedBox(
                  width: 460,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: dayController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Hari'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Judul kegiatan'),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: timeController,
                          decoration: const InputDecoration(labelText: 'Waktu', hintText: '08:00 - 09:00'),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: selectedType,
                          decoration: const InputDecoration(labelText: 'Jenis'),
                          items: typeOptions
                              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                              .toList(),
                          onChanged: (value) {
                            if (value == null) return;
                            setLocalState(() => selectedType = value);
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

      final saved = await AppApi.instance.saveCalendarEvent({
        'userId': _bootstrap.user.id,
        'id': event?.id ?? 0,
        'day': int.tryParse(dayController.text.trim()) ?? day,
        'title': titleController.text.trim(),
        'time': timeController.text.trim(),
        'type': selectedType,
        'color': colorToHex(_colorForEventType(selectedType)),
      });

      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() {
        _bootstrap = refreshed;
        _selectedDay = saved.day;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(event == null ? 'Kegiatan berhasil ditambahkan' : 'Kegiatan berhasil diperbarui'),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      titleController.dispose();
      timeController.dispose();
      dayController.dispose();
    }
  }

  Future<void> _deleteCalendarEvent(_EventData event) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kegiatan'),
        content: Text('Hapus kegiatan "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await AppApi.instance.deleteCalendarEvent(
        userId: _bootstrap.user.id,
        id: event.id,
      );
      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() => _bootstrap = refreshed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kegiatan berhasil dihapus')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  List<_EventData> _eventsForDay(int day) {
    return _events[day] ?? const [];
  }

  void _moveMonth(int delta) {
    setState(() {
      _currentMonth += delta;
      if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear -= 1;
      } else if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear += 1;
      }
    });
  }

  String _monthName(int month, int year) {
    const names = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    final index = month.clamp(1, 12) - 1;
    return '${names[index]} $year';
  }

  Future<void> _showDayEventsDialog(int day) async {
    final events = _eventsForDay(day);
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Kegiatan Hari $day'),
          content: SizedBox(
            width: 520,
            child: events.isEmpty
                ? const Text('Tidak ada kegiatan pada hari ini')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const Divider(height: 12),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: event.color, shape: BoxShape.circle),
                        ),
                        title: Text(event.title),
                        subtitle: Text('${event.time} • ${event.type}'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            Navigator.pop(dialogContext);
                            if (value == 'edit') {
                              _showCalendarEventDialog(day: day, event: event);
                            } else if (value == 'delete') {
                              _deleteCalendarEvent(event);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'edit', child: Text('Edit')),
                            PopupMenuItem(value: 'delete', child: Text('Hapus')),
                          ],
                        ),
                      );
                    },
                  ),
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
  }

  Future<void> _showDeadlinesDialog() async {
    final deadlines = _bootstrap.calendar.deadlines;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Deadline Terdekat'),
          content: SizedBox(
            width: 520,
            child: deadlines.isEmpty
                ? const Text('Belum ada deadline')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: deadlines.length,
                    separatorBuilder: (_, __) => const Divider(height: 12),
                    itemBuilder: (context, index) {
                      final deadline = deadlines[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: deadline.color, shape: BoxShape.circle),
                        ),
                        title: Text(deadline.title),
                        subtitle: Text('${deadline.date} • ${deadline.remaining}'),
                      );
                    },
                  ),
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
  }

  Future<void> _showAllEventsDialog() async {
    final events = _allFilteredEvents;
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Semua Kegiatan'),
          content: SizedBox(
            width: 560,
            child: events.isEmpty
                ? const Text('Tidak ada kegiatan sesuai filter')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const Divider(height: 12),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: event.color, shape: BoxShape.circle),
                        ),
                        title: Text(event.title),
                        subtitle: Text('Hari ${event.day} • ${event.time} • ${event.type}'),
                      );
                    },
                  ),
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
  }

  Color _colorForEventType(String type) {
    switch (type) {
      case 'Motivasi':
        return AppColors.warning;
      case 'Kebiasaan':
        return AppColors.purple;
      case 'Deadline':
        return AppColors.danger;
      case 'Aktivitas':
        return AppColors.secondary;
      default:
        return AppColors.primary;
    }
  }
}

class _EventData {
  final int day;
  final int id;
  final String title;
  final Color color;
  final String time;
  final String type;

  const _EventData(this.day, this.id, this.title, this.color, this.time, this.type);
}

class _LegendaItem {
  final Color color;
  final String label;
  const _LegendaItem(this.color, this.label);
}
