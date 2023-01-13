import 'package:idle/abstract_unit.dart';
import 'package:idle/number.dart';
import 'package:idle/time_unit.dart';

class Feedback extends AbstractUnit {
  AbstractUnit _resource;
  AbstractUnit _multiplier;

  Feedback(this._resource, this._multiplier);

  @override
  Number unitInit() {
    return Number.zero;
  }

  @override
  Number unitTick(TimeUnit timeUnit) {
    var product = getCurrentAmount() * _multiplier.tick(timeUnit) +
        _resource.tick(timeUnit);
    return product;
  }

  void updateResource(AbstractUnit unit) {
    unit.transfer(_resource);
    _resource = unit;
  }

  void updateMultiplier(AbstractUnit unit) {
    unit.transfer(_multiplier);
    _multiplier = unit;
  }
}
