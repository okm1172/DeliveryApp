import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:userapp/global/global.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final confirmTextEditingController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  //form의 상태를 알수있도록 해주는 key = 아이디 비밀번호 개수나 이런거 제대로 들어갔는지 체크가능.
  final _formKey = GlobalKey<FormState>();

  void _submit() async{
    if(_formKey.currentState!.validate()){
      await firebaseAuth.createUserWithEmailAndPassword(
        //trim은 문자열 앞과 뒤 공백을 제거해줍니다.
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
      ).then((auth) async{
        currentUser = auth.user;

        if(currentUser != null) {
          Map userMap = {
            "id" : currentUser!.uid,
            "name" : nameTextEditingController.text.trim(),
            "email" : emailTextEditingController.text.trim(),
            "address" : addressTextEditingController.text.trim(),
            "phone" : phoneTextEditingController.text.trim(),
          };

          DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users");
          userRef.child(currentUser!.uid).set(userMap);

        }
      })
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

                      Text('Register',
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
                                    hintText: 'Name',
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
                                    prefixIcon: Icon(Icons.person, color:darkTheme ? Colors.amber.shade400 : Colors.grey),
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (text) {
                                    if(text==null || text.isEmpty)
                                    {
                                      return "Name can\'t be empty";
                                    }
                                    if(text.length<2)
                                    {
                                      return "Please enter a valid name";
                                    }
                                    if(text.length>50)
                                    {
                                      return "Name can\'t be more than 50";
                                    }
                                  },
                                  onChanged: (text) => setState(() {
                                    nameTextEditingController.text = text;
                                  }),
                                ),

                                SizedBox(height: 15),

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

                                IntlPhoneField(
                                  disableLengthCheck: true,
                                  showCountryFlag: true,
                                  dropdownIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                                  ),
                                  dropdownTextStyle: TextStyle(color: Colors.grey.shade300,fontWeight: FontWeight.bold),
                                  style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                                  decoration:InputDecoration(
                                    hintText: 'Phone',
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
                                  ),
                                  initialCountryCode: 'KR',
                                  onChanged: (text) => setState(() {
                                    phoneTextEditingController.text = text.completeNumber;
                                  }),
                                ),

                                SizedBox(height:15),

                                TextFormField(
                                  obscureText: !_passwordVisible,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50)
                                  ],
                                  style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                      hintText: 'Password',
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
                                      prefixIcon: Icon(Icons.key, color:darkTheme ? Colors.amber.shade400 : Colors.grey),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _passwordVisible = !_passwordVisible;
                                          });
                                        },
                                        icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off,
                                          color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                                        ),
                                      )
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (text) {
                                    if(text==null || text.isEmpty)
                                    {
                                      return "Password can\'t be empty";
                                    }
                                    if(text.length<6)
                                    {
                                      return "Please enter a valid password";
                                    }
                                    if(text.length>50)
                                    {
                                      return "Password can\'t be more than 50";
                                    }
                                    return null;
                                  },
                                  onChanged: (text) => setState(() {
                                    passwordTextEditingController.text = text;
                                  }),
                                ),

                                SizedBox(height: 15),

                                TextFormField(
                                  obscureText: !_confirmPasswordVisible,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(50)
                                  ],
                                  style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                                  decoration: InputDecoration(
                                      hintText: 'Confirm Password',
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
                                      prefixIcon: Icon(Icons.circle_outlined, color:darkTheme ? Colors.amber.shade400 : Colors.grey),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _confirmPasswordVisible = !_confirmPasswordVisible;
                                          });
                                        },
                                        icon: Icon(_confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                          color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                                        ),
                                      )
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (text) {
                                    if(text==null || text.isEmpty)
                                    {
                                      return "Confirm Password can\'t be empty";
                                    }
                                    if(passwordTextEditingController.text != text)
                                    {
                                      return "Password do not match";
                                    }
                                    if(text.length<6)
                                    {
                                      return "Please enter a valid password";
                                    }
                                    if(text.length>50)
                                    {
                                      return "Password can\'t be more than 50";
                                    }
                                    return null;
                                  },
                                  onChanged: (text) => setState(() {
                                    confirmTextEditingController.text = text;
                                  }),
                                ),

                                SizedBox(height: 20),

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
                                        'Register',
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
                                      "Have an account?",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                      ),
                                    ),

                                    SizedBox(width:5),

                                    GestureDetector(
                                      onTap: (){},
                                      child: Text(
                                        "Sign In",
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
      )
    );
  }
}
