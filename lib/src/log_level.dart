enum LogLevel {
  trace(0),
  debug(1),
  info(2),
  warn(3),
  error(4),
  fatal(5),
  none(6);

  final int priority;
  const LogLevel(this.priority);

  bool allows(LogLevel other) => other.priority >= priority;
}
