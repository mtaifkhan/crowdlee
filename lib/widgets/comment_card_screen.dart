import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/utils/colors.dart';

class CommentCards extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const CommentCards({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCards> createState() => _CommentCardsState();
}

class _CommentCardsState extends State<CommentCards> {
  @override
  Widget build(BuildContext context) {
    //final User user = Provider.of<userProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.0,
            backgroundImage: NetworkImage(
              widget.snap["profileImage"],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap["username"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: textcolor),
                        ),
                        TextSpan(
                          text: " ${widget.snap["text"]}",
                          style: const TextStyle(color: textcolor),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap["datePublished"].toDate()),
                      style: const TextStyle(
                          fontWeight: FontWeight.w400, color: textcolor),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: const Icon(
              Icons.favorite_border,
              size: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
