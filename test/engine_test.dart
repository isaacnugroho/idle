
import 'package:idle/brokers.dart';
import 'package:idle/functions.dart';
import 'package:idle/units.dart';
import 'package:idle/feedback.dart';
import 'package:idle/pulse.dart';
import 'package:idle/aggregators.dart';
import 'package:idle/time_unit.dart';
import 'package:idle/upgrade.dart';
import 'package:test/test.dart';
import 'package:idle/number.dart';

void main() {
  test('test pulse 1', () {
    var unit = TickerUnit.from(Number.from(2));
    var pulse = Pulse(unit);
    var timeUnit = pulse.next(1);
    expect(timeUnit.scaledTime.toString(), "2.0");
  });

  test('test multiplier 1', () {
    var unit1 = TickerUnit.from(Number.from(2));
    var unit2 = TickerUnit.from(Number.from(4));
    var product = Product([unit1, unit2]);
    var delta = 1.0;
    var timeUnit = TimeUnit(
        timestamp: 5, deltaEpoch: delta, scaledTime: Number.from(delta));
    var result = product.tick(timeUnit);
    expect(result.toString(), "8.0");
  });

  test('test accumulator 1', () {
    var unit1 = TickerUnit.from(Number.from(2));
    var unit2 = TickerUnit.from(Number.from(4));
    var accumulator = Sum([unit1, unit2]);
    var delta = 1.0;
    var timeUnit = TimeUnit(
        timestamp: 5, deltaEpoch: delta, scaledTime: Number.from(delta));
    var result = accumulator.tick(timeUnit);
    expect(result.toString(), "6.0");
  });

  test('test feedback 1', () {
    var resource = TickerUnit.from(Number.from(2));
    var multiplier = TickerUnit.from(Number.from(0.5));
    var feedback = Feedback(resource, multiplier);
    expect(feedback.value.toString(), "0.0");
    var delta = 5.0;
    var timeUnit1 = TimeUnit(
        timestamp: 5, deltaEpoch: delta, scaledTime: Number.from(delta));
    var result1 = feedback.tick(timeUnit1);
    expect(result1.toString(), "2.0");
    var timeUnit2 = TimeUnit(
        timestamp: 10, deltaEpoch: delta, scaledTime: Number.from(delta));
    var result2 = feedback.tick(timeUnit2);
    expect(result2.toString(), "3.0");
    var timeUnit3 = TimeUnit(
        timestamp: 15, deltaEpoch: delta, scaledTime: Number.from(delta));
    var result3 = feedback.tick(timeUnit3);
    expect(result3.toString(), "3.5");
    var result4 = feedback.tick(timeUnit3);
    expect(result4.toString(), "3.5");
  });

  test('test upgrade 1', () {
    var unit = Upgrade(10, Number.ten, Number.from(100));
    unit.setValue(Number.from(200.0));
    expect(unit.value.toString(), "200.0");
    unit.buyUpgrade(unit);
    expect(unit.value.toString(), "190.0");
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    var delta = 1.0;
    var timeUnit = TimeUnit(
        timestamp: 1, deltaEpoch: delta, scaledTime: Number.from(delta));
    unit.tick(timeUnit);
    expect(unit.value.toString(), "120.0");
    expect(unit.source.value.toString(), "10.0");
  });

  test('test gate 1', () {
    final List<LevelBuyer> buyers = [];
    final List<Gate> gates = [];
    for (int i = 0; i < 8; i++) {
      var source = TickerUnit();
      var dimension = LinearAccumulator(source,
          defaultMultiplier: TickerUnit.from(Number.one));
      var buyer = LevelBuyer(
          i == 0 ? dimension : buyers[0].target,
          dimension,
          10,
          Number.number(1, 1),
          Number.number(1, 1));
      buyers.add(buyer);
      if (i > 0) {
        buyers[i - 1].target.externalSources.addSource(dimension);
      }
    }
    for (int i = 1; i < 8; i++) {
      var gate =
      Gate(buyers[i], TickerUnit.from(Number.from(0.1)), Number.zero, 1);
      gates.add(gate);
      for (int j = 0; j < i; j++) {
        var multipliers = buyers[j].target.multipliers;
        multipliers.addSource(gate);
      }
    }
    buyers[0].target.setValue(Number.number(1, 6));
    buyers[0].buyUpgrade();
    var timeUnit1 = const TimeUnit(timestamp: 1, deltaEpoch: 1, scaledTime: Number.one);
    for (var element in buyers) {
      element.target.tick(timeUnit1);
    }
    buyers[1].buyUpgrade();
    var timeUnit2 = const TimeUnit(timestamp: 2, deltaEpoch: 1, scaledTime: Number.one);
    for (var element in buyers) {
      element.target.tick(timeUnit2);
    }
    for (var element in gates) {
      element.tick(timeUnit2);
    }
    expect(gates[0].value.toString(), "0.10");
    buyers[2].buyUpgrade();
    var timeUnit3 = const TimeUnit(timestamp: 3, deltaEpoch: 1, scaledTime: Number.one);
    for (var element in buyers) {
      element.target.tick(timeUnit3);
    }
    // for (var element in gates) {
    //   element.tick(timeUnit3);
    // }
    gates[1].tick(timeUnit3);
    expect(gates[1].value.toString(), "0.10");
  });
}
