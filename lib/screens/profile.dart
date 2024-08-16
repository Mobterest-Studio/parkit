import 'package:flutter/material.dart';

import '../constants/config.dart';
import '../constants/constant.dart';
import '../widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Image.asset(appIcon),
          title: const Text("Profile",
              style: TextStyle(
                  fontSize: 15,
                  color: secondaryColor,
                  fontWeight: FontWeight.w700)),
        ),
        body: Column(
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      backgroundColor: brandColor,
                      radius: 40,
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: secondaryColor,
                          size: 50,
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: -10,
                        right: -10,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.add_circle_rounded,
                            color: secondaryColor,
                          ),
                        ))
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "John Doe",
                        style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.verified_user,
                        color: secondaryColor,
                      )
                    ],
                  ),
                ),
                const Text("johndoe@gmail.com", style: TextStyle(fontSize: 12)),
              ],
            ),
            ListTile(
              leading: Image.asset(appIcon),
              title: const Text(
                "My Vehicles",
                style: TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          padding: const EdgeInsets.only(top: 10, left: 20),
                          child: ListView.builder(
                              itemCount: 4,
                              itemBuilder: (BuildContext context, int index) {
                                return Text.rich(TextSpan(
                                  children: <InlineSpan>[
                                    WidgetSpan(
                                        child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Image.asset(appIcon),
                                    )),
                                    const TextSpan(
                                      text: "4X456PSD",
                                    ),
                                  ],
                                ));
                              }));
                    });
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.favorite,
                color: brandColor,
              ),
              title: const Text(
                "My Favourites",
                style: TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.pushNamed(context, "/favorite");
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.notifications,
                color: brandColor,
              ),
              title: const Text(
                "Notifications",
                style: TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.pushNamed(context, "/notification");
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/");
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      foregroundColor: Colors.white),
                  child: const Text("Log out")),
            )
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(index: 2));
  }
}
