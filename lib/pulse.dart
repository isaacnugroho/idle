import 'package:idle/units.dart';
import 'package:idle/time_unit.dart';

import 'number.dart';

class Pulse {
  double _timestamp = 0;
  final TickerUnit _timeScaleUnit;

  Pulse(TickerUnit? timeScaleUnit) : _timeScaleUnit = timeScaleUnit ?? TickerUnit.from(Number.one) {
    _timeScaleUnit.init();
  }

  TimeUnit next(num delta) {
    assert(delta > 0.0);
    _timestamp += delta;
    var numDelta = Number.from(delta);
    var timeUnit = TimeUnit(
      timestamp: _timestamp,
      deltaEpoch: delta.toDouble(),
      scaledTime: numDelta * _timeScaleUnit.value,
    );
    _timeScaleUnit.tick(timeUnit);
    return timeUnit;
  }

  TickerUnit get timeScaleUnit => _timeScaleUnit;
}
