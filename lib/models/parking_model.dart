class Parking {
  // Constructor for the Parking class. All fields are required except for 'parkingSlotId',
  // which is optional (nullable).
  Parking(
      {required this.parkingDate,  // The date when the parking occurs (e.g., '2024-09-07').
      required this.entryTime,  // The time the vehicle enters the parking area (e.g., '10:00 AM').
      required this.durationInHours,  // The duration of the parking in hours (e.g., 3 hours).
      required this.exitTime,  // The time the vehicle exits the parking area (e.g., '1:00 PM').
      required this.parkingArea,  // A map representing the details of the parking area (e.g., name, location).
      required this.userId,  // The unique ID of the user who parked the vehicle (e.g., 1).
      required this.vehicleId,  // The unique ID of the vehicle being parked (e.g., 4XPY676).
      this.parkingSlotId});  // An optional field representing the ID of the specific parking slot assigned (e.g., G1).

  // The date of parking, represented as a String. This could be formatted as 'YYYY-MM-DD'.
  final String parkingDate;

  // The time the vehicle entered the parking area, represented as a String. This could be formatted as 'HH:MM AM/PM'.
  final String entryTime;

  // The duration of the parking in hours, represented as an integer (e.g., 3 hours).
  final int durationInHours;

  // The time the vehicle exited the parking area, represented as a String. Similar format to 'entryTime'.
  final String exitTime;

  // A map that holds details about the parking area, such as the name, description, or other relevant information.
  final Map<String, dynamic> parkingArea;

  // The unique identifier for the user who is parking the vehicle, represented as an integer.
  final int userId;

  // The unique identifier for the vehicle being parked, represented as an integer.
  final int vehicleId;

  // The ID of the specific parking slot assigned to the user. This field is optional and can be null.
  int? parkingSlotId;
}
