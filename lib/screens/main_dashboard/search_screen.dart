import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:social_media_app/screens/main_dashboard/profile/profle_screen.dart';
import 'package:social_media_app/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isshowUsers = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: "Search for user",
          ),
          // ignore: no_leading_underscores_for_local_identifiers
          onFieldSubmitted: (String _kuchb) {
            setState(() {
              _isshowUsers = true;
            });
          },
        ),
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
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ProfileScreen(
                                    uid: (snapshot.data! as dynamic).docs[index]
                                        ["uid"]))),
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
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection("post").get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                //==========  Here is some error
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    var data =
                        (snapshot.data! as dynamic).docs[index]['postUrl'];

                    return Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl'],
                      fit: BoxFit.cover,
                    );
                  },
                  staggeredTileBuilder: (index) => MediaQuery.of(context)
                              .size
                              .width >
                          900
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );

                // return GridView.builder(
                //   shrinkWrap: true,
                //   itemCount: (snapshot.data! as dynamic).docs.length,
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     crossAxisSpacing: 5,
                //     mainAxisSpacing: 1.5,
                //     childAspectRatio: 1,
                //   ),
                //   itemBuilder: (context, index) {
                //     // DocumentSnapshot snap =
                //     //     (snapshot.data as dynamic).docs[index];
                //     return Container(
                //       // color: Colors.orange,
                //       // child: Text("Pakistan"),
                //       child: Image(
                //         image: NetworkImage(
                //           (snapshot.data! as dynamic).docs[index]["postUrl"],
                //         ),
                //         fit: BoxFit.cover,
                //       ),
                //     );
                //   },
                // );
                // return MasonryGridView.count(
                //   crossAxisCount: 2,
                //   mainAxisSpacing: 4,
                //   itemCount: (snapshot.data! as dynamic).docs.length,
                //   crossAxisSpacing: 4,
                //   itemBuilder: (context, index) {
                //     return Container(
                //       height: 120,
                //       width: 120,
                //       color: Colors.orange,
                //       child: Image.network(
                //         (snapshot.data! as dynamic).docs[index]["postUrl"],
                //         fit: BoxFit.cover,
                //       ),
                //     );
                //   },
                // );

                // return GridView.builder(
                //   physics: const ScrollPhysics(),
                //   shrinkWrap: true,
                //   padding: const EdgeInsets.only(
                //       top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
                //   itemCount: (snapshot.data! as dynamic).docs.length,
                //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2,
                //     childAspectRatio: 0.7,
                //     mainAxisSpacing: 10.0,
                //     crossAxisSpacing: 10.0,
                //   ),
                //   itemBuilder: (context, index) {
                //     return Image.network(
                //       (snapshot.data! as dynamic).docs[index]["postUrl"],
                //     );
                //   },
                // );
              }),
    );
  }
}
