import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class IssMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  const IssMap({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<IssMap> createState() => _IssMapState();
}

class _IssMapState extends State<IssMap> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(covariant IssMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.latitude != widget.latitude || oldWidget.longitude != widget.longitude) {
      _mapController.move(
        LatLng(widget.latitude, widget.longitude), 
        3.0
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: LatLng(widget.latitude, widget.longitude),
            initialZoom: 3.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.cosmos_tracker',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(widget.latitude, widget.longitude),
                  width: 60, 
                  height: 60,
                  child: Image.asset(
                    'assets/images/iss_icon.png', 
                    fit: BoxFit.contain, 
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}