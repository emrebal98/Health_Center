import 'package:flutter/material.dart';
import 'package:health_center/user/pages/bookAnAppointment/appointment.dart';
import 'package:health_center/user/pages/bookAnAppointment/doctor_list.dart';
import 'package:health_center/user/pages/home.dart';
import 'package:health_center/user/pages/appointment_history.dart';
import 'package:health_center/user/pages/perscription.dart';
import 'package:health_center/user/pages/setting.dart';
import 'package:health_center/user/pages/perscriptionListRouteUser.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key});
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
    const HomeRoute(),
    const AppointmentHistory(),
    const PerscriptionUserPage(),
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
            Navigator.of(context).push(doctorListRoute());
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
                    Icons.calendar_today_rounded,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.08,
                ),
                IconButton(
                  icon: Icon(
                    Icons.wysiwyg_rounded,
                    size: 32,
                    color: _currentIndex == 2
                        ? Theme.of(context).colorScheme.onBackground
                        : Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withAlpha(80),
                  ),
                  iconSize: 24,
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.settings_rounded,
                    color: _currentIndex == 3
                        ? Theme.of(context).colorScheme.onBackground
                        : Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withAlpha(80),
                  ),
                  iconSize: 24,
                  onPressed: () {
                    setState(() {
                      _currentIndex = 3;
                    });
                  },
                ),
              ],
            )),
        // child: Theme(
        //   data: ThemeData(
        //       splashColor: Colors.transparent,
        //       highlightColor: Colors.transparent),
        //   child: BottomNavigationBar(
        //     elevation: 0,
        //     backgroundColor: Theme.of(context).primaryColor.withAlpha(0),
        //     currentIndex: _currentIndex,
        //     type: BottomNavigationBarType.fixed,
        //     // showSelectedLabels: true,
        //     // showUnselectedLabels: true,
        //     // unselectedLabelStyle: TextStyle(fontSize: 10),
        //     unselectedItemColor:
        //         Theme.of(context).colorScheme.onBackground.withAlpha(80),
        //     selectedItemColor: Theme.of(context).colorScheme.onBackground,
        //     items: const [
        //       BottomNavigationBarItem(
        //         icon: Icon(Icons.home_rounded),
        //         label: "Home",
        //       ),
        //       BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.calendar_today_rounded,
        //           ),
        //           label: "Appointments"),
        //       BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.wysiwyg_rounded,
        //           ),
        //           label: "Prescriptions"),
        //       BottomNavigationBarItem(
        //           icon: Icon(
        //             Icons.settings_rounded,
        //           ),
        //           label: "Settings")
        //     ],
        //     onTap: (index) {
        //       _changeTab(index);
        //     },
        //   ),
        // ),
      ),
    );
  }
}
