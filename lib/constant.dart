import 'package:idle/abstract_unit.dart';
import 'package:idle/number.dart';
import 'package:idle/time_unit.dart';

class Constant extends AbstractUnit {
  Number _constant;

  Constant(this._constant);

  @override
  Number unitInit() {
    return _constant;
  }

  @override
  Number unitTick(TimeUnit timeUnit) {
    return _constant;
  }

  Number get constant => _constant;

  void setConstant(Number value) {
    _constant = value;
    setAmount(value);
  }
}
