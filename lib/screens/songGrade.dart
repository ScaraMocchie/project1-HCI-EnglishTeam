import '../controllers/accountMessage.dart';
import '../controllers/routes.dart';

import '../screens/persuasive_ad.dart';

import '../screens/homePage.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:get/get.dart';
import "./accountPage.dart";
import 'package:percent_indicator/percent_indicator.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../controllers/songPoint.dart';
import '../controllers/startSongQuiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controllers/accountData.dart';
import '../controllers/songSectionData.dart';
import '../widgets/songlevel.dart';
import '../controllers/httpHelp.dart';
class SongGrade extends StatefulWidget{
  SongGrade({super.key});

  @override
  _SongGrade createState() => _SongGrade();
}

class _SongGrade extends State<SongGrade>{
String pageName = "SongGrade";
MediaQueryData mediaQueryData = MediaQueryData.fromWindow(ui.window);
int option=0;

Widget wrapper(int options){
  Routes.tempContext=context;
//  print("tes");
if(options==0){
  return InkWell(
    onTap: (){setState((){this.option=1;});},
    child:Container(
    
    width: 197,padding: EdgeInsets.all(3),
    height: 36,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.blue,
      
    ),
    child: Row(children: [
      Container(
        padding: EdgeInsets.all(8),
        width: 90,
        child: AutoSizeText("My Answers",style: TextStyle(fontSize: 3,fontFamily: "Poppins",color: Colors.blue)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.white,
        ),
      ),
      Container(
        padding: EdgeInsets.all(5),
        width:98,
        child: AutoSizeText("Right Answers",style: TextStyle(fontSize: 3,fontFamily: "Poppins",color: Colors.white),)
      )
    ],
    ),
  ));
}
else{
  return InkWell(
    onTap: (){setState((){this.option=0;});}
    ,child: Container(
    
    width: 197,padding: EdgeInsets.all(3),
    height: 36,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.blue,
      
    ),
    child: Row(children: [
      Container(
        padding: EdgeInsets.all(8),
        width: 90,
        child: AutoSizeText("My Answers",style: TextStyle(fontSize: 3,fontFamily: "Poppins",color: Colors.white))
      ),
      Container(
        padding: EdgeInsets.all(5),
        width:98,
        child: AutoSizeText("Right Answers",style: TextStyle(fontSize: 3,fontFamily: "Poppins",color: Colors.blue),),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
      color: Colors.white,
        ),
      )
    ],
    ),
  ));
}
}
void finish()async{
  if(AccountData.sendingScoreState==0){
    AccountData.sendingScoreState=1;
    int tempPoints=100;
    if(Level.level=="Easy"){tempPoints=100;}
    else if(Level.level=="Medium"){tempPoints=200;}
    else{tempPoints=300;}
    PointData. points=(PointData.percentage!*tempPoints).toInt()-PointData.replays*2;
    print(PointData. points);
    print(tempPoints);
    print(PointData.replays);
    print("jadi kan");
    List<int> data=[AccountData.userId!,PointData. points,PointData.replays];
    if(SongSectionData.audioType!="Ielts")
    {
      var    response= await http.post(Uri.https(Helper.baseUrl,Helper.baseApi+"updateDataBySong"),
                  body:jsonEncode(data));
                  PointData.replays=0;
                 PointData. points=0;
                  AccountData.sendingScoreState=0;
                  AccountData.state=1;
                  print("hu${AccountData.state}");
                 await  AccountData.getData();
                 AccountData.playedAudioToday+=1;
  if (AccountData.playedAudioToday%3==0 && AccountData.permissionStatus!=1){
    Routes.off("ads");
  }
  else{
    Routes.tempContext=context;
    Routes.offAll();
  }
  }else{
    var    response= await http.post(Uri.https(Helper.baseUrl,Helper.baseApi+"updateDataByIelts"),
                  body:jsonEncode(data));
                  PointData.replays=0;
                  PointData.points=0;
                   AccountData.sendingScoreState=0;
                    AccountData.state=1;
                    print("aw ${AccountData.state}");
                    await  AccountData.getData();
                     AccountData.playedAudioToday+=1;
  if (AccountData.playedAudioToday%3==0 && AccountData.permissionStatus!=1){
    Routes.off("ads");
  }
  else{
    Routes.offAll();
  }
  }
    
  }
  
}

double progres=PointData.percentage!;
String result="Great Job!";

