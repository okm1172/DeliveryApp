import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:userapp/model/predicted_places.dart';
import 'package:userapp/widgets/progress_dialog.dart';

import '../assist/request_assist.dart';
import '../global/global.dart';
import '../global/map_key.dart';
import '../infoHandler/app_info.dart';
import '../model/directions.dart';

class PlacePredictionTileDesign extends StatefulWidget {

  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});

  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {

  getPlacesDirectionDetails(String? placeId, context) async{
    showDialog(
        context: context,
        builder: (context) => ProgressDialog(
          message: "Setting up Drop-off. Please wait ....",
        ),
    );

    String placeDirectionDetailUrl =  "https://maps.googleapis.com/maps/api/place/details/json?&place_id=$placeId&key=$mapKey";

    var responseApi = await RequestAssist.receiveRequest(placeDirectionDetailUrl);

    Navigator.pop(context);

    if(responseApi == "Error Occured. Failed. No Response"){
      return;
    }

    if(responseApi["status"] == "OK"){
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude = responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context,listen:false).updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });

      //이건 머지? pop할때 값을 result로 보내준다네요.
      Navigator.pop(context,"obtainedDropOff");

    }
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.light;

    return ElevatedButton(
        onPressed: (){
          getPlacesDirectionDetails(widget.predictedPlaces!.place_id, context);
        },
        style: ElevatedButton.styleFrom(
          primary: darkTheme ? Colors.grey.shade500 : Colors.white,
        ),
        child: Padding(
         padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(Icons.add_location,
              color: darkTheme ? Colors.amber.shade300 : Colors.blue),

              SizedBox(width: 10,),

              Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.predictedPlaces!.main_text!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                        ),
                      )
                    ],
                  )
              )
            ],
          ),
        )
    );
  }
}
