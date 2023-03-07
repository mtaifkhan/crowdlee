// ignore_for_file: library_prefixes

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/screens/main_dashboard/comment_screen.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:social_media_app/widgets/like_animation.dart';

import '../database/firestore_methods.dart';
import '../models/user.dart';
import '../provider/user_provider.dart';
import '../utils/utils.dart';

class PostCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.snap["postId"])
          .collection("comments")
          .get();
      commentLen = querySnapshot.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<userProvider>(context, listen: false).getUser;

    return Container(
      margin: const EdgeInsets.only(bottom: 7.0),
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Header Section of User
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8.0)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(widget.snap["profileImage"]),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap["username"],
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: textcolor,
                        ),
                      ),
                    ],
                  ),
                )),
                firebaseAuth.FirebaseAuth.instance.currentUser!.uid ==
                        widget.snap["uid"]
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shrinkWrap: true,
                                children: ["Delete Post"]
                                    .map((e) => InkWell(
                                          onTap: () async {
                                            await FireStoreMethods().deletePost(
                                                widget.snap["postId"]);
                                            // ignore: use_build_context_synchronously
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12.0,
                                              horizontal: 12.0,
                                            ),
                                            child: Text(e),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: textcolor,
                        ),
                      )
                    : IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.more_vert,
                          color: textcolor,
                        ),
                      ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                top: 0.0, left: 10.0, right: 5.0, bottom: 5.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    // ignore: prefer_interpolation_to_compose_strings
                    text: " " + widget.snap["description"],
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Image Section
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                  widget.snap["postId"], user.uid, widget.snap["likes"]);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0.0),
                    child: CachedNetworkImage(
                      imageUrl: widget.snap["postUrl"],
                      fit: BoxFit.cover,
                      // placeholder: (context, url) => LinearProgressIndicator(
                      //   backgroundColor: Colors.grey[200],
                      //   minHeight: 2.0,
                      // ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error,
                      ),
                      height: 50,
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    // ignore: sort_child_properties_last
                    child: const Icon(
                      Icons.favorite,
                      size: 120,
                      color: Colors.white,
                    ),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(milliseconds: 300),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          //Like  comment Section
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap["likes"].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FireStoreMethods().likePost(
                        widget.snap["postId"], user.uid, widget.snap["likes"]);
                  },
                  icon: Icon(
                    widget.snap["likes"].contains(user.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
              ),
              DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(fontWeight: FontWeight.bold),
                child: Text(
                  "${widget.snap["likes"].length} likes",
                  style: const TextStyle(color: textcolor),
                ),
              ),
              const SizedBox(
                width: 5.0,
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentScreen(snap: widget.snap)));
                },
                icon: const Icon(
                  Icons.insert_comment_sharp,
                  color: textcolor,
                ),
              ),
              const SizedBox(
                width: 3.0,
              ),
              Text(
                "$commentLen comment",
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(
              //     Icons.send,
              //     color: textcolor,
              //   ),
              // ),

              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share,
                    size: 18.0,
                    color: textcolor,
                  ),
                ),
              )),
            ],
          ),
          // SizedBox(
          //   height: 2.0,
          // ),
          Container(
            margin: const EdgeInsets.only(left: 10.0, right: 10.0),
            height: 0.1,
            width: double.infinity,
            color: Colors.grey,
          ),
          //Description and NUmber of Comments
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // DefaultTextStyle(
                //   style: Theme.of(context)
                //       .textTheme
                //       .subtitle2!
                //       .copyWith(fontWeight: FontWeight.bold),
                //   child: Text(
                //     "${widget.snap["likes"].length} likes",
                //     style: const TextStyle(color: textcolor),
                //   ),
                // ),
                // Container(
                //   width: double.infinity,
                //   padding: const EdgeInsets.only(top: 0.0),
                //   child: RichText(
                //     text: TextSpan(
                //       children: [
                //         TextSpan(
                //             text: widget.snap["username"],
                //             style: const TextStyle(
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.black)),
                //         TextSpan(
                //           // ignore: prefer_interpolation_to_compose_strings
                //           text: " " + widget.snap["description"],
                //           style: const TextStyle(color: Colors.black),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 3.0,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16.0,
                      backgroundColor: blueColor,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                    const SizedBox(
                      width: 7.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CommentScreen(snap: widget.snap)));
                      },
                      child: Container(
                        height: 25.0,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          border: Border.all(
                            style: BorderStyle.solid,
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: const Center(
                          child: Text(
                            "Write a comment..",
                            style: TextStyle(color: textcolor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            CommentScreen(snap: widget.snap)));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      "view all $commentLen comments",
                      style: const TextStyle(fontSize: 16.0, color: textcolor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap["datePublished"].toDate())
                        .toString(),
                    style: const TextStyle(fontSize: 16.0, color: textcolor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
