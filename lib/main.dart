import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart'; // ใช้ตัวนี้แทนเพื่อเลี่ยงบั๊ก Gradle

void main() => runApp(const OneMinuteApp());

class OneMinuteApp extends StatelessWidget {
  const OneMinuteApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.cyanAccent,
      ),
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
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  Timer? timer;
  bool isActive = false;

  void startTimer() {
    if (isActive) return;
    setState(() => isActive = true);
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        onTimerFinished();
      }
    });
  }

  void onTimerFinished() {
    stopTimer();
    // เล่นเสียงเตือนมาตรฐาน Android
    FlutterBeep.beep();
    // ถ้าต้องการเสียงยาวขึ้นสามารถเรียกซ้ำหรือใช้ FlutterBeep.playSysSound(AndroidSoundIDs.TONE_CDMA_PIP)
  }

  void stopTimer() {
    timer?.cancel();
    setState(() => isActive = false);
  }

  void resetTimer() {
    stopTimer();
    setState(() => seconds = maxSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("ONE MINUTE TIMER", 
            style: TextStyle(letterSpacing: 2, color: Colors.grey)),
          const SizedBox(height: 40),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 280,
                  height: 280,
                  child: CircularProgressIndicator(
                    value: seconds / maxSeconds,
                    strokeWidth: 10,
                    backgroundColor: Colors.white10,
                    color: seconds < 10 ? Colors.redAccent : Colors.cyanAccent,
                  ),
                ),
                Text('$seconds', 
                  style: const TextStyle(fontSize: 90, fontWeight: FontWeight.w200)),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton("START", startTimer, !isActive && seconds > 0),
              const SizedBox(width: 20),
              _buildButton("STOP", stopTimer, isActive),
              const SizedBox(width: 20),
              _buildButton("RESET", resetTimer, true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, VoidCallback onPressed, bool enabled) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white10,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(label),
    );
  }
}
