import 'log_level.dart';
import 'log_sanitizer.dart';
import 'sinks/log_sink.dart';
import 'sinks/console_sink.dart';

class LogConfig {
  LogConfig({
    required this.minLevel,
    required this.sinks,
    required this.sanitizer,
    required this.printTime,
    required this.printTag,
    required this.printLevel,
    required this.maxMessageLength,
  });

  final LogLevel minLevel;
  final List<LogSink> sinks;
  final LogSanitizer sanitizer;

  final bool printTime;
  final bool printTag;
  final bool printLevel;

  /// Helps avoid huge logs (e.g., large JSON) exploding consoles.
  final int maxMessageLength;

  factory LogConfig.debug() => LogConfig(
    minLevel: LogLevel.debug,
    sinks: [ConsoleSink.pretty()],
    sanitizer: DefaultSanitizers.applyAll,
    printTime: true,
    printTag: true,
    printLevel: true,
    maxMessageLength: 4000,
  );

  /// Safe default for Release: only warnings/errors, still sanitized.
  factory LogConfig.releaseSafe() => LogConfig(
    minLevel: LogLevel.warn,
    sinks: [ConsoleSink.compact()],
    sanitizer: DefaultSanitizers.applyAll,
    printTime: true,
    printTag: true,
    printLevel: true,
    maxMessageLength: 2000,
  );
}
