class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({
    required this.lat,
    required this.long,
  });
}

class YakutskLocation extends AppLatLong {
  const YakutskLocation({
    super.lat = 62.035454,
    super.long = 129.675476,
  });
}
