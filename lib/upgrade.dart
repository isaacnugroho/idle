import 'package:idle/abstract_unit.dart';
import 'package:idle/constant.dart';
import 'package:idle/functions.dart';

import 'number.dart';

class Upgrade extends Linear {
  int _level;
  int _subLevel = 0;
  final Number _levelMultiplier;
  final Number _costMultiplier;
  final Constant _defaultMultiplier = Constant(Number.one);
  Number _cost;
  late Number _levelIncrement;
  late Number _fullMultiplier;

  Upgrade(this._levelMultiplier, this._cost, this._costMultiplier, bool bought)
      : _level = bought ? 1 : 0,
        _fullMultiplier = _levelMultiplier,
        super(Constant(Number.zero)) {
    _levelIncrement = _levelMultiplier.sub(Number.one).div(Number.ten);
    multipliers.addSource(_defaultMultiplier);
  }

  Number get cost => _cost;
  int get level => _level;
  int get subLevel => _subLevel;

  bool buyUpgrade(AbstractUnit bank) {
    if (bank.getCurrentAmount().compareTo(_cost) < 0) {
      return false;
    }
    bank.decAmount(_cost);
    if (_level == 0) {
      _level++;
      source.setConstant(Number.one);
    } else {
      _subLevel++;
      if (_subLevel == 10) {
        _subLevel = 0;
        _level++;
        _cost *= _costMultiplier;
        source.setConstant(_fullMultiplier);
        _fullMultiplier *= _levelMultiplier;
        _levelIncrement = _fullMultiplier.sub(source.constant).div(Number.ten);
      } else {
        var newMultiplier = source.constant + _levelIncrement;
        source.setConstant(newMultiplier);
      }
    }
    return true;
  }
}
