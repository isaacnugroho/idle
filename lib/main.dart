import 'dart:async';

import 'package:flutter/material.dart';
import 'package:idle/number.dart';
import 'package:idle/pulse.dart';
import 'package:idle/upgrade.dart';

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

class _HomePageState extends State<HomePage> {
  bool _isRunning = true;

  DateTime _lastTime = DateTime.now();
  final Pulse pulse = Pulse(null);
  final List<Upgrade> dimensions = [];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      var currentTime = DateTime.now();
      var delta = 0.001 * (currentTime.millisecondsSinceEpoch - _lastTime.millisecondsSinceEpoch);
      _lastTime = currentTime;
      var timeUnit = pulse.next(delta);
      dimensions[0].tick(timeUnit);
      _lastTime = currentTime;
    });
  }

  void _buy() {
    for (var element in dimensions) {
      element.buyUpgrade(dimensions[0]);
    }
  }

  @override
  void initState() {
    _lastTime = DateTime.now();
    var firstDimension = Upgrade(Number.ten, Number.ten, Number.ten, false);
    firstDimension.setAmount(Number.from(10));
    dimensions.add(firstDimension);
    var secondDimension = Upgrade(Number.ten, Number.from(100), Number.from(100), false);
    dimensions.add(secondDimension);
    firstDimension.externalSources.addSource(secondDimension);
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      if (!_isRunning) {
        // cancel the timer
        timer.cancel();
      }
      _incrementCounter();
    });
    super.initState();
  }

  String _format(double value) {
    if (value.isFinite) {
      if (value < 10000) {
        return value.toStringAsFixed(0);
      }
      return value.toStringAsExponential(4);
    }
    return '';
  }

  String _formatDimension(Upgrade value) {
    return "${value.id} ${value.getCurrentAmount().toString()} (${value.cost.toString()}) ${value.level} ${value.subLevel} ${value.source.getCurrentAmount().toString()}";
  }

  String _formatList(List<double> values) {
    return values.map((e) => _format(e)).join(", ");
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
              _formatDimension(dimensions[0]),
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              _formatDimension(dimensions[1]),
              style: Theme.of(context).textTheme.headline4,
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
