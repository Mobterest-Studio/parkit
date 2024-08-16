import 'package:flutter/material.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import '../constants/constant.dart';

class ParkingLot extends StatefulWidget {
  const ParkingLot({super.key});

  @override
  State<ParkingLot> createState() => _ParkingLotState();
}

class _ParkingLotState extends State<ParkingLot> {
  @override
  Widget build(BuildContext context) {
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
              const Text(
                "Downtown Plaza",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const Row(
                children: [
                  Icon(Icons.map),
                  Text(
                    "123 Main St, New York, NY 10001",
                    style: TextStyle(fontSize: 13),
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
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ActionChip(
                      label: const Text(
                        "Ground",
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: secondaryColor,
                      onPressed: () {},
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      width: 10,
                    );
                  },
                  itemCount: 2,
                ),
              ),
              GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 2.0),
                  itemCount: 6,
                  itemBuilder: (BuildContext context, int slot) {
                    return Card(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {},
                        child: Center(
                            child: Text(
                          "G$slot",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )),
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: Colors.white,
                fixedSize: const Size(200, 50),
              ),
              child: const Text("Select Parking Slot"))),
    );
  }
}
