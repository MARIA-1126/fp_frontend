import 'dart:math';

/// UI-only ID generator for mock tasks.
class IdUtils {
  static final _rand = Random();

  static String generateId() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final salt = _rand.nextInt(1 << 20);
    return 'task_${now}_$salt';
  }
}
