import 'package:flutter/material.dart';
import 'package:health_center/doctor/doctor.dart';
import 'package:health_center/doctor/perscription.dart';
import 'package:health_center/doctor/setting.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key, required this.name});

  final String name;

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
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
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home_rounded,
                  color: _currentIndex == 0
                      ? Theme.of(context).colorScheme.onBackground
                      : Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withAlpha(80),
                ),
                iconSize: 24,
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings_rounded,
                  color: _currentIndex == 1
                      ? Theme.of(context).colorScheme.onBackground
                      : Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withAlpha(80),
                ),
                iconSize: 24,
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
