import 'package:idle/aggregators.dart';
import 'package:idle/units.dart';
import 'package:idle/number.dart';
import 'package:idle/time_unit.dart';


class LinearAccumulator extends _Linear {
  LinearAccumulator(TickerUnit source, {TickerUnit? defaultMultiplier}) : super(source, defaultMultiplier ?? TickerUnit.from(Number.zero), true);
}

class LinearFunction extends _Linear {
  LinearFunction(TickerUnit source, {TickerUnit? defaultMultiplier}) : super(source, defaultMultiplier ?? TickerUnit.from(Number.zero), false);
}

class _Linear extends TickerUnit {
  final Sum _multipliers = Sum([]);
  final Sum _externalSources = Sum([]);
  final TickerUnit _source;
  final TickerUnit _defaultMultiplier;

  _Linear(this._source, this._defaultMultiplier, bool isAccumulator)
      : super(isAccumulator) {
    _multipliers.addSource(_defaultMultiplier);
  }

  @override
  Number unitInit() {
    return _source.init();
  }

  @override
  Number unitTick(TimeUnit timeUnit) {
    var sources = _source.tick(timeUnit) + _externalSources.tick(timeUnit);
    var product = timeUnit.scaledTime * sources * _multipliers.tick(timeUnit);
    return produce(product);
  }

  Sum get multipliers => _multipliers;
  Sum get externalSources => _externalSources;
  TickerUnit get source => _source;
  TickerUnit get defaultMultiplier => _defaultMultiplier;
}
