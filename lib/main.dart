// All imports use the package path style for consistency.
// Relative imports (e.g. 'screens/home.dart') were mixed in previously —
// package paths are the Flutter convention and work correctly in all
// tooling (IDE navigation, barrel exports, etc.).
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import 'package:supabase_carparking_app/provider/supabase_provider.dart';
import 'package:supabase_carparking_app/screens/booking.dart';
import 'package:supabase_carparking_app/screens/favorite.dart';
import 'package:supabase_carparking_app/screens/flutter_auth_ui.dart';
import 'package:supabase_carparking_app/screens/home.dart';
import 'package:supabase_carparking_app/screens/login.dart';
import 'package:supabase_carparking_app/screens/notification.dart';
import 'package:supabase_carparking_app/screens/parking_area.dart';
import 'package:supabase_carparking_app/screens/parking_details.dart';
import 'package:supabase_carparking_app/screens/parking_lot.dart';
import 'package:supabase_carparking_app/screens/parking_ticket.dart';
import 'package:supabase_carparking_app/screens/parking_timer.dart';
import 'package:supabase_carparking_app/screens/profile.dart';
import 'package:supabase_carparking_app/screens/profile_signup.dart';
import 'package:supabase_carparking_app/screens/signup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Supabase persists sessions locally, so currentSession is non-null when
  // the user has previously signed in and the token is still valid. Checking
  // here lets us skip the login screen on app restart without an extra round
  // trip to the server.
  final session = Supabase.instance.client.auth.currentSession;
  final initialRoute = session != null ? Home.routeName : Login.routeName;

  runApp(
    // ChangeNotifierProvider registers SupabaseProvider with the widget tree
    // so any descendant can call context.watch<SupabaseProvider>() or
    // Provider.of<SupabaseProvider>(context) to read or react to state changes.
    // Previously supabaseProvider was a plain global — that meant state changes
    // could never trigger rebuilds in the UI.
    ChangeNotifierProvider(
      create: (_) => SupabaseProvider(),
      child: MainApp(initialRoute: initialRoute),
    ),
  );
}

// A getter rather than a stored variable so it is always resolved after
// Supabase.initialize() has run. A top-level variable would be lazily
// evaluated on first access which is safe in practice but less explicit.
// Other files that import main.dart can continue using `supabase` as before.
SupabaseClient get supabase => Supabase.instance.client;

class MainApp extends StatelessWidget {
  // initialRoute is computed in main() and passed in here so the widget
  // itself stays stateless and the auth-redirect logic lives in one place.
  final String initialRoute;

  const MainApp({super.key, required this.initialRoute});

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
        // GoogleFonts.poppinsTextTheme() builds the TextTheme directly from
        // the package without needing a BuildContext. The previous approach —
        // Theme.of(context).textTheme.apply(...) inside MaterialApp's own
        // build — is a chicken-and-egg problem: the context does not carry a
        // theme yet at that point.
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: initialRoute,
      routes: {
        // Each screen exposes a static routeName constant. Using the constant
        // here (and in every Navigator.pushNamed call) means a typo is a
        // compile-time error rather than a silent runtime failure with a blank
        // screen.
        Login.routeName: (context) => const Login(),
        Signup.routeName: (context) => const Signup(),
        ProfileSignUp.routeName: (context) => const ProfileSignUp(),
        ParkingArea.routeName: (context) => const ParkingArea(),
        Home.routeName: (context) => const Home(),
        ParkingDetails.routeName: (context) => const ParkingDetails(),
        ParkingLot.routeName: (context) => const ParkingLot(),
        Booking.routeName: (context) => const Booking(),
        Profile.routeName: (context) => const Profile(),
        ParkingTimer.routeName: (context) => const ParkingTimer(),
        ParkingTicket.routeName: (context) => const ParkingTicket(),
        Favorite.routeName: (context) => const Favorite(),
        Notifications.routeName: (context) => const Notifications(),
        FlutterAuthUI.routeName: (context) => const FlutterAuthUI(),
        // EmailVerification is intentionally absent from named routes because
        // it requires an emailAddress constructor argument. Navigate to it
        // with Navigator.push + MaterialPageRoute instead.
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
