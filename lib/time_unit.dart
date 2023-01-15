import 'package:flutter/foundation.dart';
import 'package:idle/number.dart';

@immutable
class TimeUnit implements Comparable<TimeUnit> {
  final double timestamp;
  final double deltaEpoch;
  final Number scaledTime;

  const TimeUnit(
      {required this.timestamp,
      required this.deltaEpoch,
      required this.scaledTime});

  static const TimeUnit epoch =
      TimeUnit(timestamp: 0, deltaEpoch: 0.0, scaledTime: Number.zero);
  static const TimeUnit nonExistent =
      TimeUnit(timestamp: -1, deltaEpoch: 0.0, scaledTime: Number.zero);

  bool isZero() {
    return scaledTime.isZero();
  }

  @override
  int compareTo(TimeUnit other) {
    return timestamp.compareTo(other.timestamp);
  }
}
