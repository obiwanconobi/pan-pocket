import 'dart:async';

import 'package:pan_pocket/pages/settings_page.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pan_pocket/controller/home_controller.dart';
import 'package:pan_pocket/pages/archived_page.dart';
import 'package:pan_pocket/pages/links_page.dart';
import 'package:sizer/sizer.dart';

import 'home_links_page.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({super.key}){
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum _SelectedTab { home, favorite, search, person }

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var controller = GetIt.instance<HomeController>();


  Key _linksPageKey = UniqueKey(); // Initialize with a unique key
  final _navController = PersistentTabController(initialIndex: 0);





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
    return PersistentTabView(tabs:[
        PersistentTabConfig(
        screen: HomeLinksPage(),
    item: ItemConfig(
      icon: const Icon(Icons.home),
      activeForegroundColor: Colors.green,
      title: "Links",
    ),
        ),
      PersistentTabConfig(
      screen: ArchivedPage(),
      item: ItemConfig(
      activeForegroundColor: Colors.blue,
      icon: const Icon(Icons.auto_delete_rounded),
      title: "Archived",
      ),
      ),
      PersistentTabConfig(
            screen: const SettingsPage(),
            item: ItemConfig(
              icon: const Icon(Icons.settings),
              title: "Settings",
            ),
          ),
      /*PersistentTabConfig(
      screen: const AccountPage(),
      item: ItemConfig(
      activeForegroundColor: Colors.deepOrangeAccent,
      icon: const Icon(Icons.settings),
      title: "Account",
      ),
      ),*/
      ],
        navBarBuilder: (navBarConfig) => Style8BottomNavBar(
    navBarDecoration: NavBarDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor!
    ),
    navBarConfig: navBarConfig,
        ),);

  }
}
