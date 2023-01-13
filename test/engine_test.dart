
import 'package:idle/constant.dart';
import 'package:idle/feedback.dart';
import 'package:idle/pulse.dart';
import 'package:idle/aggregators.dart';
import 'package:idle/time_unit.dart';
import 'package:idle/upgrade.dart';
import 'package:test/test.dart';
import 'package:idle/number.dart';

void main() {
  test('test pulse 1', () {
    var unit = Constant(Number.from(2));
    var pulse = Pulse(unit);
    var timeUnit = pulse.next(1);
    expect(timeUnit.scaledTime.toString(), "2.0");
  });

  test('test multiplier 1', () {
    var unit1 = Constant(Number.from(2));
    var unit2 = Constant(Number.from(4));
    var multiplier = Product([unit1, unit2]);
    var delta = Number.from(5);
    var timeUnit = TimeUnit(timestamp: 5, deltaEpoch: delta, scaledTime: delta);
    var result = multiplier.tick(timeUnit);
    expect(result.toString(), "8.0");
  });

  test('test accumulator 1', () {
    var unit1 = Constant(Number.from(2));
    var unit2 = Constant(Number.from(4));
    var accumulator = Sum([unit1, unit2]);
    var delta = Number.from(5);
    var timeUnit = TimeUnit(timestamp: 5, deltaEpoch: delta, scaledTime: delta);
    var result = accumulator.tick(timeUnit);
    expect(result.toString(), "6.0");
  });

  test('test feedback 1', () {
    var resource = Constant(Number.from(2));
    var multiplier = Constant(Number.from(0.5));
    var feedback = Feedback(resource, multiplier);
    expect(feedback.getCurrentAmount().toString(), "0.0");
    var delta = Number.from(5);
    var timeUnit1 = TimeUnit(timestamp: 5, deltaEpoch: delta, scaledTime: delta);
    var result1 = feedback.tick(timeUnit1);
    expect(result1.toString(), "2.0");
    var timeUnit2 = TimeUnit(timestamp: 10, deltaEpoch: delta, scaledTime: delta);
    var result2 = feedback.tick(timeUnit2);
    expect(result2.toString(), "3.0");
    var timeUnit3 = TimeUnit(timestamp: 15, deltaEpoch: delta, scaledTime: delta);
    var result3 = feedback.tick(timeUnit3);
    expect(result3.toString(), "3.5");
    var result4 = feedback.tick(timeUnit3);
    expect(result4.toString(), "3.5");
  });

  test('test upgrade 1', () {
    var unit = Upgrade(Number.two, Number.ten, Number.from(100), false);
    unit.setAmount(Number.from(200.0));
    var delta = Number.one;
    expect(unit.getCurrentAmount().toString(), "200.0");
    unit.buyUpgrade(unit);
    // expect(unit.getCurrentAmount().toString(), "190.0");
    // var timeUnit1 = TimeUnit(timestamp: 1, deltaEpoch: delta, scaledTime: delta);
    // unit.tick(timeUnit1);
    expect(unit.getCurrentAmount().toString(), "190.0");
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    unit.buyUpgrade(unit);
    var timeUnit2 = TimeUnit(timestamp: 2, deltaEpoch: delta, scaledTime: delta);
    unit.tick(timeUnit2);
    expect(unit.getCurrentAmount().toString(), "92.0");
  });

}
