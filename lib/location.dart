import 'package:hive/hive.dart';

part 'location.g.dart'; // generated adapter

@HiveType(typeId: 0)
class Location extends HiveObject {
  @HiveField(0)
  String label;

  @HiveField(1)
  double latitude;

  @HiveField(2)
  double longitude;

  @HiveField(3)
  double timezone;

  Location(this.label, this.latitude, this.longitude, this.timezone);
}