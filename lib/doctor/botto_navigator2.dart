import 'package:flutter/material.dart';
import 'package:health_center/doctor/doctor.dart';
import 'package:health_center/doctor/perscription.dart';
import 'package:health_center/user/pages/setting.dart';

class BottomNavigator2 extends StatefulWidget {
  const BottomNavigator2({Key? key, required this.name});

  final String name;

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator2> {
  int _currentIndex = 0;

  void _changeTab(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List _screens = [
    const DoctorRoute(
      userName: "doc1",
    ),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: _screens[_currentIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(perscriptionRoute());
          },
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).primaryColor.withAlpha(255),
        elevation: 0,
        child: Theme(
          data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedItemColor:
                Theme.of(context).colorScheme.onBackground.withAlpha(80),
            selectedItemColor: Theme.of(context).colorScheme.onBackground,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: "Home",
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings_rounded,
                  ),
                  label: "Settings")
            ],
            onTap: (index) {
              _changeTab(index);
            },
          ),
        ),
      ),
    );
  }
}
