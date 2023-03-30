import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/button_widget.dart';
import 'package:lawyer/components/navigation.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/components/textfield_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/view/view/Admin/cases/add_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cases extends StatefulWidget {
  const Cases({super.key});

  @override
  State<Cases> createState() => _CasesState();
}

class _CasesState extends State<Cases> {
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primarycolor,
        title: const Text('Cases'),
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
                    .collection('Cases')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }
                  if (snapshot.data?.size == 0) {
                    return const Text('No data found');
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 70),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot ds = snapshot.data!.docs[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 10,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
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
                                            text:
                                                "Client Name: ${snapshot.data!.docs[index]['clientname']}",
                                            size: 18,
                                            fontWeight: FontWeight.w500,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextWidget(
                                            text:
                                                "Pet/Def Name: ${snapshot.data!.docs[index]['petname']}",
                                            size: 16,
                                            fontWeight: FontWeight.w300,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextWidget(
                                            text:
                                                "Judge Name: ${snapshot.data!.docs[index]['judgename']}",
                                            size: 16,
                                            fontWeight: FontWeight.w300,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextWidget(
                                            text:
                                                "Court Name: ${snapshot.data!.docs[index]['courtname']}",
                                            size: 16,
                                            fontWeight: FontWeight.w300,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          TextWidget(
                                            text:
                                                "Case Date: ${snapshot.data!.docs[index]['date']}",
                                            size: 16,
                                            fontWeight: FontWeight.w300,
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
                                                  AddCase(
                                                    action: 'edit',
                                                    docsid: snapshot.data!
                                                        .docs[index]['docid'],
                                                  ));
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                            color: Colors.red,
                                            onPressed: () {
                                              _firestore
                                                  .collection('Users')
                                                  .doc('junaid')
                                                  .collection('Cases')
                                                  .doc(snapshot.data!
                                                      .docs[index]['docid'])
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
              const AddCase(
                action: 'add',
                docsid: '',
              ));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
    ;
  }
}
