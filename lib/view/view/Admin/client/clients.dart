import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/components/navigation.dart';
import 'package:lawyer/components/text_widget.dart';
import 'package:lawyer/constants.dart';
import 'package:lawyer/view/view/Admin/client/ad_clients.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController search = TextEditingController();
  String? username;
  bool namefind = false;

  List<DocumentSnapshot> documents = [];
  CollectionReference? alldataCollection;

  String searchText = '';

  @override
  void initState() {
    super.initState();
    getname();
  }

  void getname() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');

    alldataCollection = FirebaseFirestore.instance
        .collection('Users')
        .doc(username)
        .collection('Clients');

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
          Container(
            height: 42,
            margin: const EdgeInsets.all(25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(color: Colors.black26)),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              controller: search,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                suffixIcon: search.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            searchText = '';
                            namefind = false;
                          });
                          search.clear();
                        },
                        child: const Icon(Icons.close))
                    : null,
                hintText: 'Search Clients by name',
                border: InputBorder.none,
              ),
              onChanged: (value) async {
                setState(() {
                  searchText = value;
                  namefind = false;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: alldataCollection!.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("");
                  }
                  if (snapshot.data?.size == 0) {
                    return const Text('no data');
                  }
                  documents = snapshot.data!.docs;
                  //todo Documents list added to filterTitle
                  if (searchText != '') {
                    documents = documents.where((element) {
                      return element
                          .get('name')
                          .toString()
                          .toLowerCase()
                          .contains(searchText.toLowerCase());
                    }).toList();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 70),
                    itemCount: documents.length,
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
                                            text: documents[index]['name'],
                                            size: 20,
                                            fontWeight: FontWeight.w500,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextWidget(
                                            text: documents[index]['mobileno'],
                                            size: 15,
                                            fontWeight: FontWeight.w400,
                                            textoverflow: TextOverflow.visible,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          TextWidget(
                                            text: documents[index]['email'],
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
                                                    email: documents[index]
                                                        ['email'],
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
                                                  .doc(
                                                      documents[index]['email'])
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
