
import 'package:test/test.dart';
import 'package:idle/number.dart';

void main() {
  test('test number 1', () {
    var aValue = Number.from(1000);
    expect(aValue.toString(), "1.00e3");
  });

  test('test number 2', () {
    var aValue = Number.from(1);
    expect(aValue.toString(), "1.0");
  });

  test('test number 3', () {
    var aValue = Number.from(23.456);
    expect(aValue.toString(), "23.5");
  });

  test('test number multiplication 1', () {
    var value1 = Number.from(9);
    var value2 = Number.from(9);
    expect(value1.mul(value2).toString(), "81.0");
  });

  test('test number division 1', () {
    var value1 = Number.from(90);
    var value2 = Number.from(2);
    expect(value1.div(value2).toString(), "45.0");
  });

  test('test number division 2', () {
    var value1 = Number.from(90);
    var value2 = Number.from(0);
    expect(() => value1.div(value2), throwsA(isA<UnsupportedError>()
        .having((p0) => p0.message, 'message', (v) => v == 'divide by zero')));
  });

  test('test number addition 1', () {
    var value1 = Number.from(90);
    var value2 = Number.zero;
    expect(value1.add(value2).toString(), "90.0");
  });

  test('test number addition 2', () {
    var value1 = Number.from(90);
    var value2 = Number.from(120000000.0);
    expect(value1.add(value2).toString(), "1.20e8");
  });

  test('test number addition 3', () {
    var value1 = Number.from(90);
    var value2 = Number.from(45.0);
    expect(value1.add(value2).toString(), "135.0");
  });

  test('test number addition 4', () {
    var value1 = Number.from(120000000.0);
    var value2 = Number.from(90);
    expect(value1.add(value2).toString(), "1.20e8");
  });

  test('test number subtraction 1', () {
    var value1 = Number.from(90);
    var value2 = Number.zero;
    expect(value1.sub(value2).toString(), "90.0");
  });

  test('test number subtraction 2', () {
    var value1 = Number.from(90);
    var value2 = Number.from(120000000.0);
    expect(value1.sub(value2).toString(), "-1.20e8");
  });

  test('test number subtraction 3', () {
    var value1 = Number.from(90);
    var value2 = Number.from(45.0);
    expect(value1.sub(value2).toString(), "45.0");
  });

  test('test number subtraction 4', () {
    var value1 = Number.from(120000000.0);
    var value2 = Number.from(90);
    expect(value1.sub(value2).toString(), "1.20e8");
  });

  test('test comparison 1', () {
    var value1 = Number.from(-1000.0);
    var value2 = Number.from(-10.0);
    expect(value1.compareTo(value2), -1);
  });

  test('test comparison 2', () {
    var value1 = Number.from(1000.0);
    var value2 = Number.from(10.0);
    expect(value1.compareTo(value2), 1);
  });

  test('test power 1', () {
    var value1 = Number.from(2.0);
    var value2 = Number.from(3.0);
    expect(value1.power(value2).toString(), "8.0");
  });

  test('test power 2', () {
    var value1 = Number.from(20000.0);
    var value2 = Number.from(3.0);
    expect(value1.power(value2).toString(), "8.00e12");
  });

  test('test power 3', () {
    var value1 = Number.from(400.0);
    var value2 = Number.from(0.5);
    expect(value1.power(value2).toString(), "20.0");
  });

  test('test power 4', () {
    var value1 = Number.from(400.0);
    var value2 = Number.from(-0.5);
    expect(value1.power(value2).toString(), "5.00e-2");
  });

  test('test power 5', () {
    var value1 = Number.from(1.0);
    var value2 = Number.from(-0.5);
    expect(value1.power(value2).toString(), "1.0");
  });

  test('test power 6', () {
    var value1 = Number.from(2.0);
    var value2 = Number.from(0.2);
    expect(value1.power(value2).toString(), "1.1");
  });

  test('test power 7', () {
    var value1 = Number.from(2.0);
    var value2 = Number.from(0.2);
    var value3 = Number.from(5.0);
    expect(value1.power(value2).power(value3).toString(), "2.0");
  });

  test('test power 8', () {
    var value1 = Number.from(100.0);
    var value2 = Number.from(10000);
    expect(value1.power(value2).toString(), "1.00e20000");
  });

  test('test log10 1', () {
    var value1 = Number.from(100.0);
    expect(value1.log10().toString(), "2.0");
  });

  test('test log10 2', () {
    var value1 = Number.from(400.0);
    expect(value1.log10().toString(), "2.6");
  });

  test('test log10 3', () {
    var value1 = Number.from(10.0);
    var value2 = Number.from(400.0);
    expect(value1.power(value2.log10()).toString(), value2.toString());
  });

}
