import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pan_pocket/controller/home_controller.dart';
import 'package:pan_pocket/pages/links_page.dart';
import 'package:sizer/sizer.dart';


class ArchivedPage extends StatefulWidget {
  ArchivedPage({super.key}){

  }


  @override
  State<ArchivedPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ArchivedPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var controller = GetIt.instance<HomeController>();


  Key _linksPageKey = UniqueKey(); // Initialize with a unique key


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> onRefresh()async{
    // linksList.clear();
    setState(() {
      _linksPageKey = UniqueKey();
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
             centerTitle: true,
            title:Text("Archived")
        ),
        body: RefreshIndicator(
            onRefresh: onRefresh,
            child: LinksPage(archived: true, key: _linksPageKey,))
    );
  }
}
