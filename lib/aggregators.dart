import 'package:idle/units.dart';
import 'package:idle/number.dart';
import 'package:idle/time_unit.dart';

abstract class Aggregator extends TickerUnit {
  final List<TickerUnit> _sources;

  Aggregator(List<TickerUnit>? sources)
      : _sources = (sources ?? []),
        super(false);

  AggregateData initIterator();

  bool iterate(AggregateData aggregateData, Number value);

  Number finalize(AggregateData aggregateData) {
    return aggregateData.result;
  }

  @override
  Number unitInit() {
    var data = initIterator();
    for (var source in _sources) {
      if (!iterate(data, source.init())) {
        break;
      }
      data.counter++;
    }
    return setValue(finalize(data));
  }

  @override
  Number unitTick(TimeUnit timeUnit) {
    var data = initIterator();
    for (var source in _sources) {
      if (!iterate(data, source.tick(timeUnit))) {
        break;
      }
      data.counter++;
    }
    return produce(finalize(data));
  }

  void addSource(TickerUnit unit) {
    _sources.add(unit);
  }

  bool removeSource(TickerUnit unit) {
    return _sources.remove(unit);
  }
}

class AggregateData {
  Number result;
  int counter = 0;

  AggregateData(Number? initValue) : result = initValue ?? Number.zero;
}

class Sum extends Aggregator {
  Sum(super.sources);

  @override
  AggregateData initIterator() {
    return AggregateData(Number.zero);
  }

  @override
  bool iterate(AggregateData aggregateData, Number value) {
    aggregateData.result += value;
    return true;
  }
}

class Product extends Aggregator {
  Product(super.sources);

  @override
  AggregateData initIterator() {
    return AggregateData(Number.one);
  }

  @override
  bool iterate(AggregateData aggregateData, Number value) {
    aggregateData.result *= value;
    return !aggregateData.result.isZero();
  }
}

class Min extends Aggregator {
  Min(super.sources);

  @override
  AggregateData initIterator() {
    return AggregateData(Number.zero);
  }

  @override
  bool iterate(AggregateData aggregateData, Number value) {
    if (aggregateData.counter == 0
        || aggregateData.result.compareTo(value) < 0) {
      aggregateData.result = value;
    }
    return true;
  }
}

class Max extends Aggregator {
  Max(super.sources);

  @override
  AggregateData initIterator() {
    return AggregateData(Number.zero);
  }

  @override
  bool iterate(AggregateData aggregateData, Number value) {
    if (aggregateData.counter == 0
        || aggregateData.result.compareTo(value) > 0) {
      aggregateData.result = value;
    }
    return true;
  }
}
