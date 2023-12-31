import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import '../controllers/routes.dart';
import '../screens/song_ans_page2.dart';
import '../controllers/startSongQuiz.dart';
import '../controllers/songPoint.dart';
import '../controllers/songSectionData.dart';

class SongAns extends StatefulWidget {
  const SongAns({super.key});

  @override
  State<SongAns> createState() => _SongAnsState();
}

class _SongAnsState extends State<SongAns> {
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
  String pageName = "SongAns";
  double _initial = 0.3;
  int start=0;
  int playing=0;
  void updateProgress() {
    setState(() {
     // _initial += 0.35;
    });
  }
 
  String? titleMusic = StartSong.title;
  String? singer = StartSong.singer;
  String? albumCover = StartSong.imageLink;
  String  titleHeadBar="Guess The Lyrics";
   AudioPlayer? player = StartSong.player1;
  
  Future<void> playMusic(String url) async {
    print("play");
    if(playing==0){
      playing=1;
      if(start==0){await player!.play();start=1;playing=0;}
    else{print("replay"); PointData.replays+=1;player=await StartSong.getAudio(StartSong.forPlayer1);await player!.play();playing=0;}}
    else{print("tunggu");}
    
  }

  Future<void> stopMusic() async {
    await player!.stop();
  }

  final userAnswer = TextEditingController();

  @override
  void dispose() {
    userAnswer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    Routes.tempContext=context;
    if(SongSectionData.audioType=="Ielts"){
      titleHeadBar="Guess The Subtitles";
    }
    return WillPopScope(child:
    Scaffold(
        appBar: AppBar(
          leading: SizedBox(),
          // IconButton(
          //   onPressed: () {Routes.getBack();},
          //   icon: const Icon(Icons.arrow_back_ios_new_rounded),
          //   color: Colors.black,
          // ),
          centerTitle: true,
          title: Text(
            titleHeadBar,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: const Color(0xffE9E9E9),
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xffE9E9E9),
          ),
          child: ListView(
            children: <Widget>[
              Container(
                height: 50,
                padding: const EdgeInsets.all(20),
                color: const Color(0xffE9E9E9),
                child: LinearProgressIndicator(
                  backgroundColor: const Color(0xffFFFFFF),
                  valueColor: const AlwaysStoppedAnimation(Color(0xff15CAD7)),
                  value: _initial,
                  minHeight: 10,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          titleMusic!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                          alignment: Alignment.centerLeft, child: Text(singer!)),
                    )
                  ],
                ),
              ),
              Container(
                height: 60,
                margin: const EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 5.0,
                        offset: Offset(0, 5),
                      ),
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    (SongSectionData.audioType!="Ielts")?
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(albumCover!),
                    ):CircleAvatar(
              radius: 25,
              backgroundImage:  AssetImage("assets/images/ieltHome.png")
          
            ),
                    const Image(
                      image: AssetImage('assets/images/waveform-audio.png'),
                    ),
                    IconButton(
                      // hoverColor: Colors.red,
                      onPressed: () {
                        playMusic(
                            "Ed_Sheeran_Thinking_Out_Loud_Official_Audio.mp3");
                      },
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        size: 35,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 370,
                padding: const EdgeInsets.all(30),
                // color: Colors.purpleAccent,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Your Answer",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: userAnswer,
                        expands: true,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color(0xffFFFFFF),
                          // contentPadding: EdgeInsets.only(bottom: 230),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.only(left: 30, right: 30),
                // color: Colors.amber,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xff527EE7)),
                    foregroundColor:
                        MaterialStateProperty.all(const Color(0xffFFFFFF)),
                  ),
                  onPressed: () async{
                  //  updateProgress();
                    stopMusic();
                
                    StartSong.userLyric1=userAnswer.text;
                    showLoadingDialog(context);
                    await StartSong.getStatus2(context);
                   // Get.toNamed('/2', arguments: _initial);
                  },
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        )), onWillPop: ()async{Routes.offAll();return true;});
  }
}
