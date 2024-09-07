import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:supabase_carparking_app/arguments.dart';
import 'package:supabase_carparking_app/repository/parking_repository.dart';
import 'package:supabase_carparking_app/screens/parking_area.dart';
import '../constants/config.dart';
import '../constants/constant.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final TextEditingController searchController = TextEditingController();
  bool search = false;
  List<Map<String, dynamic>> searchList = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Favourites",
            style: TextStyle(
                fontSize: 15,
                color: secondaryColor,
                fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8.0),
              width: MediaQuery.of(context).size.width * 0.9,
              child: TextField(
                controller: searchController,
                onChanged: (value) async {
                  if (value.isEmpty) {
                    search = false;
                  } else {
                    search = true;
                    searchList = await ParkingRepository()
                            .searchFavourite(context, value) ??
                        [];
                  }
                  setState(() {});
                },
                decoration: InputDecoration(
                    hintText: "Search parking area",
                    hintStyle: const TextStyle(fontSize: 13),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: secondaryColor, width: 1.0),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: brandColor, width: 2.0),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: secondaryColor,
                      size: 20,
                    )),
              ),
            ),
          ),
          (search)
              ? Container(
                  height: MediaQuery.of(context).size.height * 0.68,
                  padding: const EdgeInsets.all(10.0),
                  child: (searchList.isEmpty)
                      ? SizedBox(
                          width: 300,
                          child: EmptyWidget(
                            image: null,
                            packageImage: PackageImage.Image_1,
                            title: appName,
                            subTitle: 'No favourites available yet',
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
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                searchList[index]['name'],
                                style: const TextStyle(
                                    color: secondaryColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                searchList[index]['location_text'],
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: redColor,
                                ),
                                onPressed: () {
                                  ParkingRepository().removeFavourite(
                                      context, searchList[index]['id']);
                                  setState(() {});
                                },
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ParkingArea.routeName,
                                    arguments: ParkingArguments(
                                        parkingarea: searchList[index]
                                            ['parkingarea']));
                              },
                            );
                          },
                        ))
              : Container(
                  height: MediaQuery.of(context).size.height * 0.68,
                  padding: const EdgeInsets.all(10.0),
                  child: FutureBuilder(
                    future: ParkingRepository().getMyFavorites(context),
                    builder: (context, snapshot) {
                      List<Map<String, dynamic>> response = snapshot.data ?? [];

                      return (response.isEmpty)
                          ? SizedBox(
                              width: 300,
                              child: EmptyWidget(
                                image: null,
                                packageImage: PackageImage.Image_1,
                                title: appName,
                                subTitle: 'No favourites available yet',
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
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: response.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    response[index]['name'],
                                    style: const TextStyle(
                                        color: secondaryColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    response[index]['location_text'],
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: redColor,
                                    ),
                                    onPressed: () {
                                      ParkingRepository().removeFavourite(
                                          context, response[index]['id']);
                                      setState(() {});
                                    },
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, ParkingArea.routeName,
                                        arguments: ParkingArguments(
                                            parkingarea: response[index]
                                                ['parkingarea']));
                                  },
                                );
                              },
                            );
                    },
                  ))
        ],
      ),
    );
  }
}
