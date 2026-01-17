import 'dart:async' as async;

import 'package:flutter/foundation.dart';
import 'log.dart';

class FlutterLogHooks {
  /// Call this once in main() after Log.init(...)
  static void installGlobalHandlers() {
    FlutterError.onError = (FlutterErrorDetails details) {
      Log.e(
        'FlutterError',
        tag: 'CRASH',
        error: details.exception,
        st: details.stack,
        data: {
          'library': details.library,
          'context': details.context?.toDescription(),
        },
      );
      // Keep default behavior in debug.
      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      Log.f('Uncaught platform error', tag: 'CRASH', error: error, st: stack);
      return true; // handled
    };
  }

  /// Optional: wrap runApp with this to catch zone errors too.
  static R? runZonedGuarded<R>(R Function() body) {
    return async.runZonedGuarded<R>(
      body,
          (Object error, StackTrace stack) {
        Log.f('Uncaught zone error', tag: 'CRASH', error: error, st: stack);
      },
    );
  }
}
