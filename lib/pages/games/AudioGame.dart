// ignore_for_file: prefer_const_constructors, sort_child_properties_last, file_names
import 'dart:convert';
import 'dart:math';

import 'package:duolingo/models/AudioModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioGame extends StatefulWidget {
  final int previousId;

  const AudioGame(this.previousId, {super.key});

  @override
  State<AudioGame> createState() => _AudioGameState();
}

class _AudioGameState extends State<AudioGame> {
  late Future<AudioModel> selectedAudio;
  TextEditingController textController = TextEditingController();
  int success = -1;
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<AudioModel> getAudio() async {
    final json = await rootBundle.loadString('assets/audios.json');
    List<AudioModel> audios = [];
    final jsonData = jsonDecode(json);

    for (var item in jsonData){
      audios.add(AudioModel(item['id'], item['path'], item['es']));
    }
    AudioModel randomAudio = await getRandomAudio(audios);
    return getRandomAudio(audios);
  }

  AudioModel getRandomAudio(List<AudioModel> audios){
    var random = Random().nextInt(audios.length);
    while(random == widget.previousId){
      random = Random().nextInt(audios.length);
    }
    return audios[random];
  }

  String formatTime(Duration duration){
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }
  

  @override
  void initState(){
    super.initState();
    selectedAudio = getAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
   Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Audio Game'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.jpeg'),
            fit: BoxFit.cover
          )
        ),
        child: FutureBuilder(
          future: selectedAudio,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color.fromARGB(110, 120, 120, 120),
                      border: Border.all(color: Color.fromARGB(255, 151, 151, 151), width: 1.0)
                    ),
                    padding: EdgeInsets.all(20.0),
                    margin: EdgeInsets.all(30.0),
                    child: Center(
                      child: TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>AudioGame(snapshot.data!.id))
                          );
                        },
                        child: Row(
                          children: const [
                            Text('Refresh',
                              style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.update, color: Colors.white, size: 40,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        children: [
                          Slider(
                            min: 0,
                            max: duration.inSeconds.toDouble(),
                            value: position.inSeconds.toDouble(),
                            onChanged: (value) async {},
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(formatTime(position)),
                                Text(formatTime(duration - position))
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 35,
                            child: IconButton(
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                              ),
                              iconSize: 50,
                              onPressed: () async {
                                if (isPlaying){
                                  await audioPlayer.pause();
                                }
                                else {
                                  await audioPlayer.play(AssetSource('audios/${snapshot.data!.path}'));
                                }
                              },
                            ),
                          )
                        ]
                      )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: const Color.fromARGB(140, 76, 175, 79)
                    ),
                    padding: EdgeInsets.all(35.0),
                    margin: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        children: [
                          TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: "Write the object in Spanish",
                              iconColor: Color.fromARGB(255, 255, 255, 255),
                              fillColor: Color.fromARGB(80, 159, 255, 162),
                              filled: true,
                              //border: InputBorder(borderSide: BorderSide(width: 2, color: Color.fromARGB(255, 0, 0, 0)))
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: const Color.fromARGB(150, 76, 175, 79)
                            ),
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                            child: Center(
                              child: TextButton(
                                onPressed: (){
                                  if (textController.text == snapshot.data?.es) {
                                    setState(() {
                                      success = 1;
                                    });
                                  }else{
                                    setState(() {
                                      success = 0;
                                    });
                                  }
                                },
                                child: Text('CHECK',
                                  style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                                  ),
                                )
                              ),
                            ),
                          ),
                          if (success >= 0)  Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color.fromARGB(130, 255, 255, 255)
                            ),
                            padding: EdgeInsets.all(30.0),
                            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                            child: Center(
                              child: Column(
                                children: [
                                  if (success == 1) Row(
                                    children: const [
                                      Text('CORRECT', style: 
                                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(200, 76, 175, 79)),
                                      ),
                                      Spacer(),
                                      Icon(Icons.update, color: Color.fromARGB(200, 76, 175, 79), size: 40,)
                                    ],
                                  )
                                  else if (success == 0) Row(
                                    children: const [
                                      Text('INCORRECT', style: 
                                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(198, 255, 23, 23)),
                                      ),
                                      Spacer(),
                                      Icon(Icons.update, color: Color.fromARGB(198, 255, 23, 23), size: 40,)
                                    ],
                                  )
                                ],
                              )
                            )
        
                          )
                        ],
                      ),
                    ),
                  ),
                ],      
              );
            }
            else if(snapshot.hasError){
              print(snapshot.error);
              return Text('Error');
            }
            return Center(
              child: CircularProgressIndicator()
            );
          }
        ),
      )
    );
  }
}