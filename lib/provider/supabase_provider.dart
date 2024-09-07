import 'package:flutter/material.dart'; // Flutter package to create UIs.
import 'package:supabase_carparking_app/models/parking_model.dart'; // Importing the Parking model class from the car parking app.

/// SupabaseProvider class extends ChangeNotifier to handle state management in Flutter.
/// It is responsible for notifying listeners when changes occur in the state.
class SupabaseProvider extends ChangeNotifier {
  // Private variable to store user ID.
  late int _userId;

  // Getter to access the private _userId variable from outside the class.
  int get userId => _userId;

  // Private variable to store the signed-in status of the user.
  bool _signedIn = false;

  // Getter to access the private _signedIn variable from outside the class.
  bool get signedIn => _signedIn;

  // Private variable to store parking details.
  late Parking _parking;

  // Getter to access the private _parking variable from outside the class.
  Parking get parking => _parking;

  /// Method to update the user ID.
  /// [uId] is the new user ID that will replace the current _userId.
  /// Calls notifyListeners() to inform any listeners that the state has changed.
  void setUserId(int uId) {
    _userId = uId;
    notifyListeners(); // Notify all listeners that user ID has changed.
  }

  /// Method to update the signed-in status.
  /// [signed] is a boolean value representing whether the user is signed in or not.
  /// Calls notifyListeners() to inform any listeners that the state has changed.
  void setSignedStatus(bool signed) {
    _signedIn = signed;
    notifyListeners(); // Notify all listeners that signed-in status has changed.
  }

  /// Method to update parking details.
  /// [parkingDetails] is a Parking object containing the new parking information.
  /// Calls notifyListeners() to inform any listeners that the state has changed.
  void setParking(Parking parkingDetails) {
    _parking = parkingDetails;
    notifyListeners(); // Notify all listeners that parking details have changed.
  }
}
