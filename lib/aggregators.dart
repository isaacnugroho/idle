import 'package:idle/abstract_unit.dart';
import 'package:idle/number.dart';
import 'package:idle/time_unit.dart';

abstract class Aggregator extends AbstractUnit {
  final List<AbstractUnit> _sources;

  Aggregator(List<AbstractUnit>? sources) : _sources = (sources ?? []);

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
    return finalize(data);
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
    return finalize(data);
  }

  void addSource(AbstractUnit unit) {
    _sources.add(unit);
  }

  bool removeSource(AbstractUnit unit) {
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
