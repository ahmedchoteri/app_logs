import '../log_event.dart';

abstract class LogSink {
  void write(LogEvent event, String formatted);
}
