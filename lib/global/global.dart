import 'package:firebase_auth/firebase_auth.dart';

import '../model/direction_details_info.dart';
import '../model/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;

UserModel? userModelCurrentInfo;
DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDropOffAddress = "";