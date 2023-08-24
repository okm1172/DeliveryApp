import 'dart:async';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:userapp/assist/assist_methods.dart';
import 'package:userapp/global/global.dart';
import 'package:userapp/screens/search_places_screen.dart';

import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../model/directions.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controllerGoogleMap =
  Completer();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  GoogleMapController? newGoogleMapController;

  double searchLocationContainerHeight = 220;
  double waitingResponsefromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markerSet = {};
  Set<Circle> circleSet = {};

  String userName = "";
  String userEmail = "";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  locationUserPosition() async{
    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    userCurrentPosition = cPosition;

    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLngPosition,zoom: 15);

    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    //여기서 address를 처음에 구해줌
    String humanReadbleAddress = await AssistMethods.searchAddressForGeographinCoOrdinates(userCurrentPosition!, context);

    print("This is our address = " + humanReadbleAddress);

    //
    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;
  }

  //움직일때 마다 pickupaddress를 계속 update를 지속적으로 시켜줌.
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

  checkIfLocationPermissionAllowed() async{
    _locationPermission = await Geolocator.requestPermission();

    if(_locationPermission == LocationPermission.denied){
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    checkIfLocationPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.light;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          GoogleMap(
              initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
            mapType: MapType.normal,
            circles: circleSet,
            markers: markerSet,
            polylines: polylineSet,
            onMapCreated: (controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
                setState(() {

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
            child: Icon(
              Icons.place,
              size: 30,
              color: Colors.grey,
            )
          ),
          //location search bar
          Positioned(
            bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //중간중간 Column을 넣어주는 이유는 뭘까요?
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: darkTheme ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: darkTheme ? Colors.grey.shade900 : Colors.grey.shade100
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Icon(Icons.location_on_outlined,color: darkTheme ? Colors.amber.shade300 : Colors.blue),
                                      SizedBox(width:10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          DefaultTextStyle(
                                            style: TextStyle(
                                                color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                                                fontSize:12,
                                                fontWeight: FontWeight.bold
                                            ),
                                            child: Text("From",
                                            ),
                                          ),
                                          DefaultTextStyle(
                                            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                            child: Text(Provider.of<AppInfo>(context).userPickUpLocation != null
                                            //substring으로 상위 25자 까지만 표시하고 ...으로 처리
                                                ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName!.substring(0,29) + "..."
                                                : "주소가 없어요",
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5,),

                                Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                                ),
                                
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: GestureDetector(
                                    onTap: () async{
                                      //찾기 화면으로 이동
                                      var responseFromSearchScreen = await Navigator.push(context,MaterialPageRoute(builder: (c) => SearchPlacesScreen()));
                                      if(responseFromSearchScreen == "obtainedDropoff"){
                                        setState(() {
                                          openNavigationDrawer = false;
                                        });
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,color: darkTheme ? Colors.amber.shade300 : Colors.blue),
                                        SizedBox(width:10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            //아래에 노란색 줄이 떠서 defaultTextStyle로 바꿔주었습니당.
                                            DefaultTextStyle(
                                              style: TextStyle(
                                                  color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                                                  fontSize:12,
                                                  fontWeight: FontWeight.bold
                                              ),
                                              child: Text("From",
                                              ),
                                            ),
                                            DefaultTextStyle(
                                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                                              child: Text(Provider.of<AppInfo>(context).userDropOffLocation != null
                                              //substring으로 상위 25자 까지만 표시하고 ...으로 처리
                                                  ? (Provider.of<AppInfo>(context).userDropOffLocation!.locationName!.length>15 ?
                                                     Provider.of<AppInfo>(context).userDropOffLocation!.locationName!.substring(0,15) + "..." :
                                                     Provider.of<AppInfo>(context).userDropOffLocation!.locationName!)
                                                  : "Where to?",
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    )
                  ],
                )
              )
          )
          //아래에서 지도 옮기면 주소 변화하는거 확인 가능
          /*
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
                    ? Provider.of<AppInfo>(context).userPickUpLocation!.locationName!.substring(0,24) + "..."
                    : "주소가 없어요",
                    style: TextStyle(color: Colors.black,fontSize: 15),
                    softWrap: true,
                    overflow: TextOverflow.visible
                ),
              )
          )*/
        ],
      )
    );
  }
}