@override
Widget build(BuildContext context){
  Routes.tempContext=context;
  print("rebuild");
  return  SafeArea(
      child: Scaffold(
        body:Row(
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
             SizedBox(
              height: 20,
             )
    ,Container(
          width: mediaQueryData.size.width*9/11,
          // height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            
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
                percent: progres, // Adjust the percentage as needed
                center:
                 Text("${(progres*100).round()}%",style: TextStyle(fontSize: 40,fontFamily: 
                "Poppins",fontWeight: FontWeight.w600,color: Color(0xFF527EE7)),),

                progressColor: Color(0xFF527EE7),
              ),SizedBox(
              
              height: 10,
             ),AutoSizeText(
            textAlign:TextAlign.left,
              "${result}",
              style: TextStyle(fontFamily: "Poppins",fontWeight: FontWeight.bold,fontSize: 35),
              maxLines: 2,
            ),
              SizedBox(
              
              height: 10,
             ),Container(
              width: mediaQueryData.size.width*9/11,
              alignment: Alignment.centerLeft,
              child:wrapper(this.option)),
              
              SizedBox(
              height: 24,
              
             ),Container( //tempat jawaban user
              // padding: EdgeInsets.all(8),
  width: mediaQueryData.size.width*9/11, // Set your desired width
  // height: 200, // Set your desired height
  decoration: BoxDecoration(
    // border: Border.all(color: Colors.blue),
    // borderRadius: BorderRadius.circular(15),
  ),
  child: chooseAnswer()

)
            ],
          ),
        ),
              
              SizedBox(
              
              height: 10,
             ),
              ElevatedButton(
                 style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF527EE7),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
    minimumSize: Size(mediaQueryData.size.width*9/11 , 46), // Set the width and height as needed
  ),
                onPressed: () {
                  AccountMessage.showLoadingDialog(context);
                  finish();
                  
                  },
                child: Text("Finish Review",style: TextStyle(color: Colors.white),),
              ),
              SizedBox(height: 30,)
              ]/*utama*/
              ,)
              ),
             ))
             ,Container(
              width: mediaQueryData.size.width/11,
              color: Colors.white,
             )
          ],
        )
      )
      );
}

String infoPoint(double? based){
  if(based! >=0.8){
    return "Correct";
  } else if(based! <0.8 && based! >=0.4){
    return "Nearly Correct";
  }
  else if(based < 0.4 && based! >= 0.1){
    return "Incorrect";
  }
  else{
    return "Completely Incorrect";
  }
}

Color chooseByPoint(double? based){
  if(based! >=0.8){
    return Color(0xff1EA108);
  }else if(based! <0.8 && based! >=0.4){
    return Color(0xffE0B419);
  }
  else if(based < 0.4 && based! >= 0.1){
    return const Color(0xffCC0000);
  }else{
    return Color(0xff5C5C5C);
  }
}

Widget userAnswer(){
  return Column(
    children: [
      answerBox("Audio 1", infoPoint(PointData.answerPoint1), StartSong.userLyric1!, chooseByPoint(PointData.answerPoint1)),
      SizedBox(height: 10,),
      answerBox("Audio 2", infoPoint(PointData.answerPoint2), StartSong.userLyric2!, chooseByPoint(PointData.answerPoint2)),
      SizedBox(height: 10,),
      answerBox("Audio 3", infoPoint(PointData.answerPoint3), StartSong.userLyric3!, chooseByPoint(PointData.answerPoint3)),
      SizedBox(height: 30,)
    ],
  );
  // ListView(
  //         children: [
  //           Text("ANSWER 1"),
  //           AutoSizeText
  //           (StartSong.userLyric1!,style:TextStyle(color:chooseByPoint(PointData.answerPoint1))
  //           ,maxLines:6),
  //           Text("ANSWER 2"),
  //           AutoSizeText
  //           (StartSong.userLyric2!,style:TextStyle(color:chooseByPoint(PointData.answerPoint2))
  //           ,maxLines:6),
  //           Text("ANSWER 3"),
  //           AutoSizeText
  //           (StartSong.userLyric3!,style:TextStyle(color:chooseByPoint(PointData.answerPoint3))
  //           ,maxLines:6),
            
  //           // Add more content as needed
  //         ],
  //       );
}

Container answerBox(String audio, String info, String text, Color color) {
  return Container(
      padding: EdgeInsets.all(0),
      // height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color:color)
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          
            
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(topRight: Radius.circular(9), topLeft: Radius.circular(9))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headerText(audio),
                Container(width: mediaQueryData.size.width*5/10, alignment: Alignment.centerRight, child: headerText(info))
              ],
            ),
          ),
          Container(
            color: color.withOpacity(0.2),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            child: Text(text),
          )
        ],
      ),
    );
}

Text headerText(String text) => Text(text, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: "Poppins"),);
Widget rightAnswer(){
  return Column(
    children: [
      answerBox("Audio 1", "", StartSong.lyric1!, Color(0xff1CC2D9)),
      SizedBox(height: 10,),
      answerBox("Audio 2", "", StartSong.lyric2!, Color(0xff1CC2D9)),
      SizedBox(height: 10,),
      answerBox("Audio 3", "", StartSong.lyric3!, Color(0xff1CC2D9)),
      SizedBox(height: 30,)
    ],
  );
  // ListView(
  //         children: [
  //           Text("ANSWER 1"),
  //           AutoSizeText(StartSong.lyric1!,style:TextStyle(color:Colors.black)
  //           ,maxLines:6),// Add your content here, such as other containers and images
  //           Text("ANSWER 2"),
  //           AutoSizeText(StartSong.lyric2!,style:TextStyle(color:Colors.black)
  //           ,maxLines:6),
  //           Text("ANSWER 3"),
  //           AutoSizeText(StartSong.lyric3!,style:TextStyle(color:Colors.black)
  //           ,maxLines:6),
            
  //           // Add more content as needed
  //         ],
  //       );
}
Widget chooseAnswer(){
  if(this.option==0){return userAnswer() ; }
  else{return rightAnswer(); }
 
}
}
