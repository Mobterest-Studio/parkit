import 'package:flutter/material.dart';
import 'package:supabase_carparking_app/constants/config.dart';
import 'package:supabase_carparking_app/main.dart';
import 'package:supabase_carparking_app/repository/adapter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParkingRepository extends Adapter {
  @override
  Future addCarProfile(String carModel, String carNumber, String carColor,
      BuildContext context) async {
    try {
      final data = await supabase.from('vehicle').insert({
        'user_id': supabaseProvider.userId,
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
  Future createAccount(String email, BuildContext context) async {
    try {
      final data = await supabase
          .from('profile')
          .insert({'email_address': email}).select();

      if (data.isNotEmpty) {
        supabaseProvider.setUserId(data[0]['id']);
        if (context.mounted) {
          Navigator.pushNamed(context, "/emailVerification");
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to create account")));
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
      final data = await supabase
          .schema('parking')
          .from('parkingslot')
          .select('id,  parkinglot!inner(*)')
          .eq('parkinglot.parking_area_id', parkingAreaId)
          .eq('availability', true)
          .count();

      return data.count;
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
  Future getUserProfile(BuildContext context) async {
    try {
      return await supabase
          .from('profile')
          .select('*')
          .eq('id', supabaseProvider.userId);
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
  Future signInUser(String email, BuildContext context) async {
    try {
      final data =
          await supabase.from('profile').select('*').eq('email_address', email);

      if (context.mounted) {
        if (data.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("You don't have an account. Proceed to sign up!")));
        } else if (data.length == 1) {
          supabaseProvider.setUserId(data[0]['id']);
          supabaseProvider.setSignedStatus(true);
          Navigator.pushNamed(context, "/home");
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed to log in!")));
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
          .update({'name': name, 'phone_number': phoneNumber})
          .eq('id', supabaseProvider.userId)
          .select();

      if (data.isNotEmpty) {
        if (context.mounted) {
          addCarProfile(carModel, carNumber, carColor, context);
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
}
