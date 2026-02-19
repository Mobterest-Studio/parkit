// Adapter defines the contract for all data operations in the app.
//
// Rules every implementation must follow:
//   - No BuildContext parameters. Data methods receive only data, never UI handles.
//   - No navigation. Methods return data or throw; callers decide where to go next.
//   - No snackbars or dialogs. Let exceptions propagate so screens can handle errors.
//   - Typed return values. Every Future declares what it resolves to.

abstract class Adapter {
  // ─── Auth ────────────────────────────────────────────────────────────────

  /// Create a new user account. Throws on failure.
  Future<void> createAccount(String email, String password);

  /// Sign in an existing user. Returns the user's profile row on success.
  /// Throws [AuthException] or [Exception] on failure.
  Future<List<Map<String, dynamic>>> signInUser(String email, String password);

  /// Sign out the current user.
  Future<void> signOut();

  /// Start Google OAuth sign-in (opens external browser).
  Future<void> signInWithGoogle();

  /// Start Facebook OAuth sign-in (opens external browser).
  Future<void> signInWithFacebook();

  /// Verify the OTP sent to [email]. Throws if verification fails.
  Future<void> verifyOTP(String email, String otp);

  /// Resend the OTP to the currently pending sign-up email.
  Future<void> resendOTP();

  // ─── Profile ─────────────────────────────────────────────────────────────

  /// Create or update the user profile. Returns the assigned profile id.
  Future<int> updateUserProfile(
      String name, String phoneNumber, String carModel, String carNumber, String carColor);

  /// Add a new vehicle under [profileId].
  Future<void> addCarProfile(
      String carModel, String carNumber, String carColor, int profileId);

  /// Retrieve profile using the Supabase auth user id.
  Future<List<Map<String, dynamic>>> retrieveUserProfile();

  /// Fetch the full profile row for [profileId].
  Future<List<Map<String, dynamic>>> getUserProfile(int profileId);

  /// Upload a profile image chosen from the device gallery.
  Future<void> uploadProfile();

  /// Download the signed URL for the current user's profile image.
  /// Returns null if no image has been set.
  Future<String?> downloadProfile();

  /// Delete the profile image at [imagePath] from storage and unset the DB reference.
  Future<void> deleteProfile(String imagePath);

  // ─── Vehicles ────────────────────────────────────────────────────────────

  /// Return all vehicles belonging to [userId].
  Future<List<Map<String, dynamic>>> getMyVehicles(int userId);

  /// Return a single vehicle row by [vehicleId].
  Future<List<Map<String, dynamic>>> getSpecificVehicle(int vehicleId);

  // ─── Parking areas ───────────────────────────────────────────────────────

  /// Return all available parking areas.
  Future<List<Map<String, dynamic>>> getParkingareas();

  /// Full-text search parking areas by name.
  Future<List<Map<String, dynamic>>> searchParkingArea(String searchWord);

  /// Return the number of available slots in [parkingAreaId].
  Future<int> getAvailableSlots(int parkingAreaId);

  // ─── Parking lots / floors / slots ───────────────────────────────────────

  /// Return floors (with nested parkingfloor data) for [parkingAreaId].
  Future<List<Map<String, dynamic>>> getFloorsByParkingLot(int parkingAreaId);

  /// Return slots on [parkingFloorId] within [parkingAreaId].
  Future<List<Map<String, dynamic>>> getSlotsbyParkingFloor(
      int parkingFloorId, int parkingAreaId);

  /// Return a single parking slot row by [slotId].
  Future<List<Map<String, dynamic>>> getSpecificSlot(int slotId);

  /// Mark [parkingSlotId] as unavailable.
  Future<void> updateSlotAvailability(int parkingSlotId);

  // ─── Bookings ─────────────────────────────────────────────────────────────

  /// Save a new parking booking. Also marks the slot unavailable.
  Future<void> saveParkingDetail(
      String parkingDate,
      String entryTime,
      int durationInHours,
      String exitTime,
      Map<String, dynamic> parkingarea,
      int userId,
      int vehicleId,
      int parkingSlotId);

  /// Return all bookings for [userId].
  Future<List<Map<String, dynamic>>> getAllBookings(int userId);

  /// Return the cumulative parking fee paid by [userId].
  Future<double> getTotalFee(int userId);

  // ─── Favourites ───────────────────────────────────────────────────────────

  /// Add [parkingAreaId] to [userId]'s favourites.
  Future<void> saveAsFavorite(int userId, int parkingAreaId);

  /// Return all favourite parking areas for [userId].
  Future<List<Map<String, dynamic>>> getMyFavorites(int userId);

  /// Search [userId]'s favourites for [searchWord].
  Future<List<Map<String, dynamic>>> searchFavourite(int userId, String searchWord);

  /// Remove the favourite with [id].
  Future<void> removeFavourite(int id);

  // ─── Notifications ────────────────────────────────────────────────────────

  /// Return notifications for the current user. Not yet implemented.
  Future<List<Map<String, dynamic>>> getMyNotifications();
}
