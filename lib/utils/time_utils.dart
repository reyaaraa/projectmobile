// lib/utils/time_utils.dart
class TimeUtils {
  /// Convert local DateTime to target offset (minutes from UTC).
  /// Example: WIB (UTC+7) => targetOffsetMinutes = 7*60
  static DateTime convertToOffset(
    DateTime sourceLocal,
    int targetOffsetMinutes,
  ) {
    final utc = sourceLocal.toUtc();
    return utc.add(Duration(minutes: targetOffsetMinutes));
  }
}
