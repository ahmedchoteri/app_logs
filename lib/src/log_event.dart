class LogEvent {
  LogEvent({
    required this.level,
    required this.message,
    required this.timestamp,
    this.tag,
    this.error,
    this.stackTrace,
    this.data,
  });

  final DateTime timestamp;
  final String message;
  final String? tag;
  final Object? error;
  final StackTrace? stackTrace;
  final Map<String, Object?>? data;
  final dynamic level;
}
