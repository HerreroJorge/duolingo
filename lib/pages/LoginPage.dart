// ignore_for_file: prefer_const_constructors, sort_child_properties_last, file_names

import 'package:duolingo/pages/Home.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
   Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(child: body(context, formKey, userController, passController)),
    );
   }     
}

Widget body(BuildContext context, formKey, userController, passController){
  return Container(
    key: formKey,
    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 360),
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/login.jpg'),
        fit: BoxFit.cover
      )
    ),
    child: Center(
      child: Container(
        color: Color.fromARGB(120, 62, 62, 62),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sign in',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.bold
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              child: TextField(
                controller: userController,
                decoration: InputDecoration(
                  hintText: "User",
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  //border: InputBorder(borderSide: BorderSide(width: 2, color: Color.fromARGB(255, 0, 0, 0)))
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(3),
              child: TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Password",
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  //border: InputBorder(borderSide: BorderSide(width: 2, color: Color.fromARGB(255, 0, 0, 0)))
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color.fromARGB(255, 202, 22, 22),
                              Color.fromARGB(255, 166, 166, 166),
                              Color.fromARGB(255, 20, 88, 144),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        textStyle: const TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        if (userController.text == "user" && passController.text == "user") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>Home())
                          );
                        }
                      },
                      child: const Text('LOGIN'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    )
  );
}