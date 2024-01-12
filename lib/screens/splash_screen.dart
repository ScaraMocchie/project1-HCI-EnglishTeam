import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../controllers/accountData.dart';
import 'dart:convert';
import '../controllers/httpHelp.dart';
import '../controllers/routes.dart';
import '../screens/lockscreen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Routes.tempContext=context;
    super.initState();

    isLogin();
  }

  void isLogin() async{
    Routes.tempContext=context;
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool? isLogin = sp.getBool('isLogin') ?? false;

    if (isLogin){
      Timer(const Duration(seconds: 3), ()async{String username = sp.getString("email")!;
      String password = sp.getString("pass")!;
      AccountData.avatarIndex = sp.getInt("avatarIndex")!;

      var response= await http.post(Uri.https(Helper.baseUrl,Helper.baseApi+"login"), body:jsonEncode([username,password]));

      var code=response.statusCode;
                           
                            if(code==200){
                              
                               var data=jsonDecode(response.body);
                              AccountData.email=data[1];
                              AccountData.userId=data[0];
                              AccountData.username=username;
                              AccountData.getProfile();
                              response= await http.post(Uri.https(Helper.baseUrl,Helper.baseApi+"premium")
                            ,body:jsonEncode([data[0],data[1]]));
                             code=response.statusCode;
                            data=jsonDecode(response.body);
                            AccountData.isPrem=data[0];
                            AccountData.permissionStatus=data[3];
                            AccountData.deadlinePermission=data[2];
                            await  AccountData.getData();
                              if (AccountData.permissionStatus == -1){
                                Routes.off("lock");    
                              } else{
                                Routes.off("home");
                              }
                              }
                            else{
                              Routes.off("login");
                            }
      });
    } else{
      Timer(const Duration(seconds: 2), () {
        print("Login duluu");
      Routes.off("login");});
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/Toba/Toba_by_BicaraAI.png", width: 130,),
          
           
          ],

        ),
      ),
    );
  }
}