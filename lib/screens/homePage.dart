import 'package:flutter/material.dart';
import '../controllers/accountMessage.dart';
import 'dart:ui' as ui;
import '../controllers/routes.dart';
import "./accountPage.dart";
import 'package:percent_indicator/percent_indicator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import './lead_page.dart';
import './progress.dart';
import './songsection.dart';
import '../controllers/songSectionData.dart';
import '../widgets/songlevel.dart';
import '../controllers/leaderboardData.dart';

import 'dart:convert';
import '../controllers/accountData.dart';
import '../controllers/httpHelp.dart';
class HomePage extends StatefulWidget{
  HomePage({super.key});

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
String pageName = "HomePage";
MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
double progres=0.75;
void _onItemTapped(int index) {

   // setState(() {
   
    if(index==1){
        AccountMessage.showLoadingDialog(context);
      LeaderboardData.getData()!.whenComplete(() {print("lanjut"); Routes.off("leaderboard");});
    
    }
    else if(index==2){
      Routes.off("account");
    }
    
      print(index);// = index;
   // } );
  }
  @override
  Widget build (BuildContext context){
    Routes.tempContext=context;
    return WillPopScope(
      onWillPop: ()async{
      Routes.getBack();
      return true;},
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Container(
            
            child:
          Row(children:[Image.asset("assets/images/Toba/Toba.png",height: 32,)
          ,Expanded(child: Container( //Expanded
        alignment: Alignment.centerRight,
        child: InkWell(
          child:Image(image:AssetImage("assets/images/vip_home.png")),
          onTap:(){print("1");
          if(AccountData.permissionStatus != 1){
            Routes.put("ads");
          } else{
            Routes.put("vipPage");
          }
          }
          
          ),
      ))])),shadowColor: Color.fromARGB(255, 0, 0, 0),elevation: 1.5,backgroundColor: Colors.white,),
    
          body:  Row(
            children: [
               Container(
                width: mediaQueryData.size.width/11,
                color: Colors.white,
               )
               ,Expanded(child:Container(
                alignment: Alignment.topCenter,
                decoration: BoxDecoration(color: Color.fromARGB(255, 255, 255, 255)),
                child: SingleChildScrollView(child: 
                Column(children:  //makanan utama
                [
                  SizedBox(
                
                height: 30,
               ),
               Text("My Progress",
      style: TextStyle(fontSize: 25,fontFamily: "Poppins"),),SizedBox(
                height: 20,
               )
      ,Container(
            width: mediaQueryData.size.width*9/11,
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF0FD3D5)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                height: 20,
               ),
                CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 8.0,
                  percent: AccountData.weeklyProgresPercentage!/100, // Adjust the percentage as needed
                  center:
                   Text("${AccountData.weeklyProgresPercentage!}%",style: TextStyle(fontSize: 40,fontFamily: 
                  "Poppins",fontWeight: FontWeight.w600,color: Color(0xFF527EE7)),),
    
                  progressColor: Color(0xFF527EE7),
                ),SizedBox(
                
                height: 10,
               ),AutoSizeText(
              textAlign:TextAlign.left,
                "You have achived ${AccountData.weeklyProgresPercentage!}% of your weekly goal",
                style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,),
                maxLines: 2,
              ),
                
                SizedBox(
                
                height: 10,
               ),
                ElevatedButton(
                   style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF527EE7),
      minimumSize: Size(mediaQueryData.size.width*9/11 -50, 43), // Set the width and height as needed
      ),
                  onPressed: () async{
                    print("proges");
                    // Add your button's action here
                    print("awak ${AccountData.state}");
                    if(AccountData.state==1){
                   await AccountData.getData();
                  await Routes.put("progress");
                 
                  print("howwwwwwwwwwwwwww");
        }else{
       await   Routes.put("progress");
       print("bagaimanawwwwwwwwwwwwwwwwwwwwww");
          }
                    //setState((){});
                    
                  },
                  child: Text("See More",style: TextStyle(color: Colors.white),),
                ),
                SizedBox(
                height: 24,
                
               )
              ],
            ),
          ),SizedBox(
                height: 7,
                
               ),songContainer(context),SizedBox(
                height: 7,
                
               ),ieltContainer()
                ],)
                ),
               ))
               ,Container(
                width: mediaQueryData.size.width/11,
                color: Colors.white,
               )
            ],
          )
          
        ,bottomNavigationBar: BottomNavigationBar(backgroundColor: Color.fromARGB(255, 255, 255, 255),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
    
              icon: Icon(Icons.leaderboard),
              label: 'Leaderboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          currentIndex: 0,
          selectedItemColor: Color.fromARGB(255, 34, 143, 231), 
          unselectedItemColor: Colors.grey, 
        onTap: _onItemTapped,
      )),
      ),
    );
  }
  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text("Loading..."),
            ],
          ),
        );
      },
    );
  }
