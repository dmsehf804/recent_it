import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/permission_handler_model.dart';
import 'aos_page.dart';
import 'ios_page.dart';

class MainTabPage extends StatefulWidget {
  const MainTabPage({super.key});

  @override
  State<MainTabPage> createState() => _MainTabPage();
}

class _MainTabPage extends State<MainTabPage> {
  final List<Widget> _tabScreens = [const AOSPage(), const IOSPage()];
  int _tabScreenIndex = 0;
  bool _storagePermission = false;                                                                                                                                                                                                         
  @override
  void initState() {
    super.initState();
    PermissionManage permissionManage = PermissionManage();
    permissionManage.requestStoragePermission(context);

  }

  void tabSelected(int index) {
    setState(() {
      _tabScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('요즘 IT'),
        // ignore: prefer_const_constructors
        titleTextStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
      ),
      body: _tabScreens[_tabScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: tabSelected,
          currentIndex: _tabScreenIndex,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.android),
              label: 'AOS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apple),
              label: 'IOS',
            ),
          ]),
    );
  }
}
