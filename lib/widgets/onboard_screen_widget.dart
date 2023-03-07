import 'package:flutter/material.dart';

class buidOnboard extends StatefulWidget {
  final Color color;
  final String imageurl;
  final String title;
  final String subtitle;
  const buidOnboard(
      {Key? key,
      required this.color,
      required this.imageurl,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  State<buidOnboard> createState() => _buidOnboardState();
}

class _buidOnboardState extends State<buidOnboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.imageurl,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              widget.subtitle,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
