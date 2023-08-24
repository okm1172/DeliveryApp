import "package:firebase_database/firebase_database.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";

import "../global/global.dart";

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();

  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");

  Future<void> showUserNameDialogAlert(context, String name){

    nameTextEditingController.text = name;

    return showDialog(
        context: context,
        builder: (context) {
            return AlertDialog(
              title: Text("Update"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameTextEditingController,
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Cancel",style: TextStyle(color: Colors.red),)
                ),

                TextButton(
                    onPressed: (){
                      userRef.child(firebaseAuth.currentUser!.uid).update({
                        "name" : nameTextEditingController.text,
                      }).then((value){
                        nameTextEditingController.clear();
                        Fluttertoast.showToast(msg: "Updated Successfully. \n Reload the app to see the changes");
                      }).catchError((exp){
                        print("Error Occured" + exp);
                      });
                      Navigator.pop(context);
                    },
                    child: Text("Ok",style: TextStyle(color: Colors.black),)
                )
              ],
            );
        },
    );
  }

  Future<void> showUserPhoneDialogAlert(context, String phone){

    phoneTextEditingController.text = phone;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: phoneTextEditingController,
                )
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Cancel",style: TextStyle(color: Colors.red),)
            ),

            TextButton(
                onPressed: (){
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "phone" : phoneTextEditingController.text,
                  }).then((value){
                    phoneTextEditingController.clear();
                    Fluttertoast.showToast(msg: "Updated Successfully. \n Reload the app to see the changes");
                  }).catchError((exp){
                    print("Error Occured" + exp);
                  });
                  Navigator.pop(context);
                },
                child: Text("Ok",style: TextStyle(color: Colors.black),)
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.light;

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child:Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //Colors.transparent는 투명색입니다.
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )
          ),
          title: Text("Profile Screen", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: darkTheme ? Colors.grey.shade600 : Colors.lightBlue,
                    shape: BoxShape.circle
                  ),
                  child: Icon(Icons.person,color: Colors.white),
                ),

                SizedBox(height:20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${userModelCurrentInfo!.name!}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                        onPressed: (){
                          showUserNameDialogAlert(context, userModelCurrentInfo!.name!);
                        },
                        icon: Icon(
                          Icons.edit,
                        )
                    )
                  ],
                ),

                Divider(thickness: 1,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${userModelCurrentInfo!.phone!}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                        onPressed: (){
                          showUserPhoneDialogAlert(context, userModelCurrentInfo!.phone!);
                        },
                        icon: Icon(
                          Icons.edit,
                        )
                    )
                  ],
                ),

                Divider(thickness: 1,),

                SizedBox(height:5),
                Text(
                  "${userModelCurrentInfo!.email!}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )

              ],
            ),
          ),
        )
      ),
    );
  }
}
