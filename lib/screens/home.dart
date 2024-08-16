import 'package:flutter/material.dart';
import '../constants/config.dart';
import '../constants/constant.dart';
import '../widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(appIcon),
              ),
              const Text(appName,
                  style: TextStyle(
                      fontSize: 15,
                      color: brandColor,
                      fontWeight: FontWeight.w700))
            ],
          ),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 8.0),
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
                        borderSide:
                            BorderSide(color: secondaryColor, width: 1.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: brandColor, width: 2.0),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: brandColor,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.clear,
                            color: secondaryColor,
                            size: 20,
                          ))),
                ),
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.68,
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
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
                      trailing: const Icon(
                        Icons.keyboard_arrow_right,
                        color: secondaryColor,
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "/area");
                      },
                    );
                  },
                ))
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(
          index: 0,
        ));
  }
}
