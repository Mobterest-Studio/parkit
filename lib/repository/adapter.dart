import 'package:flutter/material.dart';

abstract class Adapter {
  /// Sign up a new user
  Future createAccount(String email, BuildContext context);

  /// Update profile of an existing user
  Future updateUserProfile(String name, String phoneNumber, String carModel,
      String carNumber, String carColor, BuildContext context);

  /// Add new Car profile for an existing user
  Future addCarProfile(
      String carModel, String carNumber, String carColor, BuildContext context);

  /// Sign in an existing user
  Future signInUser(String email, BuildContext context);

  /// Get list of available parking areas
  Future getParkingareas(BuildContext context);

  /// Search a specific parking area using name
  Future searchParkingArea(BuildContext context, String searchWord);

  /// Save parking area as favourite
  Future saveAsFavorite(int parkingArea, BuildContext context);

  /// Book Parking: Save details of the parking the user has selected.
  Future saveParkingDetail(
      BuildContext context,
      String parkingDate,
      String entryTime,
      int durationInHours,
      String exitTime,
      Map<String, dynamic> parkingarea,
      int vehicleId,
      int parkingSlotId);

  /// Get all bookings made by an existing user
  Future getAllBookings(BuildContext context);

  /// Get list of vehicles for an existing user
  Future getMyVehicles(BuildContext context);

  /// Get list of favourite parking areas for an existing user
  Future getMyFavorites(BuildContext context);

  /// Get notifications
  Future<List<Map<String, dynamic>>> getMyNotifications();

  /// Remove parking area as favourite
  Future removeFavourite(BuildContext context, int id);

  /// Get available slots for a specific parking area
  Future getAvailableSlots(BuildContext context, int parkingAreaId);

  //// Get available floors for a specific parking lot
  Future getFloorsByParkingLot(BuildContext context, int parkingAreaId);

  /// Get available slots for a specific parking floor
  Future getSlotsbyParkingFloor(
      BuildContext context, int parkingFloorId, int parkingAreaId);

  /// Update availability of a specific parking slot
  updateSlotAvailability(int parkingSlotId);

  /// Get total amount of parking fee paid by an existing user
  Future getTotalFee(BuildContext context);

  /// Get information of a specific vehicle using id
  Future getSpecificVehicle(BuildContext context, int vehicleId);

  /// Get information of a specific parking slot using id
  Future getSpecificSlot(BuildContext context, int slotId);

  /// Get profile information for an existing user
  Future getUserProfile(BuildContext context);

  ///Search a specific parking area from the list of favourites
  Future searchFavourite(BuildContext context, String searchWord);
}
