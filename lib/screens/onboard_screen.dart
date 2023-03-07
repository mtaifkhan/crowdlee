import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:social_media_app/screens/authentication/login_scree.dart';
import 'package:social_media_app/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media_app/widgets/onboard_screen_widget.dart';

class OnboardScreens extends StatefulWidget {
  const OnboardScreens({Key? key}) : super(key: key);

  @override
  State<OnboardScreens> createState() => _OnboardScreensState();
}

class _OnboardScreensState extends State<OnboardScreens> {
  final controller = PageController();
  bool islastpage = false;

  @override
  void dispose() {
    controller;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            islastpage = index == 3;
          });
        },
        children: const [
          buidOnboard(
            color: Colors.white,
            imageurl: "assets/images/4.png",
            title: "Wellcome to crowdlee!",
            subtitle: " ",
          ),
          buidOnboard(
            color: Colors.white,
            imageurl: "assets/images/5.png",
            title: "Share Your knowledge",
            subtitle: "Make psot and stay connected!",
          ),
          buidOnboard(
            color: Colors.white,
            imageurl: "assets/images/3.png",
            title: "Entertain yourself!",
            subtitle:
                "Easy to use and more freindly,spend day with freinds and followers. ",
          ),
          buidOnboard(
            color: Colors.white,
            imageurl: "assets/images/2.png",
            title: "Community!",
            subtitle:
                "In case of any doute or problem occur community will provied full deatail and help you.",
          ),
        ],
      ),
      bottomSheet: islastpage
          ? TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool("showHome", true);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: appcolor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                minimumSize: const Size.fromHeight(80),
              ),
              child: const Text("Get Started",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            )
          :
          // ignore: sized_box_for_whitespace
          Container(
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      controller.jumpToPage(4);
                    },
                    child: const Text("skip"),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      //third-party package
                      controller: controller,
                      count: 4,
                      effect: const WormEffect(
                        spacing: 16.0,
                        dotColor: Colors.black38,
                        activeDotColor: appcolor,
                      ),
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    },
                    child: const Text("Next"),
                  )
                ],
              ),
            ),
    );
  }
}
