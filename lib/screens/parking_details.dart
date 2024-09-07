import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import 'package:supabase_carparking_app/main.dart';
import 'package:supabase_carparking_app/models/parking_model.dart';
import 'package:supabase_carparking_app/repository/parking_repository.dart';
import 'package:supabase_carparking_app/screens/parking_lot.dart';
import '../arguments.dart';
import '../constants/constant.dart';

class ParkingDetails extends StatefulWidget {
  const ParkingDetails({super.key});

  @override
  State<ParkingDetails> createState() => _ParkingDetailsState();

  static const routeName = "/details";
}

class _ParkingDetailsState extends State<ParkingDetails> {
  double totalFee = 0;
  Map<String, dynamic>? dropdownValue;
  final TextEditingController durationController = TextEditingController();
  DateTime now = DateTime.now();
  String formattedDate = '01-01-2024';
  String entryTime = 'hh:mm a';
  String exitTime = 'hh:mm a';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('dd-MM-yyyy').format(now);
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        entryTime = DateFormat('hh:mm a').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    durationController.dispose();
    _timer?.cancel();
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
        title: const Text("Parking Details",
            style: TextStyle(
                fontSize: 15,
                color: secondaryColor,
                fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: [
                  const Text("Date: "),
                  Text(
                    formattedDate,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Row(
              children: [
                const Text("Entry Time: "),
                Text(entryTime,
                    style: const TextStyle(fontWeight: FontWeight.bold))
              ],
            ),
            Row(
              children: [
                const Text("Duration (hours): "),
                SizedBox(
                    width: 100,
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                      controller: durationController,
                      onChanged: (value) {
                        setState(() {
                          if (value.isNotEmpty && int.parse(value) < 8) {
                            DateTime time =
                                DateFormat('hh:mm a').parse(entryTime);
                            DateTime newTime =
                                time.add(Duration(hours: int.parse(value)));
                            exitTime = DateFormat('hh:mm a').format(newTime);
                            totalFee = double.parse(durationController.text) *
                                args.parkingarea['parking_fee'];
                          } else {
                            totalFee = 0;
                            exitTime = 'hh:MM a';
                          }
                        });
                      },
                    ))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  const Text("Exit Time: "),
                  Text(exitTime,
                      style: const TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
            FutureBuilder(
              future: ParkingRepository().getMyVehicles(context),
              builder: (context, snapshot) {
                List<Map<String, dynamic>> response = snapshot.data ?? [];

                if (response.isEmpty) {
                  return const SizedBox.shrink();
                } else {
                  dropdownValue = response.first;
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Text(
                          "Choose your vehicle",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DropdownButton(
                        value: dropdownValue,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        style: const TextStyle(color: secondaryColor),
                        items: response
                            .map<DropdownMenuItem<Map<String, dynamic>>>(
                                (Map<String, dynamic> value) {
                          return DropdownMenuItem<Map<String, dynamic>>(
                            value: value,
                            child: Text(value['car_number']),
                          );
                        }).toList(),
                        onChanged: (Map<String, dynamic>? value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                      ),
                    ],
                  );
                }
              },
            ),
            TextButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/profilesignup');
                },
                style: TextButton.styleFrom(foregroundColor: secondaryColor),
                icon: const Icon(Icons.add_circle),
                label: const Text(
                  "Add New Vehicle",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            Container(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              height: 100,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 236, 234, 234),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Total Parking Fee",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        "\$$totalFee",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                            fontSize: 24),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
              child: Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: (durationController.text.isEmpty ||
                            dropdownValue == null)
                        ? null
                        : () {
                            supabaseProvider.setParking(Parking(
                                parkingDate: formattedDate,
                                entryTime: entryTime,
                                durationInHours:
                                    int.parse(durationController.text),
                                exitTime: exitTime,
                                parkingArea: args.parkingarea,
                                userId: supabaseProvider.userId,
                                vehicleId: dropdownValue!['id'],
                                parkingSlotId: null));
                            Navigator.pushNamed(context, ParkingLot.routeName,
                                arguments: ParkingArguments(
                                    parkingarea: args.parkingarea));
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white,
                      fixedSize: const Size(200, 50),
                    ),
                    child: const Text("Proceed")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
