**Target365** is a cross‑platform Flutter application designed to provide a seamless experience across mobile (Android & iOS),web, and desktop (Windows, macOS, Linux). This repository contains the full source code, assets, and configuration needed to build, run, and contribute to the project.

## Technology Stack

- **Framework:** Flutter 3.19 (Dart 3)
- **Supported Platforms:** Android, iOS, Web, Windows, macOS, Linux
- **State Management:** Provider (or Riverpod – adjust as needed)
- **Networking:** `http` package
- **Testing:** `flutter_test`
- **CI/CD:** GitHub Actions (optional)

## Prerequisites

- Flutter SDK installed (see [Flutter installation guide](https://flutter.dev/docs/get-started/install))
- Android Studio / Xcode for mobile builds
- Visual Studio Code or Android Studio for IDE support
- A device or emulator/simulator for the target platform

## Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/target365_app.git
cd target365_app

# Install dependencies
flutter pub get
```

## Backend Setup

1. Import [`backend/database/schema.sql`](/home/rizky/Documents/target365/target365_app/backend/database/schema.sql) ke MySQL lewat phpMyAdmin.
2. Import [`backend/database/seed.sql`](/home/rizky/Documents/target365/target365_app/backend/database/seed.sql) untuk data contoh.
3. Copy folder [`backend/api`](/home/rizky/Documents/target365/target365_app/backend/api) ke document root Apache, misalnya menjadi `htdocs/target365_api/api`.
   Pastikan aplikasi bisa diakses melalui `http://127.0.0.1:8080/target365_api/api/login.php`.

4. Sesuaikan koneksi database lewat file [`backend/.env`](/home/rizky/Documents/target365/target365_app/backend/.env) atau salin dari [`backend/.env.example`](/home/rizky/Documents/target365/target365_app/backend/.env.example) jika username/password MySQL kamu berbeda.
   Backend akan membaca `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS`, dan `DB_SOCKET` dari file ini.
5. Jalankan Flutter dengan base URL API:

```bash
flutter run --dart-define=TARGET365_API_BASE_URL=http://127.0.0.1:8080/target365_api/api
```

Untuk Android emulator, pakai `http://10.0.2.2:8080/target365_api/api`.

## Build & Run

### Android

```bash
flutter run -d android
```

### iOS

```bash
flutter run -d ios
```

### Web

```bash
flutter run -d chrome
```

### Desktop (Windows example)

```bash
flutter run -d windows
```

You can also build release artifacts:

```bash
flutter build apk   # Android
flutter build ios   # iOS
flutter build web   # Web
flutter build macos # macOS
flutter build linux  # Linux
flutter build windows # Windows
```

## Testing

```bash
flutter test
```

Run unit and widget tests to ensure code quality.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes with clear messages.
4. Push to your fork and open a Pull Request.
5. Ensure all tests pass and code is formatted (`flutter format .`).

See `CONTRIBUTING.md` for detailed guidelines.

## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

## Contact & Support

- **Author:** Rizky Pratama
- **Email:** rizky@example.com
- **GitHub:** [target365_app repository](https://github.com/yourusername/target365_app)

Feel free to open an issue for bugs or feature requests.


[![Flutter Version](https://img.shields.io/badge/Flutter-3.19-blue)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)


## Overview

**Target365** is a cross‑platform Flutter application designed to provide a seamless experience across mobile (Android & iOS), web, and desktop (Windows, macOS, Linux). This repository contains the full source code, assets, and configuration needed to build, run, and contribute to the project.


## Technology Stack

- **Framework:** Flutter 3.19 (Dart 3)
- **Supported Platforms:** Android, iOS, Web, Windows, macOS, Linux
- **State Management:** Provider (or Riverpod – adjust as needed)
- **Networking:** `http` package
- **Testing:** `flutter_test`
- **CI/CD:** GitHub Actions (optional)


## Prerequisites

- Flutter SDK installed (see [Flutter installation guide](https://flutter.dev/docs/get-started/install))
- Android Studio / Xcode for mobile builds
- Visual Studio Code or Android Studio for IDE support
- A device or emulator/simulator for the target platform


## Setup


```bash
# Clone the repository
git clone https://github.com/yourusername/target365_app.git
cd target365_app

# Install dependencies
flutter pub get
```


## Build & Run


### Android

```bash
flutter run -d android
```



### iOS

```bash
flutter run -d ios
```



### Web

```bash
flutter run -d chrome
```



### Desktop (Windows example)

```bash
flutter run -d windows
```



You can also build release artifacts:

```bash
flutter build apk   # Android
flutter build ios   # iOS
flutter build web   # Web
flutter build macos # macOS
flutter build linux  # Linux
flutter build windows # Windows
```


## Testing


```bash
flutter test
```

Run unit and widget tests to ensure code quality.


## Contributing


Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes with clear messages.
4. Push to your fork and open a Pull Request.
5. Ensure all tests pass and code is formatted (`flutter format .`).

See `CONTRIBUTING.md` for detailed guidelines.


## License

This project is licensed under the MIT License – see the [LICENSE](LICENSE) file for details.

## Contact & Support

- **Author:** Rizky Pratama
- **Email:** rizky@example.com
- **GitHub:** [target365_app repository](https://github.com/yourusername/target365_app)

Feel free to open an issue for bugs or feature requests.
