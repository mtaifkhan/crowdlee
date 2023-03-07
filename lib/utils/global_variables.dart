import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/screens/main_dashboard/add_post_screen.dart';
import 'package:social_media_app/screens/main_dashboard/chat/main_chat_screen.dart';
import 'package:social_media_app/screens/main_dashboard/home_screen/home_screen.dart';
import 'package:social_media_app/screens/main_dashboard/profile/profle_screen.dart';
import 'package:social_media_app/screens/main_dashboard/search_screen.dart';

const webScreenSize = 900;
List<Widget> homescreenItems = [
  const MainHomeScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  MainChatScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
