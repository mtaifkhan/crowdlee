// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:social_media_app/responsive/mobile_screen_layout.dart';
import 'package:social_media_app/responsive/responsive_layout_screen.dart';
import 'package:social_media_app/responsive/web_screen_layout.dart';
import 'package:social_media_app/screens/authentication/login_scree.dart';
import 'package:social_media_app/utils/colors.dart';
import '../../database/auth_methods.dart';
import '../../utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isloading = false;
  final TextEditingController _emaiController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Uint8List? _image;
  bool _isPassHide = true;
  bool _isPassHide2 = true;

  @override
  void dispose() {
    super.dispose();
    _emaiController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUp() async {
    setState(() {
      _isloading = true;
    });
    String res = await AuthMethods().signUpUser(
      name: _nameController.text.trim(),
      email: _emaiController.text.trim(),
      password: _passwordController.text.trim(),
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      file: _image!,
    );
    setState(() {
      _isloading = false;
    });
    if (res != "success") {
      showSnackBar(res, context);
      //someting to do
    } else {
      // other thing to do
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              const ResponsiveLayout(MobileScreenLayout(), WebScreenLayout())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      // ignore: avoid_unnecessary_containers
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 260,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fill)),
              child: Stack(
                children: [
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 120,
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/light-1.png'))),
                    ),
                  ),
                  Positioned(
                    left: 160,
                    width: 80,
                    height: 75,
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/light-2.png'))),
                    ),
                  ),
                  // Positioned(
                  //   right: 40,
                  //   top: 40,
                  //   width: 80,
                  //   height: 80,
                  //   child: Container(
                  //     decoration: const BoxDecoration(
                  //         image: DecorationImage(
                  //             image: AssetImage('assets/images/clock.png'))),
                  //   ),
                  // ),
                  Positioned(
                    child: Container(
                      //margin: const EdgeInsets.only(top: 2.0),
                      height: 200.0,
                      child: const Center(
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      margin: const EdgeInsets.only(top: 130.0),
                      child: Center(
                        child: Stack(
                          children: [
                            _image != null
                                ? CircleAvatar(
                                    radius: 64.0,
                                    backgroundImage: MemoryImage(_image!))
                                : const CircleAvatar(
                                    radius: 64.0,
                                    backgroundImage: NetworkImage(
                                      "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png",
                                    ),
                                  ),
                            Positioned(
                              left: 80.0,
                              bottom: -10,
                              child: IconButton(
                                  onPressed: () async {
                                    selectImage();
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black,
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromARGB(51, 102, 108, 234),
                              blurRadius: 20.0,
                              offset: Offset(0, 10))
                        ]),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: TextFormField(
                              controller: _usernameController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Your username",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                              // validator: _validateName,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: TextFormField(
                              controller: _nameController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Your name",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                              validator: _validateName,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: TextFormField(
                              controller: _emaiController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Your email",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                              validator: _validateEmail,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: TextFormField(
                              controller: _bioController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter Your Bio",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Bio is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: TextFormField(
                              controller: _passwordController,
                              style: const TextStyle(color: Colors.black),
                              obscureText: _isPassHide,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_isPassHide == true) {
                                          _isPassHide = false;
                                        } else {
                                          _isPassHide = true;
                                        }
                                      });
                                    },
                                    icon: _isPassHide
                                        ? const Icon(
                                            Icons.lock,
                                            color: appcolor,
                                          )
                                        : const Icon(
                                            Icons.lock_open,
                                            color: appcolor,
                                          ),
                                  ),
                                  hintText: "Enter your password",
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                              validator: _validatePass,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              style: const TextStyle(color: Colors.black),
                              obscureText: _isPassHide2,
                              decoration: InputDecoration(
                                  hintText: "confirm password",
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: _isPassHide2
                                        ? const Icon(
                                            Icons.lock,
                                            color: appcolor,
                                          )
                                        : const Icon(
                                            Icons.lock_open,
                                            color: appcolor,
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        if (_isPassHide2 == true) {
                                          _isPassHide2 = false;
                                        } else {
                                          _isPassHide2 = true;
                                        }
                                      });
                                    },
                                  ),
                                  hintStyle:
                                      TextStyle(color: Colors.grey[400])),
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        signUp();
                      } else {
                        showSnackBar(
                            "Please check the above requirements!", context);
                      }
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 66, 3, 100),
                            Color.fromARGB(153, 169, 173, 252),
                          ])),
                      child: Center(
                        child: _isloading == true
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Sign up",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: const Text(
                            "LogIn.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 101, 97, 229)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

String? _validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'Email address cannot be empty!';
  }

  String pattern = r'\w+@\w+\.';
  RegExp regEx = RegExp(pattern);
  if (!regEx.hasMatch(formEmail)) return 'Invalid Email Address Format.';
  return null;
}

String? _validatePass(String? formPass) {
  if (formPass == null || formPass.isEmpty) {
    return 'Password cannot be empty!';
  }
  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[_!@#\$&*~]).{8,}$';
  RegExp regEx = RegExp(pattern);
  if (!regEx.hasMatch(formPass)) {
    return '''
    Password must be atleast 8 characters,
    include an uppercase letter, number and symbol.
        ''';
  }

  return null;
}

String? _validateName(String? formData) {
  if (formData == null || formData.isEmpty) {
    return 'This field cannot be empty!';
  }
  if (formData.length > 20) {
    return 'Maximum length is 20 characters';
  }
  return null;
}
