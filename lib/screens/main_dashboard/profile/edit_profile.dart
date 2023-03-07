// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/utils/colors.dart';

class EditProfileScreen extends StatefulWidget {
  var userdata;
  EditProfileScreen({Key? key, required this.userdata}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _bioData = TextEditingController();

  bool _isLogginIn = false;
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  String? imagePath;
  // bool _isUploading = false;
  String downloadURL = "";
  // ignore: prefer_typing_uninitialized_variables
  var imagefile;

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _bioData.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _name.text = widget.userdata["name"];
    _username.text = widget.userdata["username"];
    _bioData.text = widget.userdata["bio"];
    downloadURL = widget.userdata["photoUrl"];

    super.initState();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future updateProfileData(
    String? username,
    String? name,
    String? bio,
    String? profilePic,
  ) async {
    return await _firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "username": username ?? " ",
      "name": name ?? " ",
      "bio": bio ?? " ",
      'photoUrl': profilePic,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2.3,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            appcolor,
                            Color.fromARGB(153, 169, 173, 252),
                          ],
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(0.0),
                          bottomRight: Radius.circular(130.0),
                        )),
                    child: Column(children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      imagefile != null
                          ? CircleAvatar(
                              radius: 65.0,
                              foregroundImage: FileImage(imagefile),
                            )
                          : CircleAvatar(
                              radius: 65.0,
                              backgroundImage: CachedNetworkImageProvider(
                                  widget.userdata["photoUrl"]),
                              backgroundColor: Colors.white,
                            ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.020),
                      InkWell(
                        onTap: () async {
                          try {
                            final image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            setState(() {
                              imagePath = image?.path;
                              imagefile = File(image!.path);
                            });
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: 'Something went wrong\n $e');
                          }
                        },
                        child: Container(
                          height: 50.0,
                          width: MediaQuery.of(context).size.width - 250.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            style: BorderStyle.solid,
                          )),
                          child: const Center(
                            child: Text(
                              "Change Photo",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              //==========
              Positioned(
                  top: 25.0,
                  left: 10.0,
                  right: 8.0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        // _isLogginIn
                        //     ? const Center(
                        //         child: CircularProgressIndicator(),
                        //       )
                        //     :
                        TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLogginIn = true;
                              });
                              try {
                                if (imagePath != null) {
                                  String imageName = path.basename(imagePath!);
                                  firebase_storage.Reference ref1 =
                                      firebase_storage
                                          .FirebaseStorage.instance
                                          .ref('/$imageName' +
                                              DateTime.now().toString());

                                  File file = File(imagePath!);
                                  await ref1.putFile(file);
                                  downloadURL = await ref1.getDownloadURL();
                                }
                                await updateProfileData(
                                  _username.text.trim(),
                                  _name.text.trim(),
                                  _bioData.text.trim(),
                                  downloadURL,
                                );
                                Fluttertoast.showToast(
                                    msg: "Personal Information Updated!");
                                setState(() {
                                  _isLogginIn = false;
                                });
                                Navigator.of(context).pop();
                              } on FirebaseAuthException catch (e) {
                                Fluttertoast.showToast(msg: e.toString());
                              }
                              setState(() {
                                _isLogginIn = false;
                              });
                            }
                          },
                          child: _isLogginIn
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : const Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                  )),
              //========

              //======
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 10.0),
            child: Center(
                child: SizedBox(
                    width: double.infinity,
                    // height: 290.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Information",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Divider(
                              color: appcolor,
                              thickness: 2.0,
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "UserName",
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                  ),
                                  TextFormField(
                                    controller: _username,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    validator: (value) {
                                      return _validateName(value);
                                    },
                                  ),
                                  const Divider(),
                                  const Text(
                                    "Name",
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                  ),
                                  TextFormField(
                                    controller: _name,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    validator: (value) {
                                      return _validateName(value);
                                    },
                                  ),
                                  const Divider(),
                                  const Text(
                                    "Bio Data",
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                  ),
                                  TextFormField(
                                    controller: _bioData,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                    validator: (value) {
                                      return _validateName(value);
                                    },
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                    ))),
          ),
        ],
      ),
    ));
  }
}

String? _validateName(String? formData) {
  if (formData == null || formData.isEmpty) {
    return 'This field cannot be empty!';
  }
  if (formData.length < 8) {
    return 'Minimum length is 8 characters';
  }
  return null;
}
