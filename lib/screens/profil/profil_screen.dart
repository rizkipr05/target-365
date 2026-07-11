import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  String _activeMenu = 'Profil Saya';

  // Pengaturan Akun toggles
  bool _twoFactor = false;

  // Preferensi toggles
  bool _darkMode = false;
  bool _compactView = false;
  String _language = 'Bahasa Indonesia';
  String _dateFormat = 'DD/MM/YYYY';

  // Notifikasi toggles
  bool _notifPush = true;
  bool _notifEmail = false;
  bool _notifTargetReminder = true;
  bool _notifAchievement = true;
  bool _notifWeekly = false;
  bool _notifMotivasi = true;

  final List<Map<String, dynamic>> _menuItems = [
    {'name': 'Profil Saya', 'icon': Icons.person_outline_rounded},
    {'name': 'Pengaturan Akun', 'icon': Icons.settings_outlined},
    {'name': 'Keamanan', 'icon': Icons.shield_outlined},
    {'name': 'Preferensi', 'icon': Icons.tune_rounded},
    {'name': 'Notifikasi', 'icon': Icons.notifications_none_rounded},
    {'name': 'Aktivitas Saya', 'icon': Icons.history_rounded},
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
                  title: const Text('Profil Saya'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () {},
                    ),
                  ],
                ),
          body: ListView(
            padding: EdgeInsets.fromLTRB(isDesktop ? 24 : 16, 12, isDesktop ? 24 : 16, 80),
            children: [
              if (isDesktop)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profil Saya', style: AppTextStyles.h1),
                      SizedBox(height: 4),
                      Text('Kelola informasi profil dan pengaturan akun Anda.',
                          style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
              if (isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sidebar Menu
                    _buildSidebar(context),
                    const SizedBox(width: 24),
                    // Main content area
                    Expanded(
                      flex: 4,
                      child: _buildActiveContent(isDesktop),
                    ),
                  ],
                )
              else ...[
                _buildActiveContent(isDesktop),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return Container(
      width: 240,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ..._menuItems.map((item) {
            final isSelected = _activeMenu == item['name'];
            return InkWell(
              onTap: () {
                setState(() {
                  _activeMenu = item['name'] as String;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryLight.withOpacity(0.5) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      item['icon'] as IconData,
                      size: 20,
                      color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item['name'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          const Divider(height: 24, color: AppColors.border),
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: const Row(
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: 20,
                    color: AppColors.danger,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Keluar',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.danger,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveContent(bool isDesktop) {
    switch (_activeMenu) {
      case 'Pengaturan Akun':
        return _buildPengaturanAkun(isDesktop);
      case 'Keamanan':
        return _buildKeamanan(isDesktop);
      case 'Preferensi':
        return _buildPreferensi(isDesktop);
      case 'Notifikasi':
        return _buildNotifikasi(isDesktop);
      case 'Aktivitas Saya':
        return _buildAktivitasSaya(isDesktop);
      default:
        return _buildProfilSaya(isDesktop);
    }
  }

  Widget _buildProfilSaya(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileHeroCard(isDesktop),
        const SizedBox(height: 20),
        if (isDesktop)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 5, child: _buildPersonalInformation()),
              const SizedBox(width: 20),
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buildAboutMeCard(),
                    const SizedBox(height: 20),
                    _buildRecentAchievements(),
                  ],
                ),
              ),
            ],
          )
        else ...[
          _buildPersonalInformation(),
          const SizedBox(height: 16),
          _buildAboutMeCard(),
          const SizedBox(height: 16),
          _buildRecentAchievements(),
        ],
        const SizedBox(height: 24),
        _buildRecentActivities(isDesktop),
      ],
    );
  }

  Widget _buildPengaturanAkun(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          title: 'Informasi Akun',
          subtitle: 'Perbarui informasi dasar akun Anda',
          icon: Icons.manage_accounts_outlined,
          children: [
            _buildEditableField('Nama Lengkap', 'Andi Pratama', Icons.person_outline_rounded),
            const Divider(color: AppColors.border, height: 1),
            _buildEditableField('Username', 'andipratama', Icons.alternate_email_rounded),
            const Divider(color: AppColors.border, height: 1),
            _buildEditableField('Email', 'andi.pratama@email.com', Icons.mail_outline_rounded),
            const Divider(color: AppColors.border, height: 1),
            _buildEditableField('No. Telepon', '+62 812-3456-7890', Icons.phone_outlined),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Foto Profil',
          subtitle: 'Kelola foto profil Anda',
          icon: Icons.photo_camera_outlined,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryButton(label: 'Ganti Foto', icon: Icons.upload_rounded, onTap: () {}),
                      const SizedBox(height: 8),
                      const Text('Format: JPG, PNG. Maks 2MB', style: AppTextStyles.caption),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Tentang Saya',
          subtitle: 'Tulis sedikit tentang diri Anda',
          icon: Icons.info_outline_rounded,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Text(
                      'Saya adalah seseorang yang sedang belajar menjadi versi terbaik dari diri sendiri setiap hari.',
                      style: TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(label: 'Simpan Perubahan', icon: Icons.save_outlined, onTap: () {}),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDangerZone(),
      ],
    );
  }

  Widget _buildKeamanan(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          title: 'Ubah Password',
          subtitle: 'Pastikan password Anda kuat dan aman',
          icon: Icons.lock_outline_rounded,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildPasswordField('Password Saat Ini'),
                  const SizedBox(height: 12),
                  _buildPasswordField('Password Baru'),
                  const SizedBox(height: 12),
                  _buildPasswordField('Konfirmasi Password Baru'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      const Text('Minimal 8 karakter', style: AppTextStyles.caption),
                      const SizedBox(width: 16),
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      const Text('Mengandung huruf & angka', style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(label: 'Perbarui Password', icon: Icons.lock_reset_rounded, onTap: () {}),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Autentikasi Dua Faktor',
          subtitle: 'Tambahkan lapisan keamanan ekstra pada akun Anda',
          icon: Icons.verified_user_outlined,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _twoFactor ? AppColors.primaryLight : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.security_rounded,
                        color: _twoFactor ? AppColors.primary : AppColors.textSecondary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Aktifkan 2FA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Text(_twoFactor ? 'Aktif — akun Anda lebih aman' : 'Nonaktif — aktifkan untuk keamanan lebih',
                            style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  Switch(
                    value: _twoFactor,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _twoFactor = v),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Sesi Aktif',
          subtitle: 'Perangkat yang sedang mengakses akun Anda',
          icon: Icons.devices_rounded,
          children: [
            _buildSessionTile(Icons.smartphone_rounded, 'Android — Samsung Galaxy S23', 'Jakarta, Indonesia', true),
            const Divider(color: AppColors.border, height: 1),
            _buildSessionTile(Icons.computer_rounded, 'Chrome — Windows 11', 'Jakarta, Indonesia', false),
            const Divider(color: AppColors.border, height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout_rounded, color: AppColors.danger, size: 16),
                label: const Text('Keluar dari Semua Sesi Lain', style: TextStyle(color: AppColors.danger, fontSize: 13)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPreferensi(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          title: 'Tampilan',
          subtitle: 'Atur tampilan aplikasi sesuai preferensi Anda',
          icon: Icons.palette_outlined,
          children: [
            _buildToggleTile('Mode Gelap', 'Tampilkan antarmuka dengan tema gelap', Icons.dark_mode_outlined, _darkMode, (v) => setState(() => _darkMode = v)),
            const Divider(color: AppColors.border, height: 1),
            _buildToggleTile('Tampilan Kompak', 'Perkecil jarak antar elemen', Icons.compress_rounded, _compactView, (v) => setState(() => _compactView = v)),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Bahasa & Wilayah',
          subtitle: 'Atur bahasa dan format tanggal',
          icon: Icons.language_rounded,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildDropdownRow('Bahasa', _language, ['Bahasa Indonesia', 'English'], (v) => setState(() => _language = v!)),
                  const SizedBox(height: 12),
                  _buildDropdownRow('Format Tanggal', _dateFormat, ['DD/MM/YYYY', 'MM/DD/YYYY', 'YYYY-MM-DD'], (v) => setState(() => _dateFormat = v!)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Target & Pengingat',
          subtitle: 'Atur pengingat untuk target harian Anda',
          icon: Icons.alarm_rounded,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Waktu Pengingat Default', style: AppTextStyles.bodySmall),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.surface,
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSecondary),
                        SizedBox(width: 8),
                        Text('07:00', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                        Spacer(),
                        Text('Ubah', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotifikasi(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          title: 'Saluran Notifikasi',
          subtitle: 'Pilih cara Anda menerima notifikasi',
          icon: Icons.notifications_active_outlined,
          children: [
            _buildToggleTile('Notifikasi Push', 'Terima notifikasi langsung di perangkat', Icons.smartphone_rounded, _notifPush, (v) => setState(() => _notifPush = v)),
            const Divider(color: AppColors.border, height: 1),
            _buildToggleTile('Notifikasi Email', 'Terima ringkasan mingguan via email', Icons.email_outlined, _notifEmail, (v) => setState(() => _notifEmail = v)),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Jenis Notifikasi',
          subtitle: 'Pilih notifikasi apa yang ingin Anda terima',
          icon: Icons.filter_list_rounded,
          children: [
            _buildToggleTile('Pengingat Target', 'Ingatkan saya untuk mencatat kemajuan target', Icons.track_changes_rounded, _notifTargetReminder, (v) => setState(() => _notifTargetReminder = v)),
            const Divider(color: AppColors.border, height: 1),
            _buildToggleTile('Pencapaian & Badge', 'Notifikasi saat mendapatkan pencapaian baru', Icons.emoji_events_outlined, _notifAchievement, (v) => setState(() => _notifAchievement = v)),
            const Divider(color: AppColors.border, height: 1),
            _buildToggleTile('Laporan Mingguan', 'Ringkasan perkembangan target setiap minggu', Icons.bar_chart_rounded, _notifWeekly, (v) => setState(() => _notifWeekly = v)),
            const Divider(color: AppColors.border, height: 1),
            _buildToggleTile('Motivasi Harian', 'Kutipan motivasi di pagi hari', Icons.wb_sunny_outlined, _notifMotivasi, (v) => setState(() => _notifMotivasi = v)),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(
          title: 'Do Not Disturb',
          subtitle: 'Atur jam tenang agar tidak ada notifikasi',
          icon: Icons.do_not_disturb_alt_outlined,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Mulai', style: AppTextStyles.bodySmall),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8), color: AppColors.surface),
                          child: const Text('22:00', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Padding(padding: EdgeInsets.only(top: 20), child: Text('—', style: AppTextStyles.bodySmall)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Selesai', style: AppTextStyles.bodySmall),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8), color: AppColors.surface),
                          child: const Text('06:00', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAktivitasSaya(bool isDesktop) {
    final activities = [
      {'icon': Icons.check_rounded, 'color': AppColors.primary, 'bg': const Color(0xFFDCFCE7), 'title': 'Menyelesaikan target', 'desc': '"Olahraga 4x Seminggu"', 'time': 'Hari ini, 07:30'},
      {'icon': Icons.edit_rounded, 'color': AppColors.secondary, 'bg': const Color(0xFFEFF6FF), 'title': 'Mengupdate progress', 'desc': '"Belajar UI/UX Design" — 65%', 'time': 'Kemarin, 21:15'},
      {'icon': Icons.add_rounded, 'color': AppColors.warning, 'bg': const Color(0xFFFFFBEB), 'title': 'Menambahkan target baru', 'desc': '"Meditasi 10 Menit Setiap Hari"', 'time': '15 Mei 2025, 06:45'},
      {'icon': Icons.emoji_emotions_outlined, 'color': AppColors.purple, 'bg': const Color(0xFFF5F3FF), 'title': 'Membaca motivasi harian', 'desc': '"Disiplin adalah kunci sukses"', 'time': '15 Mei 2025, 06:30'},
      {'icon': Icons.emoji_events_outlined, 'color': AppColors.warning, 'bg': const Color(0xFFFEF3C7), 'title': 'Mencapai pencapaian baru', 'desc': 'Badge "Rajin Berdisiplin — 7 Hari Berturut"', 'time': '14 Mei 2025, 20:00'},
      {'icon': Icons.check_rounded, 'color': AppColors.primary, 'bg': const Color(0xFFDCFCE7), 'title': 'Menyelesaikan target', 'desc': '"Menabung Rp10.000.000"', 'time': '13 Mei 2025, 18:30'},
      {'icon': Icons.edit_rounded, 'color': AppColors.secondary, 'bg': const Color(0xFFEFF6FF), 'title': 'Mengupdate profil saya', 'desc': 'Mengubah bio dan foto profil', 'time': '12 Mei 2025, 10:00'},
      {'icon': Icons.add_rounded, 'color': AppColors.warning, 'bg': const Color(0xFFFFFBEB), 'title': 'Menambahkan target baru', 'desc': '"Membaca 12 Buku dalam Setahun"', 'time': '10 Mei 2025, 08:15'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Semua Aktivitas', style: AppTextStyles.h3),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
              child: const Text('${8} aktivitas', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Column(
            children: activities.asMap().entries.map((entry) {
              final i = entry.key;
              final act = entry.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36, height: 36,
                          decoration: BoxDecoration(color: act['bg'] as Color, borderRadius: BorderRadius.circular(8)),
                          child: Icon(act['icon'] as IconData, size: 18, color: act['color'] as Color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(act['title'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text(act['desc'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                        Text(act['time'] as String, style: AppTextStyles.caption),
                      ],
                    ),
                  ),
                  if (i < activities.length - 1)
                    const Divider(height: 1, color: AppColors.border),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ─── Helper Widgets ───────────────────────────────────────────────────────

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: AppColors.primaryDark, size: 18),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                    Text(subtitle, style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ...children,
        ],
      ),
    );
  }

  Widget _buildEditableField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          SizedBox(width: 120, child: Text(label, style: AppTextStyles.bodySmall)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary))),
          const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodySmall,
        prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _buildToggleTile(String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: value ? AppColors.primaryLight : AppColors.surface, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: value ? AppColors.primaryDark : AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
          Switch(value: value, activeColor: AppColors.primary, onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildDropdownRow(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label, style: AppTextStyles.bodySmall)),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            items: options.map((o) => DropdownMenuItem(value: o, child: Text(o, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primary)),
              filled: true, fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionTile(IconData icon, String device, String location, bool isCurrent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: isCurrent ? AppColors.primaryLight : AppColors.surface, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: isCurrent ? AppColors.primaryDark : AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                Text(location, style: AppTextStyles.caption),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
              child: const Text('Perangkat Ini', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.primaryDark)),
            )
          else
            TextButton(onPressed: () {}, child: const Text('Keluar', style: TextStyle(fontSize: 12, color: AppColors.danger))),
        ],
      ),
    );
  }

  Widget _buildDangerZone() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 18),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Zona Berbahaya', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.danger)),
                    Text('Tindakan berikut tidak dapat dibatalkan', style: AppTextStyles.caption),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hapus Akun', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      Text('Semua data Anda akan dihapus permanen', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.danger),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Hapus Akun', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.danger)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeroCard(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: isDesktop ? 90 : 70,
                    height: isDesktop ? 90 : 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              // Name and join date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Andi Pratama',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Pengguna',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        const Text('andi.pratama@email.com', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        const Text('Bergabung sejak 12 Januari 2024', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '“Disiplin hari ini, adalah keberhasilan esok hari.”',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDesktop) ...[
                const SizedBox(width: 20),
                PrimaryButton(
                  label: 'Edit Profil',
                  icon: Icons.edit,
                  outlined: true,
                  onTap: () {},
                ),
              ],
            ],
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 20),
          // Stats Row
          LayoutBuilder(
            builder: (context, c) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMiniStatItem(
                    color: AppColors.primary,
                    icon: Icons.track_changes_rounded,
                    value: '12',
                    label: 'Total Target',
                    subtitle: 'Semua target aktif',
                  ),
                  _buildMiniStatItem(
                    color: AppColors.secondary,
                    icon: Icons.check_circle_outline_rounded,
                    value: '5',
                    label: 'Target Selesai',
                    subtitle: '41.67% dari total',
                  ),
                  _buildMiniStatItem(
                    color: AppColors.warning,
                    icon: Icons.timelapse_rounded,
                    value: '6',
                    label: 'Sedang Berjalan',
                    subtitle: '50.00% dari total',
                  ),
                  _buildMiniStatItem(
                    color: AppColors.danger,
                    icon: Icons.radio_button_unchecked_rounded,
                    value: '1',
                    label: 'Belum Dimulai',
                    subtitle: '8.33% dari total',
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatItem({
    required Color color,
    required IconData icon,
    required String value,
    required String label,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.12)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary), textAlign: TextAlign.center),
            Text(subtitle, style: AppTextStyles.caption, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInformation() {
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
          const Text('Informasi Pribadi', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.person_outline_rounded, 'Nama Lengkap', 'Andi Pratama'),
          _buildInfoRow(Icons.alternate_email_rounded, 'Username', 'andipratama'),
          _buildInfoRow(Icons.mail_outline_rounded, 'Email', 'andi.pratama@email.com'),
          _buildInfoRow(Icons.cake_outlined, 'Tanggal Lahir', '15 Mei 1998'),
          _buildInfoRow(Icons.wc_rounded, 'Jenis Kelamin', 'Laki-laki'),
          _buildInfoRow(Icons.phone_outlined, 'No. Telepon', '+62 812-3456-7890'),
          _buildInfoRow(Icons.location_on_outlined, 'Lokasi', 'Jakarta, Indonesia'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w400)),
          ),
          Expanded(
            flex: 5,
            child: Text(value, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMeCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tentang Saya', style: AppTextStyles.h3),
              GestureDetector(
                onTap: () {},
                child: const Text('Edit Tentang Saya', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Saya adalah seseorang yang sedang belajar menjadi versi terbaik dari diri sendiri setiap hari.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAchievements() {
    final achievements = [
      {
        'title': 'Mencapai 90% target "Membaca 12 Buku dalam Setahun"',
        'subtitle': 'Terus pertahankan konsistensimu!',
        'date': '20 Mei 2025',
        'icon': Icons.check_circle_outline_rounded,
        'color': AppColors.primary,
        'bg': const Color(0xFFDCFCE7),
      },
      {
        'title': 'Berhasil menyelesaikan target "Menabung Rp10.000.000"',
        'subtitle': 'Pencapaian luar biasa!',
        'date': '18 Mei 2025',
        'icon': Icons.emoji_events_outlined,
        'color': AppColors.warning,
        'bg': const Color(0xFFFEF3C7),
      },
      {
        'title': 'Streak 7 hari berturut-turut',
        'subtitle': 'Konsistensi adalah kunci keberhasilan!',
        'date': '17 Mei 2025',
        'icon': Icons.bolt_rounded,
        'color': AppColors.purple,
        'bg': const Color(0xFFF3E8FF),
      },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pencapaian Terbaru', style: AppTextStyles.h3),
              const Text('Lihat Semua', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          ...achievements.map((a) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: a['bg'] as Color,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(a['icon'] as IconData, size: 16, color: a['color'] as Color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a['title'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(a['subtitle'] as String, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(a['date'] as String, style: AppTextStyles.caption),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(bool isDesktop) {
    final activities = [
      {
        'title': 'Menyelesaikan target',
        'target': '"Olahraga 4x Seminggu"',
        'time': 'Hari ini, 07:30',
        'color': AppColors.primary,
        'bg': const Color(0xFFDCFCE7),
        'icon': Icons.check_rounded,
      },
      {
        'title': 'Mengupdate target',
        'target': '"Belajar UI/UX Design"',
        'time': 'Kemarin, 21:15',
        'color': AppColors.secondary,
        'bg': const Color(0xFFEFF6FF),
        'icon': Icons.edit_rounded,
      },
      {
        'title': 'Menambahkan target baru',
        'target': '"Meditasi 10 Menit"',
        'time': '15 Mei 2025, 06:45',
        'color': AppColors.warning,
        'bg': const Color(0xFFFFFBEB),
        'icon': Icons.add_rounded,
      },
      {
        'title': 'Membaca motivasi harian',
        'target': '',
        'time': '15 Mei 2025, 06:30',
        'color': AppColors.purple,
        'bg': const Color(0xFFF5F3FF),
        'icon': Icons.emoji_emotions_outlined,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Aktivitas Terakhir', style: AppTextStyles.h3),
            const Text('Lihat Semua', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final act = activities[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: act['bg'] as Color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(act['icon'] as IconData, size: 14, color: act['color'] as Color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${act['title']} ${act['target']}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(act['time'] as String, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
