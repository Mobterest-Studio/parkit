import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import 'package:supabase_carparking_app/constants/constant.dart';
import 'package:supabase_carparking_app/provider/supabase_provider.dart';
import 'package:supabase_carparking_app/repository/parking_repository.dart';
import 'package:supabase_carparking_app/screens/favorite.dart';
import 'package:supabase_carparking_app/screens/login.dart';
import 'package:supabase_carparking_app/screens/notification.dart';
import 'package:supabase_carparking_app/widgets.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  static const routeName = '/profile';

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showIndicator = false;

  @override
  Widget build(BuildContext context) {
    final profileId = context.read<SupabaseProvider>().profileId;
    final userId = context.read<SupabaseProvider>().userId;

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
            FutureBuilder(
              future: ParkingRepository().getUserProfile(profileId),
              builder: (context, snapshot) {
                List<Map<String, dynamic>> response = snapshot.data ?? [];
                return Column(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          setState(() => showIndicator = true);
                          try {
                            await ParkingRepository().uploadProfile();
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          }
                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted) setState(() => showIndicator = false);
                          });
                        },
                        child: FutureBuilder(
                          future: ParkingRepository().downloadProfile(),
                          builder: (context, snapshot) {
                            String? image = snapshot.data;

                            return (image == null)
                                ? const Stack(children: [
                                    CircleAvatar(
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
                                        bottom: 0,
                                        right: -10,
                                        left: 50,
                                        child: Icon(
                                          Icons.add_circle,
                                          color: secondaryColor,
                                        ))
                                  ])
                                : Stack(children: [
                                    CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(image)),
                                    Positioned(
                                        bottom: -10,
                                        right: -10,
                                        child: IconButton(
                                          onPressed: () async {
                                            setState(
                                                () => showIndicator = true);
                                            try {
                                              await ParkingRepository()
                                                  .deleteProfile(image);
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Profile image deleted.")));
                                              }
                                            } catch (e) {
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            e.toString())));
                                              }
                                            }
                                            Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                              if (mounted) {
                                                setState(() =>
                                                    showIndicator = false);
                                              }
                                            });
                                          },
                                          icon: const CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: Icon(
                                              Icons.delete_forever,
                                              color: redColor,
                                            ),
                                          ),
                                        ))
                                  ]);
                          },
                        )),
                    Visibility(
                        visible: showIndicator,
                        child: const CircularProgressIndicator(
                          color: brandColor,
                          padding: EdgeInsets.only(top: 8.0),
                          strokeWidth: 1.0,
                        )),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (response.isEmpty) ? "" : response[0]['name'] ?? "",
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const Icon(
                            Icons.verified_user,
                            color: secondaryColor,
                          )
                        ],
                      ),
                    ),
                    Text(
                        (response.isEmpty)
                            ? ""
                            : response[0]['email_address'] ?? "",
                        style: const TextStyle(fontSize: 12)),
                  ],
                );
              },
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
                          child: FutureBuilder(
                            future: ParkingRepository().getMyVehicles(userId),
                            builder: (context, snapshot) {
                              List<Map<String, dynamic>> response =
                                  snapshot.data ?? [];

                              return (response.isEmpty)
                                  ? SizedBox(
                                      width: 300,
                                      child: EmptyWidget(
                                        image: null,
                                        packageImage: PackageImage.Image_1,
                                        title: appName,
                                        subTitle: 'No vehicles added yet',
                                        titleTextStyle: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        subtitleTextStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: response.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Text.rich(TextSpan(
                                          children: <InlineSpan>[
                                            WidgetSpan(
                                                child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Image.asset(appIcon),
                                            )),
                                            TextSpan(
                                              text: response[index]
                                                  ['car_number'],
                                            ),
                                          ],
                                        ));
                                      });
                            },
                          ));
                    });
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: brandColor),
              title: const Text("My Favourites", style: TextStyle(fontSize: 14)),
              trailing: const Icon(Icons.arrow_right),
              onTap: () => Navigator.pushNamed(context, Favorite.routeName),
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: brandColor),
              title:
                  const Text("Notifications", style: TextStyle(fontSize: 14)),
              trailing: const Icon(Icons.arrow_right),
              onTap: () => Navigator.pushNamed(context, Notifications.routeName),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await ParkingRepository().signOut();
                      if (!context.mounted) return;
                      Navigator.pushNamedAndRemoveUntil(
                          context, Login.routeName, (route) => false);
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sign out failed: $e')));
                    }
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
