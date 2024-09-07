import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:supabase_carparking_app/arguments.dart';
import 'package:supabase_carparking_app/repository/parking_repository.dart';
import 'package:supabase_carparking_app/screens/parking_details.dart';
import '../constants/config.dart';
import '../constants/constant.dart';

class ParkingArea extends StatefulWidget {
  const ParkingArea({super.key});

  @override
  State<ParkingArea> createState() => _ParkingAreaState();

  static const routeName = "/area";
}

class _ParkingAreaState extends State<ParkingArea> {
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
        title: const Text("Parking Area",
            style: TextStyle(
                fontSize: 15,
                color: secondaryColor,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                args.parkingarea['name'],
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "\$${args.parkingarea['parking_fee']}/hr",
                  style: const TextStyle(
                    fontSize: 16,
                    color: brandColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
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
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.share_location),
                    Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: FutureBuilder(
                          future: ParkingRepository().getAvailableSlots(
                              context, args.parkingarea['id']),
                          builder: (context, snapshot) {
                            int availableSlots = snapshot.data ?? 0;

                            return Text(
                              "$availableSlots Slots available",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: secondaryColor),
                            );
                          },
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    RatingBar.builder(
                      initialRating: args.parkingarea['rating'],
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemSize: 20,
                      onRatingUpdate: (rating) {},
                    ),
                    Text(
                      args.parkingarea['rating'].toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: secondaryColor),
                    )
                  ],
                ),
              ),
              CarouselSlider.builder(
                  options: CarouselOptions(
                      height: 300.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10)),
                  itemCount: images.length,
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              images[itemIndex],
                              height: MediaQuery.of(context).size.height * 0.3,
                            ),
                          ],
                        ),
                      )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor,
                          foregroundColor: Colors.white),
                      label: const Text("Share")),
                  OutlinedButton.icon(
                      onPressed: () async {
                        await ParkingRepository()
                            .saveAsFavorite(args.parkingarea['id'], context);
                      },
                      style: OutlinedButton.styleFrom(
                          foregroundColor: secondaryColor),
                      icon: const Icon(Icons.favorite),
                      label: const Text("Save"))
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Text(
                args.parkingarea['location_description'],
                textAlign: TextAlign.justify,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 8.0),
                child: Text(
                  "Amenities",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: secondaryColor),
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: args.parkingarea['amenities'].length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          args.parkingarea['amenities'][index],
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(30.0),
        child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, ParkingDetails.routeName,
                  arguments: ParkingArguments(parkingarea: args.parkingarea));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
              fixedSize: const Size(200, 50),
            ),
            child: const Text("Proceed")),
      ),
    );
  }
}
