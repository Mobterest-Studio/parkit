import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:supabase_carparking_app/constants/constant.dart';
import 'package:supabase_carparking_app/repository/parking_repository.dart';

import '../constants/config.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _LoginState();
}

class _LoginState extends State<Signup> {
  final _signupFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
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
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text(
                    "Sign up to create account",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text("Let’s get you parking.")),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Form(
                      key: _signupFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Email"),
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 85, 84, 84)),
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email address';
                              }
                              return null;
                            },
                          ),
                          const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text("Password")),
                          TextFormField(
                            style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 85, 84, 84)),
                            controller: passController,
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_signupFormKey.currentState!.validate()) {
                                    await ParkingRepository().createAccount(
                                        emailController.text, context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: brandColor,
                                  foregroundColor: Colors.black,
                                  fixedSize: const Size(500, 34),
                                ),
                                child: const Text("Create account"),
                              )),
                        ],
                      ))),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Text(
                  "or",
                ),
              ),
              SizedBox(
                width: 500,
                height: 40,
                child: SignInButton(
                  Buttons.google,
                  text: "Sign in with Google",
                  elevation: 4.0,
                  shape: const StadiumBorder(),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                width: 500,
                height: 40,
                child: SignInButton(
                  Buttons.facebook,
                  elevation: 4.0,
                  text: "Sign in with Facebook",
                  shape: const StadiumBorder(),
                  onPressed: () {},
                ),
              ),
              const Spacer(),
              Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/");
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Already have an account? Sign in")))
            ],
          )),
    );
  }
}
