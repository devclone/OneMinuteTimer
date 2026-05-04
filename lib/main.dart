import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const TimerApp());

class TimerApp extends StatelessWidget {
  const TimerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const TimerHomePage(),
    );
  }
}

class TimerHomePage extends StatefulWidget {
  const TimerHomePage({super.key});
  @override
  State<TimerHomePage> createState() => _TimerHomePageState();
}

class _TimerHomePageState extends State<TimerHomePage> {
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void resetTimer() {
    stopTimer();
    setState(() => seconds = maxSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: CircularProgressIndicator(
                    value: seconds / maxSeconds,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[800],
                    color: Colors.cyanAccent,
                  ),
                ),
                Text('$seconds', style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: startTimer, child: const Text("START")),
                const SizedBox(width: 20),
                ElevatedButton(onPressed: stopTimer, child: const Text("STOP")),
                const SizedBox(width: 20),
                ElevatedButton(onPressed: resetTimer, child: const Text("RESET")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}