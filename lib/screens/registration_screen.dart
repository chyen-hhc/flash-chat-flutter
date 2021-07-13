import 'package:flash_chat/components/rounded_button.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flash_chat/components/alert_box.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool _obscureText = false;
  String _password = '';
  String _email = '';
  bool _saving = false;
  String _displayName = '';

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
                    height: 160.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 38.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  _displayName = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your name'),
              ),
              SizedBox(
                height: 4.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  _email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 4.0,
              ),
              TextField(
                onChanged: (value) {
                  //Do something with the user input.
                  _password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password', enabled: true),
                obscureText: !_obscureText,
                //validator: (val) => val.length < 6 ? 'Password too short.' : null,
                //onSaved: (val) => _password = val,
              ),
              SizedBox(
                height: 8,
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
                  setState(() {
                    _saving = true;
                  });
                  if (EmailValidator.validate(_email) && _password.length > 5) {
                    try {
                      final newUser = await _auth
                          .createUserWithEmailAndPassword(
                              email: _email, password: _password)
                          .then((value) {
                        value.user.updateDisplayName(_displayName);
                      });

                      Navigator.pushNamed(context, LoginScreen.id);

                      setState(() {
                        _saving = false;
                      });
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        _saving = false;
                        createAlert(context, e.message);
                      });
                      print(e.code);
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
                color: Colors.blueAccent,
                title: 'Register',
              )
            ],
          ),
        ),
      ),
    );
  }
}
