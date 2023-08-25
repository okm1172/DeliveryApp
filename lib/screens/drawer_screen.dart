import 'package:flutter/material.dart';
import 'package:userapp/screens/profile_screen.dart';
import 'package:userapp/splashScreen/splash_screen.dart';

import '../global/global.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.light;

    return Container(
      child: Drawer(
        width: 250,
        child: Padding(
            padding: EdgeInsets.fromLTRB(30, 70, 0, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: darkTheme ? Colors.grey.shade600 : Colors.lightBlue,
                      shape: BoxShape.circle
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    )
                  ),

                  SizedBox(height:20,),

                  Text(
                    userModelCurrentInfo!.name!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    )
                  ),

                  SizedBox(height: 10,),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (c) => ProfileScreen()));
                    },
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: darkTheme ? Colors.amber.shade300 : Colors.blue,
                      )
                    ),
                  ),

                  SizedBox(height:30,),

                  Text("Your Trips",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                  SizedBox(height:15,),

                  Text("Payment",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                  SizedBox(height:15,),

                  Text("Notifications",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                  SizedBox(height:15,),

                  Text("Promos",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                  SizedBox(height:15,),

                  Text("Help",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                  SizedBox(height:15,),

                  Text("Free Trips",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),

                  SizedBox(height:15,),
                ],
              ),

              GestureDetector(
                onTap: (){
                  firebaseAuth.signOut();
                  Navigator.push(context,MaterialPageRoute(builder: (c) => SplashScreen()));
                },
                child:Text(
                    "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              )
            ],
          )
        )
      ),
    );
  }
}
