import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icab_firebase/src/fire_base/fire_base_auth.dart';
import 'package:flutter_icab_firebase/src/resources/dialog/loading_dialog.dart';
import 'package:flutter_icab_firebase/src/resources/dialog/msg_dialog.dart';

import '../blocs/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthBloc authBloc = AuthBloc();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> createrUser() async {
    var isValid = authBloc.isValid(
        _nameController.text.toString(),
        _emailController.text.toString(),
        _passController.text.toString(),
        _phoneController.text.toString());
    if (isValid) {
      LoadingDialog.showLoadingDialog(context, "Loading ...");
      try {
        await Auth()
            .createUserWithEmailAndPassword(
                email: _emailController.text.toString(),
                password: _passController.text.toString())
            .then(
          (_) {
            Auth().createUserInRealtime(
                fullName: _nameController.text.toString(),
                phone: _phoneController.text.toString(),
                email: _emailController.text.toString(),
                password: _passController.text.toString());
            LoadingDialog.hideLoadingDialog(context);
            Navigator.pop(context);
          },
        );
      } on FirebaseAuthException catch (e) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, "Sign-up faild", e.message.toString());
      }
    }
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black54),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: const BoxConstraints.expand(),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Image.asset('ic_car_red.png'),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 6),
                child: Text(
                  "Welcome Aboard!",
                  style: TextStyle(fontSize: 22, color: Colors.black),
                ),
              ),
              const Text(
                "Signup with iCab in simple steps",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 80, 0, 20),
                child: StreamBuilder(
                  stream: authBloc.nameStream,
                  builder: (context, snapshot) => TextField(
                    controller: _nameController,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                      labelText: "Name",
                      prefixIcon: SizedBox(
                          width: 50, child: Image.asset("ic_user.png")),
                      border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 20),
                child: StreamBuilder(
                  stream: authBloc.phoneStream,
                  builder: (context, snapshot) => TextField(
                    controller: _phoneController,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                      labelText: "Phone Number",
                      prefixIcon: SizedBox(
                          width: 50, child: Image.asset("ic_phone.png")),
                      border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 20),
                child: StreamBuilder(
                  stream: authBloc.emailStream,
                  builder: (context, snapshot) => TextField(
                    controller: _emailController,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    decoration: InputDecoration(
                      errorText:
                          snapshot.hasError ? snapshot.error.toString() : null,
                      labelText: "Email",
                      prefixIcon: SizedBox(
                          width: 50, child: Image.asset("ic_mail.png")),
                      border: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black54, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  ),
                ),
              ),
              StreamBuilder(
                stream: authBloc.passStream,
                builder: (context, snapshot) => TextField(
                  controller: _passController,
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                    errorText:
                        snapshot.hasError ? snapshot.error.toString() : null,
                    labelText: "Password",
                    prefixIcon:
                        SizedBox(width: 50, child: Image.asset("ic_lock.png")),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black54, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: createrUser,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: RichText(
                  text: TextSpan(
                      text: "Already a User? ",
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                            text: "Login now",
                            style: const TextStyle(
                                color: Colors.blue, fontSize: 16))
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
