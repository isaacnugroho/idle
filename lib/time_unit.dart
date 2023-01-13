import 'package:flutter/foundation.dart';
import 'package:idle/number.dart';

@immutable
class TimeUnit implements Comparable<TimeUnit> {
  final double timestamp;
  final Number deltaEpoch;
  final Number scaledTime;

  const TimeUnit(
      {required this.timestamp,
      required this.deltaEpoch,
      required this.scaledTime});

  static const TimeUnit zero =
      TimeUnit(timestamp: 0, deltaEpoch: Number.zero, scaledTime: Number.zero);
  static const TimeUnit nonExistent =
      TimeUnit(timestamp: -1, deltaEpoch: Number.zero, scaledTime: Number.zero);

  bool isZero() {
    return scaledTime.isZero();
  }

  @override
  int compareTo(TimeUnit other) {
    return timestamp.compareTo(other.timestamp);
  }
}
