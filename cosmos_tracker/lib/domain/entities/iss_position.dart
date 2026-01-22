class IssPosition {
  final double latitude;
  final double longitude;
  
  final String? locationName; 
  final DateTime? timestamp;  

  const IssPosition({
    required this.latitude,
    required this.longitude,
    this.locationName,
    this.timestamp,
  });
}