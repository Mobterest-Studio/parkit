import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_carparking_app/screens/booking.dart';
import 'package:supabase_carparking_app/screens/favorite.dart';
import 'package:supabase_carparking_app/screens/notification.dart';
import 'package:supabase_carparking_app/screens/parking_details.dart';
import 'package:supabase_carparking_app/screens/parking_ticket.dart';
import 'package:supabase_carparking_app/screens/parking_timer.dart';
import 'package:supabase_carparking_app/screens/email_verification.dart';
import 'package:supabase_carparking_app/screens/profile.dart';
import 'package:supabase_carparking_app/screens/profile_signup.dart';
import 'package:supabase_carparking_app/screens/signup.dart';
import 'screens/home.dart';
import 'screens/login.dart';
import 'screens/parking_area.dart';
import 'screens/parking_lot.dart';

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black38)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black38),
            ),
          ),
          textTheme: Theme.of(context)
              .textTheme
              .apply(fontFamily: GoogleFonts.poppins().fontFamily)),
      initialRoute: "/",
      routes: {
        "/": (context) => const Login(),
        "/signup": (context) => const Signup(),
        "/emailVerification": (context) => const EmailVerification(),
        "/profilesignup": (context) => const ProfileSignUp(),
        "/area": (context) => const ParkingArea(),
        "/home": (context) => const Home(),
        "/details": (context) => const ParkingDetails(),
        "/lot": (context) => const ParkingLot(),
        "/booking": (context) => const Booking(),
        "/profile": (context) => const Profile(),
        "/parkingtimer": (context) => const ParkingTimer(),
        "/parkingticket": (context) => const ParkingTicket(),
        "/favorite": (context) => const Favorite(),
        "/notification": (context) => const Notifications()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
