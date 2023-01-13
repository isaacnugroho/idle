import 'package:idle/abstract_unit.dart';
import 'package:idle/constant.dart';
import 'package:idle/time_unit.dart';

import 'number.dart';

class Pulse {
  double _timestamp = 0;
  AbstractUnit _timeScaleUnit;

  Pulse(AbstractUnit? timeScaleUnit) : _timeScaleUnit = timeScaleUnit ?? Constant(Number.one);

  TimeUnit next(num delta) {
    assert(delta > 0.0);
    _timestamp += delta;
    var numDelta = Number.from(delta);
    var timeUnit = TimeUnit(
      timestamp: _timestamp,
      deltaEpoch: numDelta,
      scaledTime: numDelta * _timeScaleUnit.getCurrentAmount(),
    );
    _timeScaleUnit.tick(timeUnit);
    return timeUnit;
  }

  void setTimeScaleUnit(AbstractUnit unit) {
    unit.transfer(_timeScaleUnit);
    _timeScaleUnit = unit;
  }
}
