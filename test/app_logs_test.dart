import 'package:test/test.dart';
import 'package:app_logs/app_logs.dart';

/// A test sink that captures everything the logger outputs.
class MemorySink implements LogSink {
  final events = <LogEvent>[];
  final lines = <String>[];

  @override
  void write(LogEvent event, String formatted) {
    events.add(event);
    lines.add(formatted);
  }

  void clear() {
    events.clear();
    lines.clear();
  }
}

void main() {
  group('app_logs', () {
    late MemorySink sink;

    setUp(() {
      sink = MemorySink();

      // Use a deterministic config for tests (no console printing).
      Log.init(
        LogConfig(
          minLevel: LogLevel.trace,
          sinks: [sink],
          sanitizer: (s) => s, // no sanitizer by default; test sanitizer separately
          printTime: false,
          printTag: true,
          printLevel: true,
          maxMessageLength: 50,
        ),
      );

      sink.clear();
    });

    test('logs respect minLevel filtering', () {
      Log.init(
        LogConfig(
          minLevel: LogLevel.warn,
          sinks: [sink],
          sanitizer: (s) => s,
          printTime: false,
          printTag: true,
          printLevel: true,
          maxMessageLength: 200,
        ),
      );

      Log.d('debug should NOT appear', tag: 'T');
      Log.i('info should NOT appear', tag: 'T');
      Log.w('warn should appear', tag: 'T');
      Log.e('error should appear', tag: 'T');

      expect(sink.lines.length, 2);
      expect(sink.lines[0], contains('[WARN]'));
      expect(sink.lines[1], contains('[ERROR]'));
    });

    test('tag logger includes tag in output', () {
      final api = Log.tag('API');
      api.d('request started');

      expect(sink.lines.length, 1);
      expect(sink.lines.single, contains('[API]'));
      expect(sink.lines.single, contains('request started'));
    });

    test('data map is appended to output', () {
      Log.i('hello', tag: 'X', data: {'a': 1, 'b': 'two'});

      expect(sink.lines.length, 1);
      expect(sink.lines.single, contains('data='));
      expect(sink.lines.single, contains('a'));
      expect(sink.lines.single, contains('b'));
    });

    test('sanitizer redacts email and phone by default sanitizer', () {
      Log.init(
        LogConfig(
          minLevel: LogLevel.debug,
          sinks: [sink],
          sanitizer: DefaultSanitizers.applyAll,
          printTime: false,
          printTag: true,
          printLevel: true,
          maxMessageLength: 200,
        ),
      );

      // IMPORTANT: init logs once; clear before assertions
      sink.clear();

      Log.i(
        'Contact me at john.doe@example.com or +1 234-567-8901',
        tag: 'SAFE',
      );

      expect(sink.lines.length, 1);

      final out = sink.lines.single;
      expect(out, isNot(contains('john.doe@example.com')));
      expect(out, isNot(contains('234-567-8901')));
      expect(out, contains('[REDACTED_EMAIL]'));
      expect(out, contains('[REDACTED_PHONE]'));
    });


    test('message is truncated if it exceeds maxMessageLength', () {
      // maxMessageLength set to 50 in setUp
      final longMsg = 'x' * 120;
      Log.d(longMsg, tag: 'CUT');

      final out = sink.lines.single;
      expect(out, contains('[TRUNCATED'));
      // Ensure not printing the full string
      expect(out.length, lessThan(400));
    });

    test('error and stack trace are included when provided', () {
      final st = StackTrace.current;
      Log.e('boom', tag: 'ERR', error: StateError('bad'), st: st);

      final out = sink.lines.single;
      expect(out, contains('boom'));
      expect(out, contains('error:'));
      expect(out, contains('Bad state: bad')); // <-- correct expectation
      expect(out, contains('stack:'));
    });

  });
}
