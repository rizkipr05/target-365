USE target365;

INSERT INTO users (
  id, name, username, email, password, role, avatar_url, tagline, about, birthday, gender, phone, location,
  language, date_format, dark_mode, compact_view, two_factor,
  notif_push, notif_email, notif_target_reminder, notif_achievement, notif_weekly, notif_motivasi,
  reminder_time, dnd_start, dnd_end, calendar_month_label, calendar_month, calendar_year, calendar_selected_day, notifications_count
) VALUES (
  1,
  'Andi Pratama',
  'andipratama',
  'andi.pratama@email.com',
  'ChangeMeAfterFirstLogin123!',
  'Pengguna',
  'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
  'Disiplin hari ini, adalah keberhasilan esok hari.',
  'Saya adalah seseorang yang sedang belajar menjadi versi terbaik dari diri sendiri setiap hari.',
  '15 Mei 1998',
  'Laki-laki',
  '+62 812-3456-7890',
  'Jakarta, Indonesia',
  'Bahasa Indonesia',
  'DD/MM/YYYY',
  0,
  0,
  0,
  1,
  0,
  1,
  1,
  0,
  1,
  '07:00',
  '22:00',
  '06:00',
  'Mei 2025',
  5,
  2025,
  21,
  3
);

INSERT INTO target_categories (user_id, name, description, icon_name, icon_bg, icon_color, jumlah_target, status, sort_order) VALUES
(1, 'Pengembangan Diri', 'Kategori untuk target yang berfokus pada pengembangan diri dan kebiasaan positif.', 'eco_rounded', '#DCFCE7', '#22C55E', '7 target', 'Aktif', 1),
(1, 'Kesehatan', 'Kategori untuk target yang berkaitan dengan kesehatan fisik dan mental.', 'favorite_rounded', '#FFF1F2', '#EF4444', '5 target', 'Aktif', 2),
(1, 'Keuangan', 'Kategori untuk target yang berhubungan dengan pengelolaan dan perencanaan keuangan.', 'account_balance_wallet_rounded', '#FFFBEB', '#F59E0B', '6 target', 'Aktif', 3),
(1, 'Karier', 'Kategori untuk target yang mendukung pengembangan karier dan pekerjaan.', 'work_rounded', '#F5F3FF', '#8B5CF6', '3 target', 'Aktif', 4),
(1, 'Hubungan', 'Kategori untuk target yang berfokus pada hubungan sosial dan keluarga.', 'people_rounded', '#FFEDF5', '#EC4899', '2 target', 'Aktif', 5);

INSERT INTO targets (user_id, title, icon_name, icon_bg, icon_color, category, category_color, priority, deadline, progress, progress_label, status, status_color, sort_order) VALUES
(1, 'Membaca 12 Buku dalam Setahun', 'menu_book_rounded', '#DCFCE7', '#22C55E', 'Pengembangan Diri', '#22C55E', 'Tinggi', '31 Des 2024', 0.58, '58%', 'Sedang Berjalan', '#F59E0B', 1),
(1, 'Olahraga 4x Seminggu', 'fitness_center_rounded', '#EFF6FF', '#3B82F6', 'Kesehatan', '#3B82F6', 'Tinggi', '30 Jun 2024', 0.75, '75%', 'Sedang Berjalan', '#F59E0B', 2),
(1, 'Menabung Rp10.000.000', 'savings_rounded', '#FFFBEB', '#F59E0B', 'Keuangan', '#F59E0B', 'Sedang', '31 Des 2024', 0.40, '40%', 'Sedang Berjalan', '#F59E0B', 3),
(1, 'Belajar UI/UX Design', 'laptop_rounded', '#F5F3FF', '#8B5CF6', 'Karier', '#8B5CF6', 'Sedang', '15 Okt 2024', 0.20, '20%', 'Sedang Berjalan', '#F59E0B', 4),
(1, 'Liburan ke Jepang', 'flight_rounded', '#FFF1F2', '#EF4444', 'Keuangan', '#F59E0B', 'Rendah', '31 Des 2025', 0.10, '10%', 'Belum Dimulai', '#EF4444', 5);

INSERT INTO dashboard_motivations (user_id, title, quote, author, is_today, sort_order) VALUES
(1, 'Motivasi Hari Ini', 'Disiplin hari ini adalah keberhasilan masa depanmu.', 'Target365', 1, 1);

INSERT INTO dashboard_quotes (user_id, category, category_color, quote, date_label, liked, sort_order) VALUES
(1, 'Inspirasi', '#3B82F6', 'Jangan menunggu waktu yang tepat, karena waktu tidak akan pernah tepat. Mulailah sekarang.', '24 Mei 2025', 0, 1),
(1, 'Produktivitas', '#8B5CF6', 'Fokus pada progres, bukan pada kesempurnaan. Sedikit setiap hari, hasilnya luar biasa.', '23 Mei 2025', 1, 2),
(1, 'Mindset', '#EC4899', 'Pikiran positif akan membawa kamu ke tempat yang tidak bisa dicapai oleh pikiran negatif.', '22 Mei 2025', 0, 3),
(1, 'Kehidupan', '#F59E0B', 'Hidup bukan tentang menunggu badai berlalu, tapi belajar menari di tengah hujan.', '21 Mei 2025', 0, 4),
(1, 'Kebiasaan', '#22C55E', 'Kebiasaan kecil yang konsisten akan menghasilkan perubahan besar dalam hidupmu.', '20 Mei 2025', 1, 5),
(1, 'Inspirasi', '#3B82F6', 'Percayalah pada dirimu sendiri dan semua hal akan mungkin terjadi.', '19 Mei 2025', 0, 6);