Widget songContainer(BuildContext context){
  String title ="Guess The Lyrics";
  String text="Choose song that you want and improve your listening skill in fun way!";
  return InkWell(onTap:() async{
    print("lets 1");
    showLoadingDialog(context);
    print("lets 2");
    try{
      int statcode=await SongSectionData.storeApi() ;
      await  SongSectionData.storeApiRec();
      if(statcode==200){print("lets 3");
    Navigator.pop(context);
    print("lets 4");
    Level.level="Easy";
    Routes.put("songSection");}else{Routes.off("home");
    }
    }catch(e){print(e);print("connection error");Routes.off("home");
    }},
  child:Container(
    padding: EdgeInsets.all(10) ,
    decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 158, 217, 218)),
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                        begin: Alignment(1, 0.1),
                        end: Alignment(0, 0.1),
                        colors: [
                          
                      Color.fromARGB(255, 180, 205, 245),
                      Color.fromARGB(255, 180, 205, 245).withOpacity(0.68),
                      Color.fromARGB(255, 218, 228, 245)
                      
                    ]
                    )
          ),
    width:mediaQueryData.size.width*9/11 ,
    
    child: Row(
      
      children: 
    
    [
      Container(
        width:mediaQueryData.size.width*6/11,
        alignment:Alignment.centerLeft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
          AutoSizeText(
            textAlign:TextAlign.left,
              title,
              style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,),
              maxLines: 1,
            ),
            AutoSizeText(
              text,
              style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.normal),
              maxLines: 3,
            )
          
        ]
        ),
      ),Expanded(child:Container(
        width:mediaQueryData.size.width*3/11,
        alignment: Alignment.centerLeft,
        child:  Image.asset("assets/images/musicHome.png"),
      ))
    ]
    ),
  ));
}

Widget ieltContainer(){
  String title ="Get Ready For IELTS";
  String text="prepare yourself for IELTS with various audio options!";
  return InkWell(onTap:()async{
    print("lets 1");
    showLoadingDialog(context);
    print("lets 2");
    try{
      int statcode=await SongSectionData.storeApiIelts() ;
      
      await SongSectionData.storeApiIeltsRec();
      if(statcode==200){print("lets 3");
    Navigator.pop(context);
    print("lets 4 aw");
    Level.level="Easy";
    print("permission");
    print(AccountData.permissionStatus);
    Routes.put("songSection");}else{Routes.off("home");
    }
    }catch(e){print(e);print("connection error");Routes.off("home");
    }},
  child:Container(
    padding: EdgeInsets.all(10) ,
    decoration: BoxDecoration(
            border: Border.all(color: Color.fromARGB(255, 85, 199, 201)),
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
                        begin: Alignment(1, 0.1),
                        end: Alignment(0, 0.1),
                        colors: [
                          
                      Color.fromARGB(255, 180, 205, 245),
                      Color.fromARGB(255, 180, 205, 245).withOpacity(0.68),
                      Color.fromARGB(255, 218, 228, 245)
                      
                    ]
                    )
          ),
    width:mediaQueryData.size.width*9/11 ,
    
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: 
    
    [
      Container(
        width:mediaQueryData.size.width*6/11,
        alignment:Alignment.centerLeft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
          AutoSizeText(
            textAlign:TextAlign.left,
              title,
              style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,),
              maxLines: 1,
            ),
            AutoSizeText(
              text,
              style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.normal),
              maxLines: 3,
            )
          
        ]
        ),
      ),Expanded(child:Container(
        width:mediaQueryData.size.width*3/11,
        alignment: Alignment.centerLeft,
        child:  Image.asset("assets/images/ieltHome.png"),
      ))
    ]
    ),
  ));
}
}
