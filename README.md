# app_logs

A simple, production-safe logging library for Flutter.

Use it to print clean logs during development, and keep logging controlled and safer in release builds.

---

## Features

- **Log levels**: debug, info, warn, error, fatal
- **Tags**: group logs like `API`, `AUTH`, `DB`, `UI`
- **Structured data**: attach extra info with `data: {}`
- **Sanitization**: (enabled in default configs) redacts emails/phones in messages
- **Truncation**: limits very large logs (example: huge JSON)
- **Error + stack trace**: log failures with full context
- **Optional global error hooks**: capture uncaught Flutter/platform errors

---

## Installation

### pub.dev

```yaml
dependencies:
  app_logs: ^0.1.0
```

```bash
flutter pub get
```

### GitHub

```yaml
dependencies:
  app_logs:
    git:
      url: https://github.com/ahmedchoteri/app_logs.git
      ref: main
```

```bash
flutter pub get
```

---

## Quick start

Initialize once in `main.dart`:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app_logs/app_logs.dart';

void main() {
  // Debug: more logs. Release: only warnings + errors.
  Log.init(kReleaseMode ? LogConfig.releaseSafe() : LogConfig.debug());

  // Optional: capture uncaught errors
  FlutterLogHooks.installGlobalHandlers();

  runApp(const MyApp());
}
```

---

## Usage

### Basic logs

```dart
Log.d('Dashboard opened');
Log.i('User logged in');
Log.w('API is slow', data: {'ms': 920});
Log.e('Failed to load profile', error: e, st: st);
Log.f('Unexpected crash', error: e, st: st);
```

### Tagged logs (recommended)

```dart
final api = Log.tag('API');

api.d('GET /users started');
api.i('GET /users success', data: {'status': 200});
api.e('GET /users failed', error: e, st: st);
```

---

## Release safety (important)

Recommended setup:

```dart
Log.init(kReleaseMode ? LogConfig.releaseSafe() : LogConfig.debug());
```

- `LogConfig.debug()` → more logs for development
- `LogConfig.releaseSafe()` → only important logs (warn/error) for production

---

## Sanitization (privacy)

Default configs include sanitization. If a message contains an email or phone number, it is redacted:

```dart
Log.i('Contact: john.doe@example.com, +1 234-567-8901', tag: 'SAFE');
```

Printed output will hide that data:

- `Contact: [REDACTED_EMAIL], [REDACTED_PHONE]`

Note: Avoid logging passwords, tokens, OTPs, or secrets.

---

## Global error capturing (optional)

Enable:

```dart
FlutterLogHooks.installGlobalHandlers();
```

This logs:
- Flutter framework errors
- Uncaught platform errors

Optional zone wrapper:

```dart
FlutterLogHooks.runZonedGuarded(() {
  runApp(const MyApp());
});
```

---

## License

MIT (see `LICENSE`).
