import 'package:idle/units.dart';
import 'package:idle/number.dart';
import 'package:idle/time_unit.dart';

class Feedback extends TickerUnit {
  TickerUnit _resource;
  TickerUnit _multiplier;

  Feedback(this._resource, this._multiplier);

  @override
  Number unitInit() {
    return setValue(Number.zero);
  }

  @override
  Number unitTick(TimeUnit timeUnit) {
    var product = value * _multiplier.tick(timeUnit) +
        _resource.tick(timeUnit);
    return produce(product);
  }

  void updateResource(TickerUnit unit) {
    unit.transfer(_resource);
    _resource = unit;
  }

  void updateMultiplier(TickerUnit unit) {
    unit.transfer(_multiplier);
    _multiplier = unit;
  }
}
