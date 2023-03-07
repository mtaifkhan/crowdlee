import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_media_app/provider/user_provider.dart';
import 'package:social_media_app/utils/global_variables.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreeenLayout;
  final Widget mobileScreeenLayout;
  // ignore: use_key_in_widget_constructors
  const ResponsiveLayout(
    this.mobileScreeenLayout,
    this.webScreeenLayout,
  );

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    // ignore: no_leading_underscores_for_local_identifiers
    userProvider _userprovider = Provider.of(context, listen: false);
    await _userprovider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight > webScreenSize) {
          //web Screen
          return widget.webScreeenLayout;
        }
        return widget.mobileScreeenLayout;
      },
    );
  }
}
