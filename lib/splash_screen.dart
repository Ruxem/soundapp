import 'package:flutter/material.dart';
import 'package:sound_app/pages/home_page.dart';
import 'package:sound_app/providers/bluetooth_controller.dart';

class SplashScreen extends StatefulWidget {
  final BluetoothController btController;

  const SplashScreen({required this.btController, Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(btController: widget.btController),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/wip_kutyanyakorv.png',
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Sound App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}