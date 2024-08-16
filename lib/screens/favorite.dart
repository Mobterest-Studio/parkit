import 'package:flutter/material.dart';
import '../constants/config.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final TextEditingController searchController = TextEditingController();

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
                onChanged: (value) {},
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
          Container(
              height: MediaQuery.of(context).size.height * 0.68,
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: const Text(
                      "Downtown Plaza",
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      "123 Main St, New York, NY 10001",
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.remove_circle,
                        color: redColor,
                      ),
                      onPressed: () {},
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "/area");
                    },
                  );
                },
              ))
        ],
      ),
    );
  }
}
