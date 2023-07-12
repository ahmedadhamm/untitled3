import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:untitled3/my_location_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MyLocationProvider myLocationProvider = MyLocationProvider();
  GoogleMapController? mapcontroller = null;

  CameraPosition routePosition =
      const CameraPosition(target: LatLng(30.0473612, 31.2380913), zoom: 15);

  // @override
  // void initState() {
  //   super.initState();
  //   // myLocationProvider.requestService();
  //   // myLocationProvider.requestPermission();
  // }
  static const String routeMarkerId = 'route';

  //Set<int> numbers = {};
  Set<Marker> markers = {
    const Marker(
        markerId: MarkerId(routeMarkerId),
        position: LatLng(30.0473612, 31.2380913))
  };

  @override
  void initState() {
    super.initState();
    trackUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    // numbers.add(1);
    // numbers.add(2);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: routePosition,
              onMapCreated: (GoogleMapController controller) {
                mapcontroller = controller;
              },
              myLocationButtonEnabled: true,
              compassEnabled: true,
              onTap: (latlang) {
                print(latlang);
              },
              markers: markers,
            ),
          ),
          // ElevatedButton(
          //   onPressed: () {
          //     getUserLocation();
          //   },
          //   child: const Text('Get Location'),
          // ),
        ],
      ),
    );
  }

  static const String userMarkerId = 'user';
  StreamSubscription<LocationData>? locationListener = null;

  void trackUserLocation() async {
    // var locationData = await myLocationProvider.getLocation();

    // myLocationProvider.requestService();
    // myLocationProvider.requestPermission();
    myLocationProvider.locationManager.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 2000,
      distanceFilter: 10,
    );
    locationListener =
        myLocationProvider.trackUserLocation().listen((newLocation) {
      print(newLocation.latitude);
      print(newLocation.longitude);
      Marker userMarker = Marker(
        markerId: const MarkerId(userMarkerId),
        position:
            LatLng(newLocation.latitude ?? 0.0, newLocation.longitude ?? 0.0),
      );
      markers.add(userMarker);
      mapcontroller?.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(newLocation.latitude ?? 0.0, newLocation.longitude ?? 0.0),
          18));
      setState(() {});
    });
  }
  @override
  void deactivate() {
    super.deactivate();
    locationListener?.cancel();
  }
}
