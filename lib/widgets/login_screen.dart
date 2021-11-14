import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:to_do_list/domain/user.dart';
import 'package:to_do_list/utils.dart';
import 'package:to_do_list/widgets/main_screen.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreenWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  bool checkEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  bool checkPassword(String password) {
    return password.length >= 5;
  }

  void handleOnClick() {
    String email = emailController.text;
    String password = passwordController.text;

    if(!checkEmail(email) || !checkPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Email address or password is not valid",
              style: TextStyle(color: Colors.pinkAccent, fontSize: 18)
          ),
          backgroundColor: Colors.white
      ));
    }
    else {
      User? userFound = Utils.usersRepo.findUserByEmailAndPassword(email, password);

      if(userFound == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Invalid credentials",
                style: TextStyle(color: Colors.pinkAccent, fontSize: 18)
            ),
            backgroundColor: Colors.white
        ));
      }
      else {
        Utils.currentUser = userFound;
        log("login widget: current user is set to ${Utils.currentUser}");
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const MainScreenWidget()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Login Page",
          style: TextStyle(color: Colors.pinkAccent, fontSize: 25),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
                height: 120
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pinkAccent, width: 0.5),
                    ),
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.pinkAccent),
                    hintText: 'Enter valid email id as abc@gmail.com'),
                controller: emailController,
                ),
            ),
            const SizedBox(
                height: 30
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.pinkAccent, width: 0.5),
                    ),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.pinkAccent),
                    hintText: 'Enter secure password'),
                  controller: passwordController
              ),
            ),
            const SizedBox(
                height: 50
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: FlatButton(
                onPressed: () {
                  handleOnClick();
                },
                shape: RoundedRectangleBorder(side: const BorderSide(
                    color: Colors.pinkAccent,
                    width: 1,
                    style: BorderStyle.solid
                  ), borderRadius: BorderRadius.circular(50)
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.pinkAccent, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}