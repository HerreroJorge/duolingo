// ignore_for_file: prefer_const_constructors, sort_child_properties_last, file_names
import 'package:duolingo/pages/games/AudioGame.dart';
import 'package:duolingo/pages/games/ImageGame.dart';
import 'package:duolingo/pages/games/TextGame.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
   Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Home'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.jpeg'),
            fit: BoxFit.cover
          )
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color.fromARGB(150, 76, 175, 79)
              ),
              padding: EdgeInsets.all(30.0),
              margin: EdgeInsets.all(50.0),
              child: Center(
                child: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>TextGame(-1))
                    );
                  },
                  child: Row(
                    children: const [
                      Text('Text Game   ',
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.text_fields)
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color.fromARGB(150, 76, 175, 79)
              ),
              padding: EdgeInsets.all(30.0),
              margin: EdgeInsets.all(50.0),
              child: Center(
                child: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>ImageGame(-1))
                    );
                  },
                  child: Row(
                    children: const [
                      Text('Image Game   ',
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.image)
                    ],
                  ),
                  style: ButtonStyle(
                    //padding:
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color.fromARGB(150, 76, 175, 79)
              ),
              padding: EdgeInsets.all(30.0),
              margin: EdgeInsets.all(50.0),
              child: Center(
                child: TextButton(
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>AudioGame(-1))
                    );
                  },
                  child: Row(
                    children: const [
                      Text('Audio Game   ',
                        style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.audiotrack)
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}