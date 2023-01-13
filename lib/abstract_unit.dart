import 'package:idle/number.dart';
import 'package:idle/time_unit.dart';

abstract class AbstractUnit {
  Number _currentAmount = Number.zero;
  TimeUnit _lastTimeUnit = TimeUnit.nonExistent;
  bool _initialized = false;
  bool _isRunning = false;
  late final String id;

  static int _counter = 0;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is AbstractUnit) {
      return id == other.id;
    }
    return false;
  }

  AbstractUnit() {
    id = '${runtimeType.toString()}.${++_counter}';
    init();
  }

  Number init() {
    if (_initialized || _isRunning) {
      return getCurrentAmount();
    }
    _isRunning = true;
    var initAmount = unitInit();
    _initialized = true;
    _isRunning = false;
    return setAmount(initAmount);
  }

  Number tick(TimeUnit timeUnit) {
    if (_isRunning) {
      return getCurrentAmount();
    }
    if (timeUnit.compareTo(_lastTimeUnit) > 0) {
      _isRunning = true;
      var result = setAmount(unitTick(timeUnit));
      _lastTimeUnit = timeUnit;
      _isRunning = false;
      return result;
    }
    return _currentAmount;
  }

  Number unitInit() {
    return Number.zero;
  }

  Number unitTick(TimeUnit timeUnit);

  Number getCurrentAmount() {
    return _currentAmount;
  }

  void reset() {
    _currentAmount = Number.zero;
    _lastTimeUnit = TimeUnit.nonExistent;
  }

  void transfer(AbstractUnit unit) {
    if (_lastTimeUnit.compareTo(unit._lastTimeUnit) < 0) {
      setAmount(unit.getCurrentAmount());
    }
    _lastTimeUnit = unit._lastTimeUnit;
  }

  Number setAmount(Number amount) {
    _currentAmount = amount;
    return _currentAmount;
  }

  Number incAmount(Number amount) {
    assert(amount.isNonNegative());
    _currentAmount += amount;
    return _currentAmount;
  }

  Number decAmount(Number amount) {
    assert(amount.compareTo(_currentAmount) <= 0);
    _currentAmount -= amount;
    return _currentAmount;
  }
}
