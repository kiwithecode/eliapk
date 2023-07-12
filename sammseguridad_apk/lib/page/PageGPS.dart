import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';
import 'package:sammseguridad_apk/widgets/Drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter/painting.dart';

class PageGPS extends StatefulWidget {
  @override
  _PageGPSState createState() => _PageGPSState();
}

class _PageGPSState extends State<PageGPS> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(-2.1480022, -79.8860091);
  final Set<Marker> _markers = {};

  BitmapDescriptor? markerIcon;

  @override
  void initState() {
    super.initState();
    setMarkerIcon();
  }

  void setMarkerIcon() async {
  final ImageConfiguration imageConfiguration = ImageConfiguration();
  final ByteData byteData = await rootBundle.load('assets/images/SAMM.png');
  final ui.Codec codec = await ui.instantiateImageCodec(
    byteData.buffer.asUint8List(),
    targetWidth: 120,  // Change the width to your need
    targetHeight: 120, // Change the height to your need
  );
  final ui.FrameInfo frameInfo = await codec.getNextFrame();
  final ui.Image resizedImage = frameInfo.image;
  
  // Convert ui.Image to bytes
  final ByteData? imageData = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List bytes = imageData!.buffer.asUint8List();

  markerIcon = BitmapDescriptor.fromBytes(bytes);
}


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  void _addMarker(LatLng position) {
  setState(() {
    _markers.add(
      Marker(
        markerId: MarkerId(DateTime.now().toString()), // Unique id for each marker
        position: position,
        infoWindow: InfoWindow(
          title: 'New marker',
          snippet: 'This marker was added when you clicked the map',
        ),
        icon: markerIcon ?? BitmapDescriptor.defaultMarker, // Provide default marker if markerIcon is null
      ),
    );
  });
}


  void _removeMarker() {
    setState(() {
      _markers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy', 'es').format(DateTime.now());

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width + 10,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/FOTO-1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width - 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Container(
                      height: 300,
                      width: 300,
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                        initialCameraPosition: CameraPosition(
                          target: _center,
                          zoom: 11.0,
                        ),
                        scrollGesturesEnabled: true,
                        onTap: _addMarker,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _removeMarker,
                    child: Text('Remove Marker'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
         
        ],
      ),
    );
  }
}
