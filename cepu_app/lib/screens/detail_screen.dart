import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/post.dart';
import '../util/file_image_helper.dart';
import '../screens/map_detail_screen.dart'; // 🔥 TAMBAHAN

class DetailScreen extends StatelessWidget {
  final Post post;

  const DetailScreen({super.key, required this.post});

  Future<void> _openMap(BuildContext context) async {
    if (post.latitude == null || post.longitude == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lokasi tidak tersedia.')));
      return;
    }

    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${post.latitude},${post.longitude}',
    );
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak dapat membuka peta.';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng? postLocation =
        (post.latitude != null && post.longitude != null)
        ? LatLng(double.parse(post.latitude!), double.parse(post.longitude!))
        : null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Detail Laporan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.share_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            if (post.image != null && post.image!.isNotEmpty)
              _buildImage(post.image!)
            else
              Container(
                height: 250,
                width: double.infinity,
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 60),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CATEGORY
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(post.category ?? "Umum"),
                  ),

                  const SizedBox(height: 16),

                  // DESCRIPTION
                  Text(
                    post.description ?? "-",
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 20),

                  // MAP PREVIEW
                  const Text("Lokasi Kejadian"),
                  const SizedBox(height: 10),

                  if (postLocation != null)
                    Container(
                      height: 200,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: postLocation,
                          zoom: 15,
                        ),
                        markers: {
                          Marker(
                            markerId: const MarkerId("loc"),
                            position: postLocation,
                          ),
                        },
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                      ),
                    )
                  else
                    const Text("Lokasi tidak tersedia"),

                  const SizedBox(height: 30),

                  // 🔥 TOMBOL 1 (lama)
                  ElevatedButton.icon(
                    onPressed: () => _openMap(context),
                    icon: const Icon(Icons.location_on),
                    label: const Text("Buka di Google Maps"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 🔥 TOMBOL 2 (BARU)
                  ElevatedButton.icon(
                    onPressed: () {
                      if (postLocation != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapDetailScreen(post: post),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Lokasi tidak tersedia"),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.map),
                    label: const Text("Lihat di Dalam Aplikasi"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      );
    }
    try {
      return Image.memory(
        base64Decode(imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: 250,
      );
    } catch (e) {
      return buildFileImage(imagePath);
    }
  }
}
