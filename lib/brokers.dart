import 'package:idle/functions.dart';
import 'package:idle/number.dart';
import 'package:idle/time_unit.dart';
import 'package:idle/units.dart';

class LevelBuyer extends AbstractUnit {
  int _level = 0;
  final int _stages;
  final Number _costMultiplier;
  final TickerUnit bank;
  final LinearAccumulator target;
  Number _cost;

  LevelBuyer(
      this.bank, this.target, this._stages, this._cost, this._costMultiplier) {
    assert(_stages > 0);
  }

  Number get cost => _cost;

  int get stages => _stages;

  int get level => _level == 0 ? 0 : 1 + (_level ~/ _stages);

  bool buyUpgrade() {
    if (bank.value.compareTo(_cost) < 0) {
      return false;
    }
    bank.decrease(_cost);
    _levelBought();
    return true;
  }

  void _levelBought() {
    target.source.accumulate(Number.one);
    accumulate(Number.one);
    if ((++_level % _stages) == 0) {
      _cost *= _costMultiplier;
    }
  }
}

class Converter extends TickerUnit {
  final AbstractUnit _source;
  final TickerUnit _multiplier;

  Converter(this._source, this._multiplier);

  @override
  Number unitInit() {
    return _multiplier.init() * _source.init();
  }

  @override
  Number unitTick(TimeUnit timeUnit) {
    var product = _multiplier.tick(timeUnit) * _source.value;
    return produce(product);
  }
}

class Gate extends TickerUnit {
  final AbstractUnit _source;
  final TickerUnit _multiplier;
  final Number _threshold;
  final int _compareValue;

  Gate(this._source, this._multiplier, this._threshold, this._compareValue);

  @override
  Number unitInit() {
    var src = _source.init();
    var mul = _multiplier.init();
    var compareTo = src.compareTo(_threshold);
    return produce(compareTo == _compareValue ? mul : Number.zero);
  }

  @override
  Number unitTick(TimeUnit timeUnit) {
    var src = _source.value;
    var mul = _multiplier.tick(timeUnit);
    var compareTo = src.compareTo(_threshold);
    return produce(compareTo == _compareValue ? mul : Number.zero);
  }
}
