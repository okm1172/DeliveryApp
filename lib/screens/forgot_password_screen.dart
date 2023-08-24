import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:userapp/screens/register_screen.dart';

import '../global/global.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final emailTextEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void _submit() async{
    if(_formKey.currentState!.validate()){
      await firebaseAuth.sendPasswordResetEmail(
        //trim은 문자열 앞과 뒤 공백을 제거해줍니다.
        email: emailTextEditingController.text.trim(),
      ).then((auth) async{
        await Fluttertoast.showToast(msg: "We have sent you an email to recover password, please check email");
      }).catchError((errorMessage){
        Fluttertoast.showToast(msg: "Error occured: \n $errorMessage");
      });
    }
    else{
      Fluttertoast.showToast(msg: "Not all field are valid");
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
          body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Opacity(
                      opacity: 1,
                      child: FittedBox(
                          child : Image.asset('images/night.jpg'),
                          fit : BoxFit.fitHeight
                      )
                  ),
                ),
                ListView(
                    padding: EdgeInsets.all(0),
                    children: [
                      Column(
                        children: [
                          //Image.asset(darkTheme ? 'images/night.jpg' : 'images/night.jpg'),

                          SizedBox(height:80),

                          Text('Forgot Password Screen',
                            style: TextStyle(
                              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 20, 15, 50),
                            child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    TextFormField(
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50)
                                      ],
                                      style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: 'Email',
                                        hintStyle: TextStyle(
                                          color : Colors.grey,
                                        ),
                                        filled: true,
                                        fillColor: darkTheme ? Colors.black45 : Colors.grey.shade200,
                                        //꼭지점 둥글게 깎기
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(40),
                                            borderSide: BorderSide(
                                              style: BorderStyle.none,
                                              width: 0,
                                            )
                                        ),
                                        //textform 에서 말그대로 앞에 존재하는 icon를 말합니다.
                                        prefixIcon: Icon(Icons.email, color:darkTheme ? Colors.amber.shade400 : Colors.grey),
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (text) {
                                        if(text==null || text.isEmpty)
                                        {
                                          return "Email can\'t be empty";
                                        }
                                        if(EmailValidator.validate(text)==true)
                                        {
                                          return null;
                                        }
                                        if(text.length<2)
                                        {
                                          return "Please enter a valid email";
                                        }
                                        if(text.length>99)
                                        {
                                          return "email can\'t be more than 99";
                                        }
                                      },
                                      onChanged: (text) => setState(() {
                                        emailTextEditingController.text = text;
                                      }),
                                    ),

                                    SizedBox(height: 15),

                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: darkTheme ? Colors.amber.shade300 : Colors.blue,
                                          onPrimary: darkTheme ? Colors.black : Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30)
                                          ),
                                          minimumSize: Size(double.infinity, 50),
                                        ),
                                        onPressed: (){
                                          _submit();
                                        },
                                        child: Text(
                                            'Send Reset Password Link',
                                            style: TextStyle(
                                              fontSize: 20,
                                            )
                                        )
                                    ),

                                    SizedBox(height:20),

                                    GestureDetector(
                                        onTap: (){},
                                        child: Text(
                                          'Forget Password?',
                                          style: TextStyle(
                                              color: darkTheme ? Colors.amber.shade400 : Colors.blue
                                          ),
                                        )
                                    ),

                                    SizedBox(height:20),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Already have an account?",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15,
                                          ),
                                        ),

                                        SizedBox(width:5),

                                        GestureDetector(
                                            onTap: (){
                                              Navigator.push(context,MaterialPageRoute(builder: (c) => LoginScreen()));
                                            },
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                fontSize:15,
                                                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                                              ),
                                            )
                                        )
                                      ],
                                    )
                                  ],
                                )
                            ),
                          )
                        ],
                      )
                    ]
                ),
              ]
          )
      ),
    );
  }
}
