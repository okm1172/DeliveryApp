import 'package:flutter/material.dart';
import 'package:userapp/assist/request_assist.dart';
import 'package:userapp/model/predicted_places.dart';
import 'package:userapp/widgets/place_prediction_tile.dart';

import '../global/map_key.dart';

class SearchPlacesScreen extends StatefulWidget {
  const SearchPlacesScreen({super.key});

  @override
  State<SearchPlacesScreen> createState() => _SearchPlacesScreenState();
}

class _SearchPlacesScreenState extends State<SearchPlacesScreen> {

  List<PredictedPlaces> placesPredictedList = [];

  findPlaceAutoCompleteSearch(String inputText) async{
    if(inputText.length>1){
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$inputText&key=$mapKey";

      var responseAutoCompleteSearch = await RequestAssist.receiveRequest(urlAutoCompleteSearch);

      if(responseAutoCompleteSearch == "Error Occured. Failed. No Response"){
        return;
      }

      if(responseAutoCompleteSearch["status"] == "OK"){
        var placePredictions = responseAutoCompleteSearch["predictions"];

        //각각의 data를 PredictedPlaces 변수로 하나 차곡차곡 넣는 작업
        var placePredictionsList = placePredictions.map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.light;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: darkTheme ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: darkTheme ? Colors.amber.shade300 : Colors.blue,
          leading: GestureDetector(
            onTap:(){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color : darkTheme ? Colors.black : Colors.white),
          ),
          title: Text(
            "Search & Set dropoff location",
            style: TextStyle(color: darkTheme ? Colors.black : Colors.blue),
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white54,
                    blurRadius: 8,
                    spreadRadius: 0.5,
                    offset: Offset(0.7, 0.7)
                  )
                ]
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.adjust_sharp,
                          color: darkTheme ? Colors.black : Colors.white,
                        ),

                        SizedBox(height: 10),

                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.all(8),
                              child: TextField(
                                onChanged: (value){
                                  findPlaceAutoCompleteSearch(value);
                                },
                                decoration: InputDecoration(
                                  hintText: "Search location here ....",
                                  fillColor : darkTheme ? Colors.black : Colors.white,
                                  filled: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    left:11,
                                    top:8,
                                    bottom: 8,
                                  )
                                ),
                              )
                            )
                        )
                      ],
                    )
                  ],
                )
              )
            ),
            //전에 입력했었던것들 출력하기
            (placesPredictedList.length>0)
            ? Expanded(
                child: ListView.separated(
                    itemCount: placesPredictedList.length,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                      return PlacePredictionTileDesign(
                        predictedPlaces: placesPredictedList[index],
                      );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      height:0,
                      color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                      thickness: 0,
                    );
                  },
                )
            ) : Container(),
          ],
        )
      )
    );
  }
}
