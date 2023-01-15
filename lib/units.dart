import 'package:idle/number.dart';
import 'package:idle/time_unit.dart';

abstract class AbstractUnit {
  bool _isInitialized = false;
  bool _isRunning = false;
  late final String id;
  Number _value = Number.zero;

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
  }

  void unitInit() {  }

  Number get value => _value;

  Number init() {
    if (!_isInitialized) {
      _isRunning = true;
      unitInit();
      _isRunning = false;
      _isInitialized = true;
    }
    return _value;
  }

  Number setValue(Number amount) {
    _value = amount;
    return _value;
  }

  Number accumulate(Number amount) {
    _value += amount;
    return _value;
  }

  void reset() {
    _value = Number.zero;
  }

  void transfer(AbstractUnit unit) {
    _value = unit._value;
  }
}

class TickerUnit extends AbstractUnit {
  TimeUnit _lastTimeUnit = TimeUnit.nonExistent;

  final bool isAccumulator;
  late final Number Function(Number) produce;

  TickerUnit([this.isAccumulator = false]) {
    if (isAccumulator) {
      produce = accumulate;
    } else {
      produce = setValue;
    }
    init();
  }

  factory TickerUnit.from(Number number) {
    var unit = TickerUnit();
    unit.setValue(number);
    return unit;
  }

  void unitTick(TimeUnit timeUnit) {
  }

  bool isNextTick(TimeUnit timeUnit) {
    return timeUnit.compareTo(_lastTimeUnit) > 0;
  }

  Number tick(TimeUnit timeUnit) {
    assert(_isInitialized);
    if (!_isRunning && isNextTick(timeUnit)) {
      _isRunning = true;
      unitTick(timeUnit);
      _isRunning = false;
      _lastTimeUnit = timeUnit;
    }
    return _value;
  }

  @override
  void transfer(AbstractUnit unit) {
    super.transfer(unit);
    if (unit is TickerUnit) {
      _lastTimeUnit = unit._lastTimeUnit;
    }
  }

  @override
  void reset() {
    _lastTimeUnit = TimeUnit.nonExistent;
  }

  Number decrease(Number amount) {
    assert(amount.isNonNegative());
    return accumulate(-amount);
  }
}
