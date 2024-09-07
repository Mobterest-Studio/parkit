import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:supabase_carparking_app/screens/parking_ticket.dart';
import 'dart:async';

import '../arguments.dart';
import '../constants/config.dart';
import '../constants/constant.dart';

class ParkingTimer extends StatefulWidget {
  const ParkingTimer({super.key});

  @override
  State<ParkingTimer> createState() => _ParkingTimerState();

  static const routeName = "/timer";
}

class _ParkingTimerState extends State<ParkingTimer> {
  static const maxSeconds = 3661;
  int remainingSeconds = maxSeconds;
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ParkingArguments;

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(appIcon),
          )
        ],
        title: const Text("Parking Timer",
            style: TextStyle(
                fontSize: 15,
                color: secondaryColor,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              children: [
                const Text("Your parking session ends in"),
                Container(
                    width: 200.0,
                    height: 200.0,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: brandColor,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          formatTime(remainingSeconds),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "hours minutes seconds",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    )),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Scan this on the scanner machine when you are in the parking lot",
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  alignment: Alignment.center,
                  width: 180,
                  height: 180,
                  child: PrettyQrView.data(
                    data: "Parking information",
                    decoration: const PrettyQrDecoration(
                      image: PrettyQrDecorationImage(
                        image: AssetImage(appIcon),
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, ParkingTicket.routeName,
                          arguments:
                              ParkingArguments(parkingarea: args.parkingarea));
                    },
                    icon: const Icon(Icons.arrow_right),
                    iconAlignment: IconAlignment.end,
                    style:
                        TextButton.styleFrom(foregroundColor: secondaryColor),
                    label: const Text(
                      "View Details",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            )),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/home");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                fixedSize: const Size(200, 50),
              ),
              child: const Text("Finish"))),
    );
  }
}
