import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/navigation.dart';
import 'package:lawyer/view/auth/signup_screen.dart';

import '../../components/button_widget.dart';

import '../../components/text_widget.dart';
import '../../components/textfield_widget.dart';
import '../../utils/utils.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? getemail;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<String> login() async {
    // getemail = await _firestore
    //     .collection('Users')
    //     .doc(usernameController.text)
    //     .get()
    //     .then((value) {
    //   return value['email'];
    // });

    String res = "some error occured";
    try {
      await _auth
          .signInWithEmailAndPassword(
              email: 'email', password: passController.text)
          .then((value) async {});
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: screenHeight(context),
              width: screenWidth(context),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/court.jpg'), fit: BoxFit.fill),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  margin: const EdgeInsets.all(20),
                  elevation: 0,
                  color: Colors.grey.withOpacity(0.85),
                  child: Container(
                    height: screenHeight(context) * 0.53,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const TextWidget(
                            text: 'Login',
                            size: 25,
                            fontWeight: FontWeight.bold,
                            letterspacing: 1.3,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const TextWidget(
                            alignment: Alignment.topLeft,
                            text: 'Username',
                            size: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          TextFieldWidget(
                            // height: 50,
                            // textcolor: MyColors.white,
                            hinttext: 'Enter Username',

                            keyboardtype: TextInputType.text,
                            controller: usernameController,
                            border: const Border(bottom: BorderSide(width: 1)),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Field cannot be empty";
                              }
                              return null;
                            },
                            onChanged: (value) {
                              final isValid = formKey.currentState!.validate();
                              if (!isValid) {
                                return;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const TextWidget(
                            alignment: Alignment.topLeft,
                            text: 'Password',
                            size: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          TextFieldWidget(
                            // height: 50,
                            // textcolor: MyColors.white,
                            hinttext: 'Enter Password',

                            keyboardtype: TextInputType.text,
                            controller: passController,
                            border: const Border(bottom: BorderSide(width: 1)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Field cannot be empty";
                              }
                              if (value.length < 6) {
                                return 'Atleast 6 character long';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              final isValid = formKey.currentState!.validate();
                              if (!isValid) {
                                return;
                              }
                            },
                          ),
                          ButtonWidget(
                            borderradius: BorderRadius.circular(10),
                            onTab: () async {
                              final isValid = formKey.currentState!.validate();
                              if (!isValid) {
                                return;
                              }
                              formKey.currentState!.save();

                              String res = await login();
                              if (res != 'success') {
                                showSnackBar(res, context);
                              }
                            },
                            text: 'Login',
                            bgcolor: Colors.black,
                            textcolor: Colors.white,
                            height: 35,
                            width: 120,
                            size: 20,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const TextWidget(
                            text: 'Have not any account?',
                            size: 17,
                            fontWeight: FontWeight.w500,
                          ),
                          TextButton(
                              onPressed: () {
                                MyNavigation()
                                    .push(context, const SignupScreen());
                              },
                              child: const TextWidget(
                                textcolor: Colors.black,
                                text: 'Sign up',
                                size: 19,
                                fontWeight: FontWeight.w900,
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
