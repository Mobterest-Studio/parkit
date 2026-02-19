import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_carparking_app/constants/constant.dart';
import 'package:supabase_carparking_app/screens/email_verification.dart';
import 'package:supabase_carparking_app/screens/home.dart';

class FlutterAuthUI extends StatefulWidget {
  const FlutterAuthUI({super.key});

  static const routeName = '/flutterauthui';

  @override
  State<FlutterAuthUI> createState() => _FlutterAuthUIState();
}

class _FlutterAuthUIState extends State<FlutterAuthUI> {
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
            const Text(
              appName,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        bottomOpacity: 0.0,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 15.0),
                child: Text(
                  "Welcome back!",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text("Let’s get you parking."),
              ),
              // Create a Email sign-in/sign-up form
              SupaEmailAuth(
                redirectTo: kIsWeb ? null : 'io.mydomain.myapp://callback',
                onSignInComplete: (response) {
                  Navigator.pushNamed(context, Home.routeName);
                },
                onSignUpComplete: (response) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmailVerification(
                        emailAddress: response.user!.email!,
                      ),
                    ),
                  );
                },
                onPasswordResetEmailSent: () {
                  Navigator.pushNamed(context, "/resetPassword");
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Text(
                  "or",
                ),
              ),
              SupaSocialsAuth(
                socialProviders: [
                  OAuthProvider.google,
                  OAuthProvider.facebook,
                ],
                colored: true,
                redirectUrl:
                    kIsWeb ? null : 'io.supabase.flutter://reset-callback/',
                onSuccess: (Session response) {
                  // do something, for example: navigate('home');
                },
                onError: (error) {
                  // do something, for example: navigate("wait_for_email");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
