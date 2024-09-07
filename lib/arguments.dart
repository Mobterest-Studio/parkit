// This class is used to encapsulate arguments related to a parking area.
// It allows you to pass the parking area information between different parts of the app, such as between screens.

class ParkingArguments {
  // This property holds the details of the parking area. 
  // It is a Map with String keys and dynamic values, allowing flexibility in the types of data stored.
  final Map<String, dynamic> parkingarea;

  // Constructor for the ParkingArguments class.
  // The 'required' keyword ensures that the 'parkingarea' argument must be passed when creating an instance of this class.
  ParkingArguments({required this.parkingarea});
}
