import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:lawyer/components/custom_drawer.dart';
import 'package:lawyer/components/navigation.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/view/View/auth/signin_screen.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: const Text('AdminHome'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut();
                MyNavigation.pushstatic(context, const SigninScreen());
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      drawer: const CustomDrawer(),
    );
  }
}
