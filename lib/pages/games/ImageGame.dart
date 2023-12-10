// ignore_for_file: prefer_const_constructors, sort_child_properties_last, file_names
import 'dart:convert';
import 'dart:math';

import 'package:duolingo/models/ImageModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ImageGame extends StatefulWidget {
  final int previousId;

  const ImageGame(this.previousId, {super.key});

  @override
  State<ImageGame> createState() => _ImageGameState();
}

class _ImageGameState extends State<ImageGame> {
  late Future<ImageModel> selectedImage;
  TextEditingController textController = TextEditingController();
  int success = -1;

  Future<ImageModel> getImage() async {
    final json = await rootBundle.loadString('assets/images.json');
    List<ImageModel> images = [];
    final jsonData = jsonDecode(json);

    for (var item in jsonData){
      images.add(ImageModel(item['id'], item['path'], item['en']));
    }
    ImageModel randomImage = await getRandomImage(images);
    return getRandomImage(images);

  }

  ImageModel getRandomImage(List<ImageModel> images){
    var random = Random().nextInt(images.length);
    while(random == widget.previousId){
      random = Random().nextInt(images.length);
    }
    return images[random];
  }

  @override
  void initState(){
    super.initState();
    selectedImage = getImage();
  }

  @override
   Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Image Game'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.jpeg'),
            fit: BoxFit.cover
          )
        ),
        child: FutureBuilder(
          future: selectedImage,
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
                            MaterialPageRoute(builder: (context)=>ImageGame(snapshot.data!.id))
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
                      child: Image.asset('assets/images/${snapshot.data!.path}')
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
                              hintText: "Write the object in English",
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
                                  if (textController.text == snapshot.data?.en) {
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