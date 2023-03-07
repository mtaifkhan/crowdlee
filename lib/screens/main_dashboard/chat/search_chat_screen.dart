import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:social_media_app/database/models/user.dart' as model;
import 'package:social_media_app/screens/main_dashboard/chat/chat_detail_screen.dart';

class ChatSerarchScreen extends StatefulWidget {
  ChatSerarchScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatSerarchScreen> createState() => _ChatSerarchScreenState();
}

class _ChatSerarchScreenState extends State<ChatSerarchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isshowUsers = false;
  List<Map> searchResult = [];
  bool issearch = false;
  bool isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // void onSearch() async {
  //   searchResult = [];
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .where("username", isEqualTo: _searchController.text)
  //       .get()
  //       .then((value) {
  //     if (value.docs.length < 1) {
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text("No user found")));
  //       setState(() {
  //         isLoading = false;
  //       });
  //       return;
  //     }
  //     value.docs.forEach((user) {
  //       if (user.data()["email"] != widget.user!.email) {
  //         searchResult.add(user.data());
  //       }
  //     });
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 24, 35, 241),
                      Color.fromARGB(153, 169, 173, 252),
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp)),
          ),
          title: issearch
              ? TextFormField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      labelText: "Search for user",
                      labelStyle: TextStyle(color: Colors.white)),
                  // ignore: no_leading_underscores_for_local_identifiers
                  onFieldSubmitted: (String _kuchb) {
                    setState(() {
                      _isshowUsers = true;
                    });
                    //onSearch();
                  },
                )
              : Text("Chat"),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  issearch = true;
                });
              },
              icon: Icon(Icons.search),
            )
          ],
        ),
        body: _isshowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .where("username",
                        isGreaterThanOrEqualTo: _searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                      itemCount: (snapshot.data as dynamic).docs.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      currentUser: FirebaseAuth
                                          .instance.currentUser!.uid,
                                      friendId: (snapshot.data! as dynamic)
                                          .docs[index]["uid"],
                                      friendName: (snapshot.data! as dynamic)
                                          .docs[index]["username"],
                                      friendImage: (snapshot.data! as dynamic)
                                          .docs[index]["photoUrl"],
                                    )));
                          },
                          // onTap: () => Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //         builder: (context) => ProfileScreen(
                          //             uid: (snapshot.data! as dynamic).docs[index]
                          //                 ["uid"])),
                          //                 ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                (snapshot.data! as dynamic).docs[index]
                                    ["photoUrl"],
                              ),
                            ),
                            title: Text((snapshot.data! as dynamic).docs[index]
                                ["username"]),
                          ),
                        );
                      });
                })
            : SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: Text('No chat'),
                ),
              )
        // body: searchResult.length > 0 == true
        //     ? Expanded(
        //         child: ListView.builder(
        //             itemCount: searchResult.length,
        //             shrinkWrap: true,
        //             itemBuilder: (context, index) {
        //               return ListTile(
        //                 leading: CircleAvatar(
        //                   child: Image.network(
        //                       searchResult[index]["profileImage"]),
        //                 ),
        //                 title: Text(searchResult[index]["username"]),
        //                 subtitle: Text(searchResult[index]["email"]),
        //                 trailing: IconButton(
        //                     onPressed: () {}, icon: Icon(Icons.message)),
        //               );
        //             }))
        //     : isLoading
        //         ? Center(
        //             child: CircularProgressIndicator(),
        //           )
        //         : Container(
        //             child: Center(
        //               child: Text("No data"),
        //             ),
        //           )

        );
  }
}
