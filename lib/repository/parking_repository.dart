import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_carparking_app/main.dart';
import 'package:supabase_carparking_app/repository/adapter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class ParkingRepository extends Adapter {
  // ─── Auth ────────────────────────────────────────────────────────────────

  @override
  Future<void> createAccount(String email, String password) async {
    final AuthResponse res = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    if (res.user == null) {
      throw Exception('Failed to create an account. Please try again.');
    }
  }

  /// Signs in the user and returns their profile row so the caller (screen)
  /// can update provider state and navigate.
  @override
  Future<List<Map<String, dynamic>>> signInUser(
      String email, String password) async {
    final AuthResponse res = await supabase.auth
        .signInWithPassword(email: email, password: password);
    if (res.user == null) {
      throw Exception("You don't have an account. Proceed to sign up!");
    }
    return retrieveUserProfile();
  }

  @override
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  @override
  Future<void> signInWithGoogle() async {
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: '',
      accessToken: '',
    );
  }

  @override
  Future<void> signInWithFacebook() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: kIsWeb ? null : 'my.scheme://my-host',
      authScreenLaunchMode: kIsWeb
          ? LaunchMode.platformDefault
          : LaunchMode.externalApplication,
    );
  }

  /// Throws [AuthException] if the token is wrong or expired.
  @override
  Future<void> verifyOTP(String email, String otp) async {
    final AuthResponse res = await supabase.auth
        .verifyOTP(email: email, token: otp, type: OtpType.signup);
    if (res.user == null) {
      throw Exception('Verification failed. Try again.');
    }
  }

  @override
  Future<void> resendOTP() async {
    await supabase.auth.resend(
      type: OtpType.signup,
      email: supabase.auth.currentUser!.email,
    );
  }

  // ─── Profile ─────────────────────────────────────────────────────────────

  /// Updates the profile row and returns the assigned profile id so the caller
  /// can store it in provider state.
  @override
  Future<int> updateUserProfile(String name, String phoneNumber,
      String carModel, String carNumber, String carColor) async {
    final data = await supabase
        .from('profile')
        .update({
          'name': name,
          'phone_number': phoneNumber,
          'email_address': supabase.auth.currentUser!.email,
        })
        .eq('user_id', supabase.auth.currentUser!.id)
        .select();
    if (data.isEmpty) {
      throw Exception('Failed to update profile. Try again later.');
    }
    return data[0]['id'] as int;
  }

  @override
  Future<void> addCarProfile(
      String carModel, String carNumber, String carColor, int profileId) async {
    await supabase.from('vehicle').insert({
      'user_id': profileId,
      'car_model': carModel,
      'car_number': carNumber,
      'car_color': carColor,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> retrieveUserProfile() async {
    return await supabase
        .from('profile')
        .select('*')
        .eq('user_id', supabase.auth.currentUser!.id);
  }

  @override
  Future<List<Map<String, dynamic>>> getUserProfile(int profileId) async {
    return await supabase
        .from('profile')
        .select('*')
        .eq('id', profileId);
  }

  @override
  Future<void> uploadProfile() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in.');

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final image = File(pickedFile.path);
    var fileExtension = p.extension(image.path);
    if (fileExtension.isEmpty) fileExtension = '.jpg';

    final fileName = '${const Uuid().v4()}$fileExtension';
    final storagePath = 'profile_images/$fileName';

    await supabase.storage.from('profiles').upload(storagePath, image);
    await supabase
        .from('profile')
        .update({'profile_image': storagePath}).eq('user_id', userId);
  }

  /// Returns null when the user has no profile image set, or if fetching fails.
  @override
  Future<String?> downloadProfile() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return null;

      final response = await supabase
          .from('profile')
          .select('profile_image')
          .eq('user_id', userId)
          .single();

      if (response['profile_image'] == null) return null;

      return await supabase.storage
          .from('profiles')
          .createSignedUrl(response['profile_image'] as String, 3600);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteProfile(String imagePath) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in.');

    await supabase.storage.from('profiles').remove([imagePath]);
    await supabase
        .from('profile')
        .update({'profile_image': null}).eq('user_id', userId);
  }

  // ─── Vehicles ────────────────────────────────────────────────────────────

  @override
  Future<List<Map<String, dynamic>>> getMyVehicles(int userId) async {
    return await supabase.from('vehicle').select().eq('user_id', userId);
  }

  @override
  Future<List<Map<String, dynamic>>> getSpecificVehicle(int vehicleId) async {
    return await supabase.from('vehicle').select().eq('id', vehicleId);
  }

  // ─── Parking areas ───────────────────────────────────────────────────────

  @override
  Future<List<Map<String, dynamic>>> getParkingareas() async {
    return await supabase.schema('parking').from('parkingarea').select('*');
  }

  @override
  Future<List<Map<String, dynamic>>> searchParkingArea(
      String searchWord) async {
    return await supabase
        .schema('parking')
        .from('parkingarea')
        .select()
        .textSearch('name', searchWord);
  }

  @override
  Future<int> getAvailableSlots(int parkingAreaId) async {
    final res = await supabase.functions
        .invoke('dynamic-worker', body: {'parking_area_id': parkingAreaId});
    return (res.data['count'] as num).toInt();
  }

  // ─── Parking lots / floors / slots ───────────────────────────────────────

  @override
  Future<List<Map<String, dynamic>>> getFloorsByParkingLot(
      int parkingAreaId) async {
    return await supabase
        .schema('parking')
        .from('parkinglot')
        .select('id, parkingfloor!inner(*)')
        .eq('parking_area_id', parkingAreaId);
  }

  @override
  Future<List<Map<String, dynamic>>> getSlotsbyParkingFloor(
      int parkingFloorId, int parkingAreaId) async {
    return await supabase
        .schema('parking')
        .from('parkingslot')
        .select('id, name, availability, parkinglot!inner(*)')
        .eq('parkinglot.parking_floor_id', parkingFloorId)
        .eq('parkinglot.parking_area_id', parkingAreaId)
        .order('id', ascending: true);
  }

  @override
  Future<List<Map<String, dynamic>>> getSpecificSlot(int slotId) async {
    return await supabase
        .schema('parking')
        .from('parkingslot')
        .select('*')
        .eq('id', slotId);
  }

  @override
  Future<void> updateSlotAvailability(int parkingSlotId) async {
    await supabase
        .schema('parking')
        .from('parkingslot')
        .update({'availability': false}).eq('id', parkingSlotId);
  }

  // ─── Bookings ─────────────────────────────────────────────────────────────

  /// Inserts the booking row and marks the slot unavailable in a single call.
  @override
  Future<void> saveParkingDetail(
      String parkingDate,
      String entryTime,
      int durationInHours,
      String exitTime,
      Map<String, dynamic> parkingarea,
      int userId,
      int vehicleId,
      int parkingSlotId) async {
    await supabase.schema('parking').from('parkingdetail').insert({
      'parking_date': parkingDate,
      'entry_time': entryTime,
      'duration': durationInHours,
      'exit_time': exitTime,
      'parking_area_id': parkingarea['id'],
      'user_id': userId,
      'vehicle_id': vehicleId,
      'parking_slot_id': parkingSlotId,
    });
    await updateSlotAvailability(parkingSlotId);
  }

  @override
  Future<List<Map<String, dynamic>>> getAllBookings(int userId) async {
    return await supabase
        .schema('parking')
        .from('parkingdetail')
        .select('*, parkingarea!inner(*)')
        .eq('user_id', userId)
        .order('id');
  }

  @override
  Future<double> getTotalFee(int userId) async {
    final data = await supabase
        .schema('parking')
        .from('parkingdetail')
        .select('parkingarea(parking_fee)')
        .eq('user_id', userId);

    double totalFee = 0;
    for (final record in data) {
      final parkingArea = record['parkingarea'] as Map<String, dynamic>;
      totalFee += (parkingArea['parking_fee'] as num).toDouble();
    }
    return totalFee;
  }

  // ─── Favourites ───────────────────────────────────────────────────────────

  @override
  Future<void> saveAsFavorite(int userId, int parkingAreaId) async {
    await supabase.from('favourite').upsert({
      'user_id': userId,
      'parking_area_id': parkingAreaId,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getMyFavorites(int userId) async {
    return await supabase
        .from('favourite_parking_areas_view')
        .select('*')
        .eq('user_id', userId);
  }

  @override
  Future<List<Map<String, dynamic>>> searchFavourite(
      int userId, String searchWord) async {
    return await supabase.rpc('search_favourite', params: {
      'userid': userId,
      'search_text': searchWord,
    }).select();
  }

  @override
  Future<void> removeFavourite(int id) async {
    await supabase.from('favourite').delete().eq('favourite_id', id);
  }

  // ─── Notifications ────────────────────────────────────────────────────────

  @override
  Future<List<Map<String, dynamic>>> getMyNotifications() {
    throw UnimplementedError();
  }
}
