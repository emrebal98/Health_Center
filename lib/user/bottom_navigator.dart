import 'package:flutter/material.dart';
import 'package:health_center/user/pages/home.dart';
import 'package:health_center/user/pages/appointment.dart';
import 'package:health_center/user/pages/perscription.dart';
import 'package:health_center/user/pages/setting.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key, required this.name});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String name;

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _currentIndex = 0;

  void _incrementTab(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  final List _screens = [
    const HomeRoute(
      userName: "Test Name",
    ),
    const AppointmentRoute(),
    const PerscriptionRoute(),
    const SettingRoute()
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
            _incrementTab(
                _currentIndex + 1 < 4 ? _currentIndex + 1 : _currentIndex = 0);
          },
          tooltip: "Increment",
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).primaryColor.withAlpha(255),
        // ↑ use .withAlpha(0) to debug/peek underneath ↑ BottomAppBar
        elevation: 0, // ← removes slight shadow under FAB, hardly noticeable
        // ↑ default elevation is 8. Peek it by setting color ↑ alpha to 0
        // clipBehavior: Clip.antiAlias,

        child: Theme(
          data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent),
          child: BottomNavigationBar(
            elevation: 0, // 0 removes ugly rectangular NavBar shadow
            // CRITICAL ↓ a solid color here destroys FAB notch. Use alpha 0!
            backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
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
                    Icons.calendar_today_rounded,
                  ),
                  label: "Second"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.wysiwyg_rounded,
                  ),
                  label: "Third"),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings_rounded,
                  ),
                  label: "Fourth")
            ],
            onTap: (index) {
              _incrementTab(index);
            },
          ),
        ),
      ),

      // bottomNavigationBar: BottomNavyBar(
      //   selectedIndex: _currentIndex,
      //   showElevation: true,
      //   itemCornerRadius: 24,
      //   curve: Curves.easeIn,
      //   onItemSelected: (index) => setState(() => _currentIndex = index),
      //   items: <BottomNavyBarItem>[
      //     BottomNavyBarItem(
      //       icon: const Icon(Icons.apps_rounded),
      //       title: const Text("Home"),
      //       activeColor: Colors.red,
      //       textAlign: TextAlign.center,
      //     ),
      //     BottomNavyBarItem(
      //       icon: const Icon(Icons.calendar_today_rounded),
      //       title: const Text('Appointment'),
      //       activeColor: Colors.purpleAccent,
      //       textAlign: TextAlign.center,
      //     ),
      //     BottomNavyBarItem(
      //       icon: const Icon(Icons.wysiwyg_rounded),
      //       title: const Text('Perscription'),
      //       activeColor: Colors.pink,
      //       textAlign: TextAlign.center,
      //     ),
      //     BottomNavyBarItem(
      //       icon: const Icon(Icons.settings_rounded),
      //       title: const Text('Settings'),
      //       activeColor: Colors.blue,
      //       textAlign: TextAlign.center,
      //     ),
      //   ],
      // ),
    );
  }
}
