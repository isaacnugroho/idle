import 'dart:async';

import 'package:flutter/material.dart';
import 'package:idle/brokers.dart';
import 'package:idle/functions.dart';
import 'package:idle/number.dart';
import 'package:idle/pulse.dart';
import 'package:idle/units.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Idle',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Flutter Idle'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class DimensionHolder {
  final LinearAccumulator dimension;
  final LevelBuyer levelBuyer;

  DimensionHolder(this.dimension, this.levelBuyer);
}

class _HomePageState extends State<HomePage> {
  bool _isRunning = true;

  DateTime _lastTime = DateTime.now();
  final Pulse pulse = Pulse(null);
  final List<LevelBuyer> buyers = [];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      var currentTime = DateTime.now();
      var delta = 0.001 *
          (currentTime.millisecondsSinceEpoch -
              _lastTime.millisecondsSinceEpoch);
      _lastTime = currentTime;
      var timeUnit = pulse.next(delta);
      for (var element in buyers) {
        element.target.tick(timeUnit);
      }
      _lastTime = currentTime;
    });
  }

  void _buy() {
    for (int i = buyers.length; i > 0;) {
      var element = buyers[--i];
      var bought = element.buyUpgrade();
    }
  }

  @override
  void dispose() {
    _isRunning = false;
    super.dispose();
  }

  @override
  void initState() {
    _lastTime = DateTime.now();

    // 1 2 3 5 8 13 21 34
    var dimCostExp = [1, 2, 3, 5, 8, 13, 21, 34];
    var dimCostMulExp = [3, 4, 5, 7, 10, 15, 23, 36];
    for (int i = 0; i < 8; i++) {
      var source = TickerUnit();
      var dimension = LinearAccumulator(source,
          defaultMultiplier: TickerUnit.from(Number.one));
      var buyer = LevelBuyer(
          i == 0 ? dimension : buyers[0].target,
          dimension,
          10,
          Number.number(1, dimCostExp[i]),
          Number.number(1, dimCostMulExp[i]));
      buyers.add(buyer);
      if (i > 0) {
        buyers[i - 1].target.externalSources.addSource(dimension);
      }
    }
    for (int i = 1; i < 8; i++) {
      var gate =
          Gate(buyers[i], TickerUnit.from(Number.from(0.1)), Number.zero, 1);
      for (int j = 0; j < i; j++) {
        var multipliers = buyers[j].target.multipliers;
        multipliers.addSource(gate);
      }
    }
    buyers[0].target.setValue(Number.ten);
    Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      if (!_isRunning) {
        // cancel the timer
        timer.cancel();
      }
      _incrementCounter();
    });
    super.initState();
  }

  String _formatDimension(LevelBuyer holder) {
    return "${holder.target.id} x${holder.target.multipliers.value.toString()} ${holder.target.source.value.toString()} (${holder.cost.toString()})";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              buyers[0].target.value.toString(),
              style: Theme.of(context).textTheme.headline3,
            ),
            Row(
              children: [
                Text(
                  _formatDimension(buyers[0]),
                  style: Theme.of(context).textTheme.headline5,
                ),
                MaterialButton(onPressed: buyers[0].buyUpgrade),
              ],
            ),
            Row(
              children: [
                Text(
                  _formatDimension(buyers[1]),
                  style: Theme.of(context).textTheme.headline5,
                ),
                MaterialButton(onPressed: buyers[1].buyUpgrade),
              ],
            ),
            Row(
              children: [
                Text(
                  _formatDimension(buyers[2]),
                  style: Theme.of(context).textTheme.headline5,
                ),
                MaterialButton(onPressed: buyers[2].buyUpgrade),
              ],
            ),
            Row(
              children: [
                Text(
                  _formatDimension(buyers[3]),
                  style: Theme.of(context).textTheme.headline5,
                ),
                MaterialButton(onPressed: buyers[3].buyUpgrade),
              ],
            ),
            Row(
              children: [
                Text(
                  _formatDimension(buyers[4]),
                  style: Theme.of(context).textTheme.headline5,
                ),
                MaterialButton(onPressed: buyers[4].buyUpgrade),
              ],
            ),
            Row(
              children: [
                Text(
                  _formatDimension(buyers[5]),
                  style: Theme.of(context).textTheme.headline5,
                ),
                MaterialButton(onPressed: buyers[5].buyUpgrade),
              ],
            ),
            Row(
              children: [
                Text(
                  _formatDimension(buyers[6]),
                  style: Theme.of(context).textTheme.headline5,
                ),
                MaterialButton(onPressed: buyers[6].buyUpgrade),
              ],
            ),
            Row(
              children: [
                Text(
                  _formatDimension(buyers[7]),
                  style: Theme.of(context).textTheme.headline5,
                ),
                MaterialButton(onPressed: buyers[7].buyUpgrade),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buy,
        tooltip: 'Buy',
        child: const Icon(Icons.add),
      ),
    );
  }
}
