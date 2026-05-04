import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';

void main() => runApp(const OneMinuteApp());

class OneMinuteApp extends StatelessWidget {
  const OneMinuteApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const TimerPage(),
    );
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});
  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int seconds = 60;
  Timer? timer;
  bool isRunning = false;

  void toggleTimer() {
    if (isRunning) {
      timer?.cancel();
      setState(() => isRunning = false);
    } else {
      if (seconds == 0) seconds = 60;
      setState(() => isRunning = true);
      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (seconds > 0) {
          setState(() => seconds--);
        } else {
          t.cancel();
          setState(() => isRunning = false);
          FlutterBeep.beep(); // เสียงแจ้งเตือน
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$seconds", style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: toggleTimer,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
              child: Text(isRunning ? "STOP" : "START"),
            ),
            if (!isRunning)
              TextButton(onPressed: () => setState(() => seconds = 60), child: const Text("RESET"))
          ],
        ),
      ),
    );
  }
}