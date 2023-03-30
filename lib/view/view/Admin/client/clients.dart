import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/button_widget.dart';
import 'package:lawyer/components/navigation.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/view/view/Admin/client/ad_clients.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../components/textfield_widget.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController search = TextEditingController();
  String? username;

  @override
  void initState() {
    super.initState();
    getname();
  }

  void getname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    print(username);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: const Text('Clients'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: TextFieldWidget(
                  read: false,
                  height: 40,
                  width: 180,
                  hinttext: 'Search Client',
                  keyboardtype: TextInputType.text,
                  controller: search,
                  border: const Border(bottom: BorderSide(width: 1)),
                ),
              ),
              ButtonWidget(
                onTab: () {},
                text: 'Search',
                textcolor: Colors.white,
                size: 18,
                bgcolor: MyColors.primarycolor,
                height: 40,
                width: 120,
                borderradius: BorderRadius.circular(10),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder(
                stream: _firestore
                    .collection('Users')
                    .doc(username)
                    .collection('Clients')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  if (snapshot.data?.size == 0) {
                    return const CircularProgressIndicator();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 70),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 10,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const CircleAvatar(
                                      radius: 45,
                                      backgroundImage:
                                          AssetImage('assets/avator.png'),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            text: snapshot.data!.docs[index]
                                                ['name'],
                                            size: 20,
                                            fontWeight: FontWeight.w500,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextWidget(
                                            text: snapshot.data!.docs[index]
                                                ['mobileno'],
                                            size: 15,
                                            fontWeight: FontWeight.w400,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextWidget(
                                            text: snapshot.data!.docs[index]
                                                ['email'],
                                            size: 15,
                                            fontWeight: FontWeight.w400,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              MyNavigation.push(
                                                  context,
                                                  AdClients(
                                                    action: 'edit',
                                                    email: snapshot.data!
                                                        .docs[index]['email'],
                                                  ));
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                            color: Colors.red,
                                            onPressed: () {
                                              _firestore
                                                  .collection('Users')
                                                  .doc(username)
                                                  .collection('Clients')
                                                  .doc(snapshot.data!
                                                      .docs[index]['email'])
                                                  .delete();
                                            },
                                            icon: const Icon(Icons.delete))
                                      ],
                                    )
                                  ]),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff328695).withOpacity(0.8),
        onPressed: () {
          MyNavigation.push(
              context,
              const AdClients(
                action: 'add',
                email: '',
              ));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
