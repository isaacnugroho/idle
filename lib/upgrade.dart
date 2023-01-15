import 'package:idle/units.dart';
import 'package:idle/functions.dart';
import 'package:idle/number.dart';

class Upgrade extends LinearAccumulator {
  int _level = 0;
  int _subLevel = 0;
  final int _subLevels;
  final Number _costMultiplier;
  final TickerUnit _defaultMultiplier = TickerUnit.from(Number.one);
  Number _cost;

  Upgrade(this._subLevels, this._cost, this._costMultiplier)
      : super(TickerUnit()) {
    multipliers.addSource(_defaultMultiplier);
  }

  Number get cost => _cost;
  int get level => _level;
  int get subLevel => _subLevel;
  int get subLevels => _subLevels;

  bool buyUpgrade(TickerUnit bank) {
    if (bank.value.compareTo(_cost) < 0) {
      return false;
    }
    bank.decrease(_cost);
    subLevelBought();
    return true;
  }

  void subLevelBought() {
    source.accumulate(Number.one);
    if (++_subLevel == _subLevels) {
      _subLevel = 0;
      _level++;
      _cost *= _costMultiplier;
      _defaultMultiplier.setValue(_defaultMultiplier.value * Number.two);
    }
  }
}
