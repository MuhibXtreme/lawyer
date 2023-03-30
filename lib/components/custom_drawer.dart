import 'package:flutter/material.dart';
import 'package:lawyer/components/navigation.dart';

import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/utils/utils.dart';
import 'package:lawyer/view/view/Admin/cases/cases.dart';
import 'package:lawyer/view/view/Admin/client/clients.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: screenWidth(context) * 0.65,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avator.png'),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.dashboard,
                color: MyColors.primarycolor,
                size: 25,
              ),
              title: TextWidget(
                text: 'Dashboard',
                size: 20,
                textcolor: MyColors.primarycolor,
              ),
            ),
            ListTile(
              onTap: () {
                MyNavigation.push(context, const Clients());
              },
              leading: Icon(
                Icons.people,
                color: MyColors.primarycolor,
                size: 25,
              ),
              title: TextWidget(
                text: 'Clients',
                size: 20,
                textcolor: MyColors.primarycolor,
              ),
            ),
            ListTile(
              onTap: () {
                MyNavigation.push(context, const Cases());
              },
              leading: Icon(
                Icons.cases_rounded,
                color: MyColors.primarycolor,
                size: 25,
              ),
              title: TextWidget(
                text: 'Cases',
                size: 20,
                textcolor: MyColors.primarycolor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
