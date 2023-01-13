import 'package:idle/abstract_unit.dart';
import 'package:idle/aggregators.dart';
import 'package:idle/constant.dart';
import 'package:idle/number.dart';
import 'package:idle/time_unit.dart';

class Linear extends AbstractUnit {
  final Sum _multipliers = Sum([]);
  final Sum _externalSources = Sum([]);
  final Constant _source;

  Linear(this._source);

  @override
  Number unitInit() {
    return _source.init();
  }

  @override
  Number unitTick(TimeUnit timeUnit) {
    var sources = _source.tick(timeUnit) + _externalSources.tick(timeUnit);
    var produce = timeUnit.scaledTime * sources * _multipliers.tick(timeUnit);
    return getCurrentAmount() + produce;
  }

  Sum get multipliers => _multipliers;
  Sum get externalSources => _externalSources;
  Constant get source => _source;
}
