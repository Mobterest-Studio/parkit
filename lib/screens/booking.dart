import 'package:flutter/material.dart';
import 'package:supabase_carparking_app/constants/config.dart';

import '../constants/constant.dart';
import '../widgets.dart';

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
              child: RichText(
                text: const TextSpan(
                  text: 'Total Fee Paid: ',
                  style: TextStyle(color: Colors.black, fontSize: 13),
                  children: <TextSpan>[
                    TextSpan(
                        text: '\$200',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: secondaryColor)),
                  ],
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.68,
            child: ListView.separated(
                padding: const EdgeInsets.only(top: 22.0),
                shrinkWrap: true,
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return const Divider(indent: 50, endIndent: 20);
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.asset(appIcon),
                    onTap: () {
                      Navigator.pushNamed(context, "/parkingtimer");
                    },
                    title: const Text(
                      "Downtown Plaza",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    subtitle: const Text(
                      "2024-03-08 3:00pm - 4:00pm",
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: const Text(
                      "\$200",
                      style: TextStyle(
                          color: brandColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  );
                }),
          )
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        index: 1,
      ),
    );
  }
}
