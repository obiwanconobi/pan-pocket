import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pan_pocket/helpers/screen_helper.dart';
import 'package:pan_pocket/helpers/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ScreenHelper screenHelper = ScreenHelper();
  @override
  void initState(){
    super.initState();
    _controller = AnimationController(vsync: this);
    getPreferences();
  }

  getPreferences()async{
  //  perfs = await SharedPreferences.getInstance();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _toggleTheme()async{
    AdaptiveTheme.of(context).toggleThemeMode();
  }

  setCacheValue(int cache){
    SharedPreferencesHelper.setInt('cacheValue', cache);
  }

  getCacheValue(){
    return SharedPreferencesHelper.getInt('cacheValue') ?? 3;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,title: const Text('Settings'),
    actions: <Widget>[
    IconButton(
    icon: const Icon(Icons.sunny),
    onPressed: _toggleTheme
    ),
    ],),
    body: Center(
      child: SizedBox(
        width: screenHelper.screenWidthMoreThanHeight(context) ? 50.w : 100.w,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Cache Days: '),
                NumberPicker(
                  value: getCacheValue(),
                  minValue: 0,
                  maxValue: 13,
                  onChanged: (value) => setState(() => setCacheValue(value)),
                ),
                Tooltip(
                  child: Icon(Icons.info, size: 30.0),
                  message: 'Set to 0 to clear cache',
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  showDuration: Duration(seconds: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.9),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  textStyle: TextStyle(color: Colors.white),
                  preferBelow: true,
                  verticalOffset: 20,
                )
              ],
            ),
          ],
        ),
      ),
    ),);
  }
}
