import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flash_chat/components/alert_box.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool _saving = false;
  bool _obscureText = false;
  String _password = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _saving,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  _email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  _password = value;
                },
                obscureText: !_obscureText,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password.',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              SizedBox(
                height: 20.0,
                child: Row(
                  children: [
                    Checkbox(
                        value: _obscureText,
                        onChanged: (value) {
                          setState(() {
                            _obscureText = value;
                          });
                        }),
                    Text("Show"),
                  ],
                ),
              ),
              RoundedButton(
                onPressed: () async {
                  //Implement login functionality.
                  setState(() {
                    _saving = true;
                  });
                  if (EmailValidator.validate(_email) && _password.length > 5) {
                    try {
                      final log = await _auth.signInWithEmailAndPassword(
                          email: _email, password: _password);
                      if (log != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        _saving = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  } else if (_password.length > 5) {
                    setState(() {
                      _saving = false;
                      createAlert(context, 'Please enter valid email');
                    });
                  } else {
                    setState(() {
                      _saving = false;
                      createAlert(context, 'Please enter valid password.');
                    });
                  }
                },
                color: Colors.lightBlueAccent,
                title: 'Log In',
              )
            ],
          ),
        ),
      ),
    );
  }
}
