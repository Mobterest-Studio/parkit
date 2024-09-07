import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import 'package:supabase_carparking_app/main.dart';
import 'package:supabase_carparking_app/repository/parking_repository.dart';
import '../arguments.dart';
import '../constants/constant.dart';
import '../models/parking_model.dart';

class ParkingLot extends StatefulWidget {
  const ParkingLot({super.key});

  @override
  State<ParkingLot> createState() => _ParkingLotState();

  static const routeName = "/lot";
}

class _ParkingLotState extends State<ParkingLot> {
  List<Color> floorColors = [];
  List<Map<String, dynamic>> slots = [];
  List<Color> slotColor = [];
  Map<String, dynamic> selectedSlot = {};

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
        title: const Text("Parking Lot",
            style: TextStyle(
                fontSize: 15,
                color: secondaryColor,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                args.parkingarea['name'],
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Icon(Icons.map),
                  Text(
                    args.parkingarea['location_text'],
                    style: const TextStyle(fontSize: 13),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Choose your parking slot",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                  height: 100,
                  child: FutureBuilder(
                    future: ParkingRepository()
                        .getFloorsByParkingLot(context, args.parkingarea['id']),
                    builder: (context, snapshot) {
                      List<Map<String, dynamic>> response = snapshot.data ?? [];

                      if (response.isEmpty) {
                        return SizedBox(
                          width: 300,
                          child: EmptyWidget(
                            image: null,
                            packageImage: PackageImage.Image_1,
                            title: appName,
                            subTitle: 'No floors available yet',
                            titleTextStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            subtitleTextStyle: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                        );
                      } else {
                        return ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            floorColors = List.generate(
                                response.length, (i) => secondaryColor);

                            return ActionChip(
                              label: Text(
                                response[index]['parkingfloor']['name'],
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: floorColors[index],
                              onPressed: () async {
                                slots = await ParkingRepository()
                                        .getSlotsbyParkingFloor(
                                            context,
                                            response[index]['parkingfloor']
                                                ['id'],
                                            args.parkingarea['id']) ??
                                    [];
                                slotColor = List.generate(
                                    slots.length, (i) => Colors.white);
                                setState(() {});
                              },
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              width: 10,
                            );
                          },
                          itemCount: response.length,
                        );
                      }
                    },
                  )),
              (slots.isEmpty)
                  ? Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 300,
                        child: EmptyWidget(
                          image: null,
                          packageImage: PackageImage.Image_1,
                          title: appName,
                          subTitle: 'Select your floor!',
                          titleTextStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                          subtitleTextStyle: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 2.0),
                      itemCount: slots.length,
                      itemBuilder: (BuildContext context, int slot) {
                        return (slots[slot]['availability'])
                            ? Card(
                                color: slotColor[slot],
                                child: InkWell(
                                  onTap: () {
                                    slotColor = List.generate(
                                        slots.length, (i) => Colors.white);
                                    setState(() {
                                      selectedSlot = slots[slot];
                                      slotColor[slot] = brandColor;
                                    });
                                  },
                                  child: Center(
                                      child: Text(
                                    slots[slot]['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                                ),
                              )
                            : Card(
                                color: Colors.white,
                                child: Center(
                                  child: Image.asset(appIcon),
                                ),
                              );
                      })
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ElevatedButton(
              onPressed: (selectedSlot.isEmpty)
                  ? null
                  : () async {
                      Parking parking = supabaseProvider.parking;
                      parking.parkingSlotId = selectedSlot['id'];

                      await ParkingRepository().saveParkingDetail(
                          context,
                          parking.parkingDate,
                          parking.entryTime,
                          parking.durationInHours,
                          parking.exitTime,
                          parking.parkingArea,
                          parking.vehicleId,
                          parking.parkingSlotId!);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                fixedSize: const Size(200, 50),
              ),
              child: Text((selectedSlot.isEmpty)
                  ? "Select Parking Slot"
                  : "Park Slot " + selectedSlot['name']))),
    );
  }
}
