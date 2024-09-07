import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import 'package:supabase_carparking_app/repository/parking_repository.dart';
import '../arguments.dart';
import '../constants/constant.dart';

class ParkingTicket extends StatefulWidget {
  const ParkingTicket({super.key});

  @override
  State<ParkingTicket> createState() => _ParkingTicketState();

  static const routeName = "/ticket";
}

class _ParkingTicketState extends State<ParkingTicket> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ParkingArguments;
    String formattedEntryTime = DateFormat('hh:mm a')
        .format(DateFormat('HH:mm').parse(args.parkingarea['entry_time']));
    String formattedExitTime = DateFormat('hh:mm a')
        .format(DateFormat('HH:mm').parse(args.parkingarea['exit_time']));

    double totalFee = args.parkingarea['parkingarea']['parking_fee'] *
        args.parkingarea['duration'];

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Image.asset(appIcon),
          )
        ],
        title: const Text("Parking Ticket",
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
              const Text(
                "Scan this on the scanner machine when you are in the parking lot",
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: PrettyQrView.data(
                    data: "Parking information",
                    decoration: const PrettyQrDecoration(
                      image: PrettyQrDecorationImage(
                        image: AssetImage(appIcon),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
              ),
              FutureBuilder(
                future: ParkingRepository().getSpecificVehicle(
                    context, args.parkingarea['vehicle_id']),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> response = snapshot.data ?? [];

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            response.isEmpty ? "" : response[0]['car_model'],
                            style: const TextStyle(
                                fontSize: 15, color: secondaryColor),
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Vehicle No.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Text(
                            response.isEmpty ? "" : response[0]['car_number'],
                            style: const TextStyle(
                                fontSize: 15, color: secondaryColor),
                          )
                        ],
                      )
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Parking Area",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        Text(
                          args.parkingarea['parkingarea']['name'],
                          style: const TextStyle(
                              fontSize: 15, color: secondaryColor),
                        )
                      ],
                    ),
                    FutureBuilder(
                      future: ParkingRepository().getSpecificSlot(
                          context, args.parkingarea['parking_slot_id']),
                      builder: (context, snapshot) {
                        List<Map<String, dynamic>> response =
                            snapshot.data ?? [];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Parking Slot",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            Text(
                              response.isEmpty ? "" : response[0]['name'],
                              style: const TextStyle(
                                  fontSize: 15, color: secondaryColor),
                            )
                          ],
                        );
                      },
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Time",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(
                      "$formattedEntryTime - $formattedExitTime",
                      style:
                          const TextStyle(fontSize: 15, color: secondaryColor),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Duration",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        Text(
                          "${args.parkingarea['duration']} Hours",
                          style: const TextStyle(
                              fontSize: 15, color: secondaryColor),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13)),
                        Text(
                          args.parkingarea['parking_date'],
                          style: const TextStyle(
                              fontSize: 15, color: secondaryColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    const Text(
                      "Total Parking Fee",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: secondaryColor),
                    ),
                    Text(
                      "\$$totalFee",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
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
              child: const Text("Done"))),
    );
  }
}
