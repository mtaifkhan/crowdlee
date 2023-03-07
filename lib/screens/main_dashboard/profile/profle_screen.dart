import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/database/auth_methods.dart';
import 'package:social_media_app/database/firestore_methods.dart';
import 'package:social_media_app/screens/authentication/login_scree.dart';
import 'package:social_media_app/screens/main_dashboard/profile/edit_profile.dart';
import 'package:social_media_app/utils/utils.dart';
import 'package:social_media_app/widgets/follow_button.dart';
import '../../../utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool _isfollowing = false;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var usersnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      // get post Length
      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = usersnap.data()!;
      followers = usersnap.data()!["followers"].length;
      following = usersnap.data()!["following"].length;
      _isfollowing = usersnap
          .data()!["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(color: appcolor),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: appcolor,
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
              title: Text(userData["username"]),
              actions: [
                FirebaseAuth.instance.currentUser!.uid == widget.uid
                    ? IconButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Are You Sure?"),
                              content: Text("Do You want to Logout"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "No",
                                    style: TextStyle(
                                      color: appcolor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await AuthMethods().signOutUser();
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  },
                                  child: const Text(
                                    "yes",
                                    style: TextStyle(
                                      color: appcolor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.logout),
                      )
                    : Container(),
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50.0,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(userData["photoUrl"]),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        userData["name"],
                        style: const TextStyle(
                            color: appcolor,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStateColumn(postLen, "posts"),
                                    buildStateColumn(followers, "followers"),
                                    buildStateColumn(following, "followings"),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FirebaseAuth.instance.currentUser!.uid ==
                                              widget.uid
                                          ? Followbutton(
                                              text: "Edit profile",
                                              fuction: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditProfileScreen(
                                                              // ignore: unnecessary_cast
                                                              userdata: userData
                                                                  as Map<
                                                                      dynamic,
                                                                      dynamic>,
                                                            )));
                                              },
                                              textColor: appcolor,
                                              bordercolor: Colors.grey,
                                              backgroundcolor:
                                                  mobileBackgroundColor,
                                            )
                                          : _isfollowing
                                              ? Followbutton(
                                                  text: "Unfollow",
                                                  fuction: () async {
                                                    await FireStoreMethods()
                                                        .followUser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            userData["uid"]);
                                                    setState(() {
                                                      _isfollowing = false;
                                                      followers--;
                                                    });
                                                  },
                                                  textColor: appcolor,
                                                  bordercolor: appcolor,
                                                  backgroundcolor: primaryColor,
                                                )
                                              : Followbutton(
                                                  text: "Follow",
                                                  fuction: () async {
                                                    await FireStoreMethods()
                                                        .followUser(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                            userData["uid"]);
                                                    setState(() {
                                                      _isfollowing = true;
                                                      followers++;
                                                    });
                                                  },
                                                  textColor: appcolor,
                                                  bordercolor: appcolor,
                                                  backgroundcolor: primaryColor,
                                                ),
                                    ]),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: const Text(
                          "Bio Data",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: textcolor),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData["bio"].toString(),
                          style: const TextStyle(color: textcolor),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection("posts")
                        .where("uid", isEqualTo: widget.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data as dynamic).docs[index];
                          // ignore: avoid_unnecessary_containers
                          return Container(
                            // color: Colors.orange,
                            // child: Text("Pakistan"),
                            child: Image(
                              image: NetworkImage(
                                snap["postUrl"],
                              ),
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    }),
              ],
            ),
          );
  }

  Column buildStateColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4.0),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
