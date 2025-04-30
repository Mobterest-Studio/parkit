import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import 'package:supabase_carparking_app/main.dart';
import 'package:supabase_carparking_app/repository/adapter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

import '../screens/email_verification.dart';

class ParkingRepository extends Adapter {
  @override
  Future addCarProfile(String carModel, String carNumber, String carColor,
      BuildContext context) async {
    try {
      final data = await supabase.from('vehicle').insert({
        'user_id': supabaseProvider.profileId,
        'car_model': carModel,
        'car_number': carNumber,
        'car_color': carColor
      }).select();

      if (data.isNotEmpty) {
        if (context.mounted) {
          if (supabaseProvider.signedIn) {
            Navigator.pop(context);
          } else {
            Navigator.pushNamed(context, "/");
          }
        }
      }
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));

            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred: $e")));
      }
    }
  }

  @override
  Future createAccount(
      String email, String password, BuildContext context) async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final User? user = res.user;

      if (context.mounted) {
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to create an account")));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailVerification(
                emailAddress: email,
              ),
            ),
          );
          //Navigator.pushNamed(context, "/emailVerification");
        }
      }
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));

            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));

            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred: $e")));
      }
    }
  }

  @override
  Future getAllBookings(BuildContext context) async {
    try {
      return await supabase
          .schema('parking')
          .from('parkingdetail')
          .select('*, parkingarea!inner(*)')
          .eq('user_id', supabaseProvider.userId)
          .order('id');
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future getAvailableSlots(BuildContext context, int parkingAreaId) async {
    try {
      final res = await supabase.functions
          .invoke('dynamic-worker', body: {'parking_area_id': parkingAreaId});
      final data = res.data;

      return data['count'];
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));

            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred: $e")));
      }
    }
  }

  @override
  Future getFloorsByParkingLot(BuildContext context, int parkingAreaId) async {
    try {
      return await supabase
          .schema('parking')
          .from('parkinglot')
          .select('id, parkingfloor!inner(*)')
          .eq('parking_area_id', parkingAreaId);
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future getMyFavorites(BuildContext context) async {
    try {
      return await supabase
          .from('favourite_parking_areas_view')
          .select('*')
          .eq('user_id', supabaseProvider.userId);
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMyNotifications() {
    // TODO: implement getMyNotifications
    throw UnimplementedError();
  }

  @override
  Future getMyVehicles(BuildContext context) async {
    try {
      return await supabase
          .from('vehicle')
          .select()
          .eq('user_id', supabaseProvider.userId);
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future getParkingareas(BuildContext context) async {
    try {
      return await supabase.schema('parking').from('parkingarea').select('*');
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future getSlotsbyParkingFloor(
      BuildContext context, int parkingFloorId, int parkingAreaId) async {
    try {
      return await supabase
          .schema('parking')
          .from('parkingslot')
          .select('id, name, availability, parkinglot!inner(*)')
          .eq('parkinglot.parking_floor_id', parkingFloorId)
          .eq('parkinglot.parking_area_id', parkingAreaId)
          .order('id', ascending: true);
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future getSpecificSlot(BuildContext context, int slotId) async {
    try {
      return await supabase
          .schema('parking')
          .from('parkingslot')
          .select('*')
          .eq('id', slotId);
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future getSpecificVehicle(BuildContext context, int vehicleId) async {
    try {
      return await supabase.from('vehicle').select().eq('id', vehicleId);
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future getTotalFee(BuildContext context) async {
    try {
      final data = await supabase
          .schema("parking")
          .from("parkingdetail")
          .select('parkingarea(parking_fee)')
          .eq('user_id', supabaseProvider.userId);

      double totalFee = 0;

      for (var record in data) {
        final parkingArea = record['parkingarea'] as Map<String, dynamic>;
        totalFee += (parkingArea['parking_fee'] as num).toDouble();
      }

      return totalFee;
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future removeFavourite(BuildContext context, int id) async {
    try {
      await supabase.from('favourite').delete().eq('favourite_id', id);
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));

            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred: $e")));
      }
    }
  }

  @override
  Future saveAsFavorite(int parkingArea, BuildContext context) async {
    try {
      final data = await supabase.from('favourite').upsert({
        'user_id': supabaseProvider.userId,
        'parking_area_id': parkingArea
      }).select();

      if (data.isNotEmpty) {
        if (context.mounted) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  icon: const Icon(
                    Icons.check,
                    color: brandColor,
                    size: 50,
                  ),
                  content: const Text(
                    "Added to your favourites!",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    Align(
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.thumb_up,
                            color: secondaryColor,
                          )),
                    )
                  ],
                );
              });
        }
      }
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future saveParkingDetail(
      BuildContext context,
      String parkingDate,
      String entryTime,
      int durationInHours,
      String exitTime,
      Map<String, dynamic> parkingarea,
      int vehicleId,
      int parkingSlotId) async {
    try {
      final data =
          await supabase.schema('parking').from('parkingdetail').insert({
        'parking_date': parkingDate,
        'entry_time': entryTime,
        'duration': durationInHours,
        'exit_time': exitTime,
        'parking_area_id': parkingarea['id'],
        'user_id': supabaseProvider.userId,
        'vehicle_id': vehicleId,
        'parking_slot_id': parkingSlotId
      }).select();

      if (data.isNotEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text("You have succcessfully booked your parking slot]")));

          Navigator.pushNamed(context, "/home");
        }
        updateSlotAvailability(parkingSlotId);
      }
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future searchFavourite(BuildContext context, String searchWord) async {
    try {
      return await supabase.rpc('search_favourite', params: {
        'userid': supabaseProvider.userId,
        'search_text': searchWord
      }).select();
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future searchParkingArea(BuildContext context, String searchWord) async {
    try {
      return await supabase
          .schema('parking')
          .from('parkingarea')
          .select()
          .textSearch('name', searchWord);
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));
            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occured: $e")));
      }
    }
  }

  @override
  Future signInUser(String email, String password, BuildContext context) async {
    try {
      final AuthResponse res = await supabase.auth
          .signInWithPassword(email: email, password: password);

      final User? user = res.user;

      if (user == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("You don't have an account. Proceed to sign up!")));
        }
      } else {
        if (context.mounted) {
          List<Map<String, dynamic>> profile =
              await retrieveUserProfile(context);
          supabaseProvider.setProfileId(profile[0]['id']);
          supabaseProvider.setSignedStatus(true);
        }
        if (context.mounted) {
          Navigator.pushNamed(context, "/home");
        }
      }
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));

            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred: $e")));
      }
    }
  }

  @override
  Future retrieveUserProfile(BuildContext context) async {
    try {
      return await supabase
          .from('profile')
          .select("*")
          .eq("user_id", supabase.auth.currentUser!.id);
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));

            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));

            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred: $e")));
      }
    }
  }

  @override
  updateSlotAvailability(int parkingSlotId) async {
    await supabase
        .schema('parking')
        .from('parkingslot')
        .update({'availability': false}).eq('id', parkingSlotId);
  }

  @override
  Future updateUserProfile(String name, String phoneNumber, String carModel,
      String carNumber, String carColor, BuildContext context) async {
    try {
      final data = await supabase
          .from('profile')
          .update({
            'name': name,
            'phone_number': phoneNumber,
            'email_address': supabase.auth.currentUser!.email
          })
          .eq('user_id', supabase.auth.currentUser!.id)
          .select();

      if (context.mounted) {
        if (data.isNotEmpty) {
          supabaseProvider.setProfileId(data[0]['id']);

          addCarProfile(carModel, carNumber, carColor, context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Failed to update profile. Try again later!")));
        }
      }
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));

            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred: $e")));
      }
    }
  }

  @override
  Future<void> signOut(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      supabaseProvider.setUserId(0);

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign out failed: $e')),
        );
      }
    }
  }

  @override
  Future signInWithFacebook(BuildContext context) async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: kIsWeb
          ? null
          : 'my.scheme://my-host', // Optionally set the redirect link to bring back the user via deeplink.
      authScreenLaunchMode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode
              .externalApplication, // Launch the auth screen in a new webview on mobile.
    );
  }

  @override
  Future signInWithGoogle(BuildContext context) async {
    // accessToken - The OAuth2 access token to access Google services.
    // idToken - An OpenID Connect ID token that identifies the user.
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: '', //idToken
      accessToken: '', //accessToken
    );
  }

  @override
  Future resendOTP(BuildContext context) async {
    try {
      await supabase.auth.resend(
        type: OtpType.signup,
        email: supabase.auth.currentUser!.email,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "A new OTP has been sent to your registered email address.")));
      }
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));

            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));

            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred: $e")));
      }
    }
  }

  @override
  Future verifyOTP(String email, String otp, BuildContext context) async {
    try {
      final AuthResponse res = await supabase.auth
          .verifyOTP(email: email, token: otp, type: OtpType.signup);

      final User? user = res.user;

      if (context.mounted) {
        if (user != null) {
          Navigator.pushNamed(context, "/profilesignup");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Verification failed. Try again.")));
        }
      }
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '23505':
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("This account already exists!")));

            break;
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));

            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
            break;
        }
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred: $e")));
      }
    }
  }

  @override
  Future getUserProfile(BuildContext context) async {
    try {
      return await supabase
          .from('profile')
          .select('*')
          .eq('id', supabaseProvider.profileId);
    } on PostgrestException catch (e) {
      if (context.mounted) {
        switch (e.code) {
          case '42501':
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Unauthorized: You don't have permission to access")));

            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Unknown Error: ${e.message}")));
        }
      }
    } on AuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An unexpected error occurred: $e")));
      }
    }
  }

  @override
  Future uploadProfile(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return null;

      File image = File(pickedFile.path);

      String fileExtension = p.extension(image.path);
      if (fileExtension.isEmpty) {
        fileExtension = ".jpg";
      }

      String fileName = '${const Uuid().v4()}$fileExtension';

      String storagePath = 'profile_images/$fileName';

      await supabase.storage.from('profiles').upload(storagePath, image);

      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User not logged in')));
        }
      }

      await supabase.from('profile').update({'profile_image': storagePath}).eq(
          'user_id', supabase.auth.currentUser!.id);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error uploading profile image: $e')));
      }
    }
  }

  @override
  Future downloadProfile(BuildContext context) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User not logged in')));
      }

      final response = await supabase
          .from('profile')
          .select('profile_image')
          .eq('user_id', userId)
          .single();

      if (response['profile_image'] == null) {
        return null;
      }

      String storagePath = response['profile_image'];

      final signedUrlResponse = await supabase.storage
          .from('profiles')
          .createSignedUrl(storagePath, 3600);

      return signedUrlResponse;
    } catch (e) {
      return null;
    }
  }

  @override
  Future deleteProfile(BuildContext context, String imagePath) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logged out successfully')));
      }

      // Delete file from Supabase Storage
      await supabase.storage.from('profiles').remove([imagePath]);

      //Remove the image reference from the database
      await supabase
          .from('profile')
          .update({'profile_image': null}).eq('user_id', userId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Profile image deleted successfully.")));
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error deleting profile image: $e")));
      }

      return false;
    }
  }
}
