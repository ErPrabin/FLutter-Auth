import 'package:authexample/services/auth.dart';
import 'package:authexample/shared/constant.dart';
import 'package:authexample/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function
      toggleView; //when passing function as argument, we define it in constructor level like this..
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()// for showing loading symbol if loading is true
        : Scaffold(
            backgroundColor: Colors.brown[50],
            appBar: AppBar(
              title: Text("Sign in"),
              backgroundColor: Colors.brown[200],
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget
                          .toggleView(); // this.toogleView() call in state level, but define it in constructor level so, we use widget.toggleView()
                    },
                    icon: Icon(Icons.person),
                    label: Text('Register'))
              ],
            ),
            body: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          // textInputDecoration.copyWith(hintText: 'Email').. here copywith (hinttext) is used because not all textform field have same hindtext value.
                          decoration: textInputDecoration.copyWith(
                              hintText:
                                  'Email'), //textINputDecoration is a const variable declared in constant.dart. Since it is a shared variable so it is declared is seprate dart file and is imported by others
                          validator: (val) =>
                              val.isEmpty ? 'Enter Email' : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              hintText: 'Password'),
                          validator: (val) => val.length < 6
                              ? 'Password should be greater than 6 character.'
                              : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        SizedBox(height: 20.0),
                        RaisedButton(
                            elevation: 6.0,
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.pink[400],
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;//loading is true so show loading
                                });
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email,
                                        password); //return type of registerWithEmailAndPassword is null or string soo it is dynamic
                                if (result == null) {
                                  setState(() {
                                    error =
                                        'Couldnot Sign In with provided detail!!';
                                    loading = false;//loading is false so show Scaffold
                                  });
                                }
                              }
                            }),
                        SizedBox(height: 20.0),
                        Text(error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0))
                      ],
                    ))),
          );
  }
}
