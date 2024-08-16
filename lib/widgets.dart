import 'package:flutter/material.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import 'package:supabase_carparking_app/screens/booking.dart';
import 'package:supabase_carparking_app/screens/home.dart';
import 'package:supabase_carparking_app/screens/profile.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int index;
  const CustomBottomNavigationBar({super.key, required this.index});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (selectedIndex == 0) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const Home(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } else if (selectedIndex == 1) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const Booking(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } else if (selectedIndex == 2) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const Profile(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const Home(),
          transitionDuration: const Duration(seconds: 0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      selectedIndex = widget.index;
    });
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: selectedIndex,
      selectedItemColor: brandColor,
      onTap: onItemTapped,
      unselectedFontSize: 10,
      selectedFontSize: 12,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      items: const [
        BottomNavigationBarItem(label: "Home", icon: Icon(Icons.home)),
        BottomNavigationBarItem(
            label: "Booking", icon: Icon(Icons.card_membership)),
        BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person))
      ],
    );
  }
}
