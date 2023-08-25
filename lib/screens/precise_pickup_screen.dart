import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';

import '../assist/assist_methods.dart';
import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../model/directions.dart';

class PrecisePickUpScreen extends StatefulWidget {
  const PrecisePickUpScreen({super.key});

  @override
  State<PrecisePickUpScreen> createState() => _PrecisePickUpScreenState();
}

class _PrecisePickUpScreenState extends State<PrecisePickUpScreen> {

  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  double bottomPaddingOfMap = 0;
  Position? userCurrentPosition;

  final Completer<GoogleMapController> _controllerGoogleMap =
  Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  locationUserPosition() async{
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition,zoom: 15);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //여기서 address를 처음에 구해줌
    String humanReadbleAddress = await AssistMethods.searchAddressForGeographinCoOrdinates(userCurrentPosition!, context);
  }

  getAddressFromLatLng() async{
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: pickLocation!.latitude,
          longitude: pickLocation!.longitude,
          googleMapApiKey: mapKey);
      setState(() {

        Directions userPickUpAddress = Directions();

        userPickUpAddress.locationLatitude = pickLocation!.latitude;
        userPickUpAddress.locationLongitude = pickLocation!.longitude;
        userPickUpAddress.locationName = data.address;

        Provider.of<AppInfo>(context,listen:false).updatePickUpLocationAddress(userPickUpAddress);
        //_address = data.address;
      });
    } catch (c) {
      print(c);
    }
  }

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.light;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;
              setState(() {
                bottomPaddingOfMap = 100;
              });
              //맵 처음 시작될때, 현재 위치로 옮겨주는 함수
              locationUserPosition();
            },
            onCameraMove: (position) {
              if(pickLocation != position.target){
                setState(() {
                  pickLocation = position.target;
                });
              }
            },
            onCameraIdle: () {
                //geo2로 구현가능
              getAddressFromLatLng();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top: 70, bottom: bottomPaddingOfMap),
              child: Icon(
                Icons.place,
                size: 30,
                color: Colors.grey,
              ),
            )
          ),
          Positioned(
              top: 80,
              right:20,
              left: 20,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white,
                ),
                child: Text(Provider.of<AppInfo>(context).userPickUpLocation != null
                //substring으로 상위 25자 까지만 표시하고 ...으로 처리
                    ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName!.substring(0,29) + "..."
                    : "주소가 없어요",
                    style: TextStyle(color: Colors.black,fontSize: 15),
                    softWrap: true,
                    overflow: TextOverflow.visible
                ),
              )
          ),
          Positioned(
            bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                  padding: EdgeInsets.all(12),
                child: ElevatedButton(
                    onPressed: (){
                      //따로 설정해줄 필요가 없는게, onCameraIdle에서 getAddressFromLatLng를 통해 provider값을 계속 바꿔줌
                      Navigator.pop(context);
                    },
                    child: Text("Set Current Location",style: TextStyle(color: Colors.grey.shade800)),
                  style: ElevatedButton.styleFrom(
                    primary: darkTheme ? Colors.amber.shade300 : Colors.blue,
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )
                  ),
                )
              )
          )
        ],
      )
    );
  }
}
