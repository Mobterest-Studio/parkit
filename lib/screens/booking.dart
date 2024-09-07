import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_carparking_app/arguments.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import 'package:supabase_carparking_app/repository/parking_repository.dart';

import '../constants/constant.dart';
import '../widgets.dart';
import 'parking_timer.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(appIcon),
        title: const Text("Booking",
            style: TextStyle(
                fontSize: 15,
                color: secondaryColor,
                fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 20.0),
              child: FutureBuilder(
                future: ParkingRepository().getTotalFee(context),
                builder: (context, snapshot) {
                  double response = snapshot.data ?? 0;

                  return RichText(
                    text: TextSpan(
                      text: 'Total Fee Paid: ',
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                      children: <TextSpan>[
                        TextSpan(
                            text: '\$$response',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: secondaryColor)),
                      ],
                    ),
                  );
                },
              )),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.68,
              child: FutureBuilder(
                future: ParkingRepository().getAllBookings(context),
                builder: (context, snapshot) {
                  List<Map<String, dynamic>> response = snapshot.data ?? [];

                  return (response.isEmpty)
                      ? SizedBox(
                          width: 300,
                          child: EmptyWidget(
                            image: null,
                            packageImage: PackageImage.Image_1,
                            title: appName,
                            subTitle: 'No bookings made yet',
                            titleTextStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            subtitleTextStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.only(top: 22.0),
                          shrinkWrap: true,
                          itemCount: response.length,
                          separatorBuilder: (context, index) {
                            return const Divider(indent: 50, endIndent: 20);
                          },
                          itemBuilder: (context, index) {
                            String formattedParkingDate = DateFormat('d MMM')
                                .format(DateFormat('yyyy-dd-MM')
                                    .parse(response[index]['parking_date']));

                            String formattedEntryTime = DateFormat('hh:mm a')
                                .format(DateFormat('HH:mm')
                                    .parse(response[index]['entry_time']));
                            String formattedExitTime = DateFormat('hh:mm a')
                                .format(DateFormat('HH:mm')
                                    .parse(response[index]['exit_time']));

                            return ListTile(
                              leading: Image.asset(appIcon),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ParkingTimer.routeName,
                                    arguments: ParkingArguments(
                                        parkingarea: response[index]));
                              },
                              title: Text(
                                response[index]['parkingarea']['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                              subtitle: Text(
                                "$formattedParkingDate $formattedEntryTime - $formattedExitTime",
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Text(
                                "\$${response[index]['parkingarea']['parking_fee']}",
                                style: const TextStyle(
                                    color: brandColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            );
                          });
                },
              ))
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 1,
      ),
    );
  }
}
