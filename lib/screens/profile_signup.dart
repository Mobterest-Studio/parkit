import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_carparking_app/provider/supabase_provider.dart';
import 'package:supabase_carparking_app/repository/parking_repository.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import 'package:supabase_carparking_app/constants/constant.dart';
import 'package:supabase_carparking_app/screens/login.dart';

class ProfileSignUp extends StatefulWidget {
  const ProfileSignUp({super.key});

  static const routeName = '/profilesignup';

  @override
  State<ProfileSignUp> createState() => _ProfileSignUpState();
}

class _ProfileSignUpState extends State<ProfileSignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carNumberController = TextEditingController();
  final _profileFormKey = GlobalKey<FormState>();

  String dropdownValue = colors.first;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    carModelController.dispose();
    carNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // watch() subscribes to SupabaseProvider so the widget rebuilds whenever
    // signedIn changes (e.g. after sign-in completes).
    final provider = context.watch<SupabaseProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: (provider.signedIn) ? null : Image.asset(appIcon),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _profileFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Profile details",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                    fontSize: 16),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                  child: Column(
                    children: [
                      Visibility(
                          visible: !provider.signedIn,
                          child:
                              const Text("Set up your user and car profile")),
                      Visibility(
                          visible: provider.signedIn,
                          child: const Text("Set up your car profile"))
                    ],
                  )),
              Visibility(
                  visible: !provider.signedIn,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              hintText: "Enter Name",
                              hintStyle: TextStyle(fontSize: 13)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                        ),
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                            hintText: "Enter Phone Number",
                            hintStyle: TextStyle(fontSize: 13)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: GestureDetector(
                  onTap: () async {},
                  child: Container(
                    color: greyColor,
                    height: 100,
                    child: const Center(
                      child: Text("Click to upload car image"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextFormField(
                  controller: carModelController,
                  decoration: const InputDecoration(
                      hintText: "Enter Car Model",
                      hintStyle: TextStyle(fontSize: 13)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter car model';
                    }
                    return null;
                  },
                ),
              ),
              TextFormField(
                controller: carNumberController,
                decoration: const InputDecoration(
                    hintText: "Enter Car Number",
                    hintStyle: TextStyle(fontSize: 13)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter car number';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    const Text(
                      "Color of the Car",
                    ),
                    const Spacer(),
                    DropdownButton(
                      value: dropdownValue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      style: const TextStyle(color: secondaryColor),
                      items:
                          colors.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (!_profileFormKey.currentState!.validate()) return;
                          try {
                            if (!provider.signedIn) {
                              // New sign-up flow: create profile row first,
                              // get back the assigned id, then add the car.
                              final profileId = await ParkingRepository()
                                  .updateUserProfile(
                                      nameController.text,
                                      phoneController.text,
                                      carModelController.text,
                                      carNumberController.text,
                                      dropdownValue);
                              provider.setProfileId(profileId);
                              await ParkingRepository().addCarProfile(
                                  carModelController.text,
                                  carNumberController.text,
                                  dropdownValue,
                                  profileId);
                              if (!context.mounted) return;
                              Navigator.pushNamed(context, Login.routeName);
                            } else {
                              // Existing user adding another vehicle.
                              await ParkingRepository().addCarProfile(
                                  carModelController.text,
                                  carNumberController.text,
                                  dropdownValue,
                                  provider.profileId);
                              if (!context.mounted) return;
                              Navigator.pop(context);
                            }
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandColor,
                          fixedSize: const Size(100, 34),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: brandColor,
                          fixedSize: const Size(100, 34),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
