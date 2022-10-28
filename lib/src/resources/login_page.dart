import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icab_firebase/src/blocs/auth_bloc.dart';
import 'package:flutter_icab_firebase/src/fire_base/fire_base_auth.dart';
import 'package:flutter_icab_firebase/src/resources/dialog/loading_dialog.dart';
import 'package:flutter_icab_firebase/src/resources/dialog/msg_dialog.dart';

import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthBloc _authBloc = AuthBloc();
  String? errorMessage = " ";

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signIn() async {
    var isValid = _authBloc.isValidLogin(
        _controllerEmail.text.toString(), _controllerPassword.text.toString());
    if (isValid) {
      LoadingDialog.showLoadingDialog(context, "Loading ...");
      try {
        await Auth()
            .signInWithEmailAndPassword(
                email: _controllerEmail.text.toString(),
                password: _controllerPassword.text.toString())
            .then((_) {
          LoadingDialog.hideLoadingDialog(context);
        });
      } on FirebaseAuthException catch (e) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, "Sign-in faild", e.message.toString());
      }
    }
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 140,
            ),
            Image.asset('ic_car_green.png'),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 6),
              child: Text(
                "Welcome Back!",
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            ),
            const Text(
              "Login to continue using iCab",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 145, 0, 20),
              child: StreamBuilder(
                  stream: _authBloc.emailStream,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: _controllerEmail,
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                      decoration: InputDecoration(
                        errorText: snapshot.hasError
                            ? snapshot.error.toString()
                            : null,
                        labelText: "Email",
                        prefixIcon: SizedBox(
                            width: 50, child: Image.asset("ic_mail.png")),
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black54, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                      ),
                    );
                  }),
            ),
            StreamBuilder(
                stream: _authBloc.passStream,
                builder: (context, snapshot) {
                  return TextField(
                    controller: _controllerPassword,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    obscureText: true,
                    decoration: InputDecoration(
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                      labelText: "Password",
                      prefixIcon: SizedBox(
                          width: 50, child: Image.asset("ic_phone.png")),
                      border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  );
                }),
            Container(
              constraints:
                  BoxConstraints.loose(const Size(double.infinity, 30)),
              alignment: AlignmentDirectional.centerEnd,
              child: const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            Text(errorMessage == " " ? " " : "$errorMessage"),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: signIn,
                  child: const Text(
                    "Log In",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: RichText(
                text: TextSpan(
                    text: "New user? ",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterPage()));
                            },
                          text: "Sign up for a new account",
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 16))
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
