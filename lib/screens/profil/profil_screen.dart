import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../services/app_api.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../state/app_session.dart';
import '../auth/login_screen.dart';

class ProfilScreen extends StatefulWidget {
  final AppBootstrap bootstrap;

  const ProfilScreen({super.key, required this.bootstrap});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late AppBootstrap _bootstrap;
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
  void initState() {
    super.initState();
    _bootstrap = widget.bootstrap;
    final profile = _bootstrap.profile;
    _twoFactor = profile.twoFactor;
    _darkMode = profile.darkMode;
    _compactView = profile.compactView;
    _language = profile.language;
    _dateFormat = profile.dateFormat;
    _notifPush = profile.notifPush;
    _notifEmail = profile.notifEmail;
    _notifTargetReminder = profile.notifTargetReminder;
    _notifAchievement = profile.notifAchievement;
    _notifWeekly = profile.notifWeekly;
    _notifMotivasi = profile.notifMotivasi;
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
                  title: const Text('Profil Saya'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: _showEditProfileDialog,
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
            onTap: () {
              AppSession.instance.clear();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
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
    final profile = _bootstrap.profile;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          title: 'Informasi Akun',
          subtitle: 'Perbarui informasi dasar akun Anda',
          icon: Icons.manage_accounts_outlined,
          children: [
            _buildEditableField('Nama Lengkap', profile.name, Icons.person_outline_rounded),
            const Divider(color: AppColors.border, height: 1),
            _buildEditableField('Username', profile.username, Icons.alternate_email_rounded),
            const Divider(color: AppColors.border, height: 1),
            _buildEditableField('Email', profile.email, Icons.mail_outline_rounded),
            const Divider(color: AppColors.border, height: 1),
            _buildEditableField('No. Telepon', profile.phone, Icons.phone_outlined),
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
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      _bootstrap.profile.avatarUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryButton(
                        label: 'Ganti Foto',
                        icon: Icons.upload_rounded,
                        onTap: _showAvatarUpdateDialog,
                      ),
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
                    child: Text(
                      _bootstrap.profile.about,
                      style: TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PrimaryButton(
                      label: 'Simpan Perubahan',
                      icon: Icons.save_outlined,
                      onTap: _showEditProfileDialog,
                    ),
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
    final profile = _bootstrap.profile;
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
                    child: PrimaryButton(
                      label: 'Perbarui Password',
                      icon: Icons.lock_reset_rounded,
                      onTap: _showChangePasswordDialog,
                    ),
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
            ...profile.sessions.map((session) => Column(
                  children: [
                    _buildSessionTile(session.icon, session.title, session.location, session.currentDevice),
                    if (session != profile.sessions.last) const Divider(color: AppColors.border, height: 1),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Keluar dari sesi lain belum tersedia'),
                    ),
                  );
                },
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
                          child: Text(_bootstrap.profile.dndStart, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
                          child: Text(_bootstrap.profile.dndEnd, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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
    final activities = _bootstrap.profile.activities;

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
              child: Text('${activities.length} aktivitas', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
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
                          decoration: BoxDecoration(color: act.backgroundColor, borderRadius: BorderRadius.circular(8)),
                          child: Icon(act.icon, size: 18, color: act.color),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(act.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                              const SizedBox(height: 2),
                              Text(act.description, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic)),
                            ],
                          ),
                        ),
                        Text(act.time, style: AppTextStyles.caption),
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

  Future<void> _showEditProfileDialog() async {
    final profile = _bootstrap.profile;
    final nameController = TextEditingController(text: profile.name);
    final usernameController = TextEditingController(text: profile.username);
    final emailController = TextEditingController(text: profile.email);
    final phoneController = TextEditingController(text: profile.phone);
    final taglineController = TextEditingController(text: profile.tagline);
    final aboutController = TextEditingController(text: profile.about);
    final locationController = TextEditingController(text: profile.location);

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Profil'),
            content: SizedBox(
              width: 460,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'No. Telepon'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'Lokasi'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: taglineController,
                      decoration: const InputDecoration(labelText: 'Tagline'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: aboutController,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'Tentang Saya'),
                    ),
                  ],
                ),
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
      await _saveProfileUpdate(
        name: nameController.text.trim(),
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        location: locationController.text.trim(),
        tagline: taglineController.text.trim(),
        about: aboutController.text.trim(),
      );
    } finally {
      nameController.dispose();
      usernameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      taglineController.dispose();
      aboutController.dispose();
      locationController.dispose();
    }
  }

  Future<void> _showAvatarUpdateDialog() async {
    final sourceController = TextEditingController(text: _bootstrap.profile.avatarUrl);

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Ganti Foto Profil'),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: sourceController,
                    decoration: const InputDecoration(
                      labelText: 'URL gambar atau path file lokal',
                      hintText: 'https://... atau /path/to/image.jpg',
                    ),
                  ),
                ],
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

      if (result != true) return;

      final source = sourceController.text.trim();
      if (source.isEmpty) {
        throw const ApiException('Sumber foto profil wajib diisi');
      }

      final updated = source.startsWith('http://') || source.startsWith('https://')
          ? await AppApi.instance.updateAvatarUrl(
              userId: _bootstrap.user.id,
              avatarUrl: source,
            )
          : await AppApi.instance.uploadProfileAvatar(
              userId: _bootstrap.user.id,
              filePath: source,
            );

      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() {
        _bootstrap = refreshed;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Foto profil berhasil diperbarui')),
      );
      AppSession.instance.cacheBootstrap(
        AppBootstrap(
          user: refreshed.user,
          summary: refreshed.summary,
          dashboard: refreshed.dashboard,
          targets: refreshed.targets,
          categories: refreshed.categories,
          quotes: refreshed.quotes,
          report: refreshed.report,
          calendar: refreshed.calendar,
          profile: updated,
          notificationsCount: refreshed.notificationsCount,
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      sourceController.dispose();
    }
  }

  Future<void> _showChangePasswordDialog() async {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    try {
      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Ubah Password'),
            content: SizedBox(
              width: 420,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: currentController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password Saat Ini'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: newController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password Baru'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: confirmController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Konfirmasi Password Baru'),
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

      if (result != true) return;

      await AppApi.instance.updatePassword(
        userId: _bootstrap.user.id,
        currentPassword: currentController.text.trim(),
        newPassword: newController.text.trim(),
        confirmPassword: confirmController.text.trim(),
      );
      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() => _bootstrap = refreshed);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password berhasil diperbarui')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      currentController.dispose();
      newController.dispose();
      confirmController.dispose();
    }
  }

  Future<void> _saveProfileUpdate({
    required String name,
    required String username,
    required String email,
    required String phone,
    required String location,
    required String tagline,
    required String about,
  }) async {
    try {
      final updated = await AppApi.instance.updateProfile({
        'userId': _bootstrap.user.id,
        'name': name,
        'username': username,
        'email': email,
        'phone': phone,
        'location': location,
        'tagline': tagline,
        'about': about,
        'language': _language,
        'dateFormat': _dateFormat,
        'darkMode': _darkMode,
        'compactView': _compactView,
        'twoFactor': _twoFactor,
        'notifPush': _notifPush,
        'notifEmail': _notifEmail,
        'notifTargetReminder': _notifTargetReminder,
        'notifAchievement': _notifAchievement,
        'notifWeekly': _notifWeekly,
        'notifMotivasi': _notifMotivasi,
      });
      final refreshed = await AppApi.instance.refreshBootstrap();
      if (!mounted) return;
      setState(() {
        _bootstrap = refreshed;
        _twoFactor = updated.twoFactor;
        _darkMode = updated.darkMode;
        _compactView = updated.compactView;
        _language = updated.language;
        _dateFormat = updated.dateFormat;
        _notifPush = updated.notifPush;
        _notifEmail = updated.notifEmail;
        _notifTargetReminder = updated.notifTargetReminder;
        _notifAchievement = updated.notifAchievement;
        _notifWeekly = updated.notifWeekly;
        _notifMotivasi = updated.notifMotivasi;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil disimpan')),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
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
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Keluar dari sesi ini belum tersedia'),
                  ),
                );
              },
              child: const Text('Keluar', style: TextStyle(fontSize: 12, color: AppColors.danger)),
            ),
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
                  onTap: _showEditProfileDialog,
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
    final profile = _bootstrap.profile;
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(profile.avatarUrl),
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
                        Text(
                          profile.name,
                          style: const TextStyle(
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
                          child: Text(
                            profile.role,
                            style: const TextStyle(
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
                        Text(profile.email, style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 6),
                        Text('Bergabung sejak ${profile.joinDate}', style: AppTextStyles.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '“${profile.tagline}”',
                      style: const TextStyle(
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
                  onTap: _showEditProfileDialog,
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
              final summary = profile.summary;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildMiniStatItem(
                    color: AppColors.primary,
                    icon: Icons.track_changes_rounded,
                    value: '${summary.totalTargets}',
                    label: 'Total Target',
                    subtitle: 'Semua target aktif',
                  ),
                  _buildMiniStatItem(
                    color: AppColors.secondary,
                    icon: Icons.check_circle_outline_rounded,
                    value: '${summary.completedTargets}',
                    label: 'Target Selesai',
                    subtitle: '${summary.completedPercentLabel} dari total',
                  ),
                  _buildMiniStatItem(
                    color: AppColors.warning,
                    icon: Icons.timelapse_rounded,
                    value: '${summary.inProgressTargets}',
                    label: 'Sedang Berjalan',
                    subtitle: '${summary.inProgressPercentLabel} dari total',
                  ),
                  _buildMiniStatItem(
                    color: AppColors.danger,
                    icon: Icons.radio_button_unchecked_rounded,
                    value: '${summary.notStartedTargets}',
                    label: 'Belum Dimulai',
                    subtitle: '${summary.notStartedPercentLabel} dari total',
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
    final profile = _bootstrap.profile;
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
          _buildInfoRow(Icons.person_outline_rounded, 'Nama Lengkap', profile.name),
          _buildInfoRow(Icons.alternate_email_rounded, 'Username', profile.username),
          _buildInfoRow(Icons.mail_outline_rounded, 'Email', profile.email),
          _buildInfoRow(Icons.cake_outlined, 'Tanggal Lahir', profile.birthday),
          _buildInfoRow(Icons.wc_rounded, 'Jenis Kelamin', profile.gender),
          _buildInfoRow(Icons.phone_outlined, 'No. Telepon', profile.phone),
          _buildInfoRow(Icons.location_on_outlined, 'Lokasi', profile.location),
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
    final profile = _bootstrap.profile;
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
                onTap: _showEditProfileDialog,
                child: const Text('Edit Tentang Saya', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            profile.about,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAchievements() {
    final achievements = _bootstrap.profile.achievements;

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
                        color: a.backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(a.icon, size: 16, color: a.color),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(a.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          const SizedBox(height: 2),
                          Text(a.subtitle, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(a.date, style: AppTextStyles.caption),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(bool isDesktop) {
    final activities = _bootstrap.profile.activities;

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
                        color: act.backgroundColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(act.icon, size: 14, color: act.color),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            act.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(act.time, style: AppTextStyles.caption),
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
