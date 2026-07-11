import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class KalenderScreen extends StatefulWidget {
  const KalenderScreen({super.key});

  @override
  State<KalenderScreen> createState() => _KalenderScreenState();
}

class _KalenderScreenState extends State<KalenderScreen> {
  int _selectedDay = 21;
  int _currentMonth = 5; // May (1-indexed)
  int _currentYear = 2025;

  final Map<int, List<_EventData>> _events = {
    1: [_EventData('Olahraga 4x Seminggu', AppColors.primary)],
    4: [_EventData('Motivasi Pagi', AppColors.warning)],
    6: [_EventData('Belajar UI/UX Design', AppColors.secondary)],
    9: [_EventData('Minum 2L Air', AppColors.pink)],
    9: [_EventData('Membaca 12 Buku...', AppColors.primary)],
    13: [_EventData('Menabung Rp10.000.000', AppColors.warning)],
    14: [_EventData('Kerja Project Klien', AppColors.primary)],
    16: [_EventData('Meditasi 10 Menit', AppColors.purple)],
    18: [_EventData('Jangan lupa bersyukur', AppColors.warning)],
    20: [_EventData('Review Materi Design', AppColors.secondary)],
    21: [
      _EventData('Olahraga 4x Seminggu', AppColors.primary),
      _EventData('Journal Malam', AppColors.purple),
    ],
    23: [_EventData('Deadline Project UI', AppColors.danger)],
    26: [_EventData('Update Portofolio', AppColors.secondary)],
    28: [_EventData('Belajar Frontend Lanjutan', AppColors.primary)],
    30: [_EventData('Evaluasi Bulanan', AppColors.primary)],
  };

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
                        onTap: () {},
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
                onPressed: () {},
                child: const Text('Reset', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text('Kategori', style: AppTextStyles.label),
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
                Expanded(child: Text('Semua Kategori', style: TextStyle(fontSize: 11, color: AppColors.textSecondary))),
                Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textMuted),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text('Jenis', style: AppTextStyles.label),
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
                Expanded(child: Text('Semua Jenis', style: TextStyle(fontSize: 11, color: AppColors.textSecondary))),
                Icon(Icons.keyboard_arrow_down, size: 14, color: AppColors.textMuted),
              ],
            ),
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
          'Mei 2025',
          style: AppTextStyles.h2,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {},
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
              onTap: () {},
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
                child: const Center(
                  child: Text('21',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 10),
              const Text('Rabu, 21 Mei 2025', style: AppTextStyles.h3),
            ],
          ),
          const SizedBox(height: 12),
          _buildEventItem(AppColors.primary, 'Olahraga 4x Seminggu', '06:00 - 07:00'),
          const SizedBox(height: 8),
          _buildEventItem(AppColors.purple, 'Journal Malam', '21:00 - 21:30'),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
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

  Widget _buildEventItem(Color color, String title, String time) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              Text(time, style: AppTextStyles.caption),
            ],
          ),
        ),
        Icon(Icons.circle, size: 8, color: color),
      ],
    );
  }

  Widget _buildMonthSummary() {
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
          _summaryRow(AppColors.primary, Icons.track_changes_rounded, 'Total Target', '12'),
          _summaryRow(AppColors.secondary, Icons.check_circle_outline_rounded, 'Selesai', '5'),
          _summaryRow(AppColors.warning, Icons.timelapse_rounded, 'Sedang Berjalan', '6'),
          _summaryRow(AppColors.danger, Icons.radio_button_unchecked_rounded, 'Belum Dimulai', '1'),
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
          _deadlineRow(AppColors.danger, 'Deadline Project UI', '23 Mei 2025', '2 hari lagi'),
          const Divider(height: 16),
          _deadlineRow(AppColors.warning, 'Laporan Bulanan', '30 Mei 2025', '9 hari lagi'),
          const Divider(height: 16),
          _deadlineRow(AppColors.purple, 'Evaluasi Q2', '15 Jun 2025', '25 hari lagi'),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
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
}

class _EventData {
  final String title;
  final Color color;
  const _EventData(this.title, this.color);
}

class _LegendaItem {
  final Color color;
  final String label;
  const _LegendaItem(this.color, this.label);
}
