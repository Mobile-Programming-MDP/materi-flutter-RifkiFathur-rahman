import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/post.dart';

class MapDetailScreen extends StatefulWidget {
  final Post post;

  const MapDetailScreen({super.key, required this.post});

  @override
  State<MapDetailScreen> createState() => _MapDetailScreenState();
}

class _MapDetailScreenState extends State<MapDetailScreen> {
  late LatLng lokasi;

  @override
  void initState() {
    super.initState();

    // Ambil dari post (string → double)
    lokasi = LatLng(
      double.parse(widget.post.latitude!),
      double.parse(widget.post.longitude!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Peta Lokasi")),
      body: FlutterMap(
        options: MapOptions(initialCenter: lokasi, initialZoom: 15),
        children: [
          // 🌍 Map layer (OpenStreetMap)
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: "com.example.cepu_app",
          ),

          // 📍 Marker
          MarkerLayer(
            markers: [
              Marker(
                point: lokasi,
                width: 80,
                height: 80,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