INSERT INTO calendar_events (user_id, day, title, color, time_label, event_type, sort_order) VALUES
(1, 1, 'Olahraga 4x Seminggu', '#22C55E', '06:00 - 07:00', 'Target', 1),
(1, 4, 'Motivasi Pagi', '#F59E0B', '07:00 - 07:10', 'Motivasi', 1),
(1, 6, 'Belajar UI/UX Design', '#3B82F6', '20:00 - 21:30', 'Target', 1),
(1, 9, 'Minum 2L Air', '#EC4899', '08:00 - 20:00', 'Kebiasaan', 1),
(1, 9, 'Membaca 12 Buku...', '#22C55E', '21:00 - 22:00', 'Target', 2),
(1, 13, 'Menabung Rp10.000.000', '#F59E0B', 'Setiap malam', 'Target', 1),
(1, 14, 'Kerja Project Klien', '#22C55E', '09:00 - 17:00', 'Aktivitas', 1),
(1, 16, 'Meditasi 10 Menit', '#8B5CF6', '06:30 - 06:45', 'Kebiasaan', 1),
(1, 18, 'Jangan lupa bersyukur', '#F59E0B', '07:30 - 07:35', 'Motivasi', 1),
(1, 20, 'Review Materi Design', '#3B82F6', '19:00 - 20:00', 'Target', 1),
(1, 21, 'Olahraga 4x Seminggu', '#22C55E', '06:00 - 07:00', 'Target', 1),
(1, 21, 'Journal Malam', '#8B5CF6', '21:00 - 21:20', 'Kebiasaan', 2),
(1, 23, 'Deadline Project UI', '#EF4444', '17:00', 'Deadline', 1),
(1, 26, 'Update Portofolio', '#3B82F6', '20:00 - 21:00', 'Target', 1),
(1, 28, 'Belajar Frontend Lanjutan', '#22C55E', '19:30 - 21:00', 'Target', 1),
(1, 30, 'Evaluasi Bulanan', '#22C55E', '18:00 - 19:00', 'Aktivitas', 1);

INSERT INTO deadlines (user_id, color, title, date_label, remaining, due_date) VALUES
(1, '#EF4444', 'Deadline Project UI', '23 Mei 2025', '2 hari lagi', '2025-05-23'),
(1, '#F59E0B', 'Laporan Bulanan', '30 Mei 2025', '9 hari lagi', '2025-05-30'),
(1, '#8B5CF6', 'Evaluasi Q2', '15 Jun 2025', '25 hari lagi', '2025-06-15');

INSERT INTO report_category_progress (user_id, name, color, percent, target_summary, sort_order) VALUES
(1, 'Pengembangan Diri', '#22C55E', 75, '3/4 target', 1),
(1, 'Kesehatan', '#3B82F6', 68, '2/3 target', 2),
(1, 'Keuangan', '#F59E0B', 55, '2/3 target', 3),
(1, 'Karier', '#8B5CF6', 40, '1/3 target', 4),
(1, 'Hubungan', '#EC4899', 30, '1/2 target', 5);

INSERT INTO report_trends (user_id, label, value, sort_order) VALUES
(1, 'Jan', 20, 1),
(1, 'Feb', 28, 2),
(1, 'Mar', 35, 3),
(1, 'Apr', 44, 4),
(1, 'Mei', 62, 5);

INSERT INTO profile_activities (user_id, icon_name, color, background_color, title, description, time_label, created_at) VALUES
(1, 'check_rounded', '#22C55E', '#DCFCE7', 'Menyelesaikan target', '"Olahraga 4x Seminggu"', 'Hari ini, 07:30', '2025-05-21 07:30:00'),
(1, 'edit_rounded', '#3B82F6', '#EFF6FF', 'Mengupdate progress', '"Belajar UI/UX Design" — 65%', 'Kemarin, 21:15', '2025-05-20 21:15:00'),
(1, 'add_rounded', '#F59E0B', '#FFFBEB', 'Menambahkan target baru', '"Meditasi 10 Menit Setiap Hari"', '15 Mei 2025, 06:45', '2025-05-15 06:45:00'),
(1, 'emoji_emotions_rounded', '#8B5CF6', '#F5F3FF', 'Membaca motivasi harian', '"Disiplin adalah kunci sukses"', '15 Mei 2025, 06:30', '2025-05-15 06:30:00');

INSERT INTO profile_achievements (user_id, icon_name, color, background_color, title, subtitle, date_label, achieved_at) VALUES
(1, 'check_circle_outline_rounded', '#22C55E', '#DCFCE7', 'Mencapai 90% target "Membaca 12 Buku dalam Setahun"', 'Terus pertahankan konsistensimu!', '20 Mei 2025', '2025-05-20 00:00:00'),
(1, 'emoji_events_outlined', '#F59E0B', '#FEF3C7', 'Berhasil menyelesaikan target "Menabung Rp10.000.000"', 'Pencapaian luar biasa!', '18 Mei 2025', '2025-05-18 00:00:00'),
(1, 'bolt_rounded', '#8B5CF6', '#F3E8FF', 'Streak 7 hari berturut-turut', 'Konsistensi adalah kunci keberhasilan!', '17 Mei 2025', '2025-05-17 00:00:00');

INSERT INTO profile_sessions (user_id, icon_name, title, location, current_device, last_active) VALUES
(1, 'smartphone_rounded', 'Android — Samsung Galaxy S23', 'Jakarta, Indonesia', 1, '2025-05-21 07:30:00'),
(1, 'computer_rounded', 'Chrome — Windows 11', 'Jakarta, Indonesia', 0, '2025-05-20 12:00:00');

