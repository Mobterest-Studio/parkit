import 'package:flutter/material.dart';

import '../constants/config.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications",
            style: TextStyle(
                fontSize: 15,
                color: secondaryColor,
                fontWeight: FontWeight.w700)),
      ),
      body: ListView.separated(
        itemCount: 4,
        itemBuilder: (context, index) {
          return const ListTile(
            leading: Icon(
              Icons.timer,
              color: brandColor,
            ),
            title: Text(
              "Booking Confirmed",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Your parking spot at X mall is confirmed for 29-07-2024 from 12:00 pm to 3:00 pm",
              style: TextStyle(fontSize: 13),
            ),
            trailing: Text(
              "Today",
              style: TextStyle(color: secondaryColor),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            indent: 50,
            endIndent: 20,
          );
        },
      ),
    );
  }
}
