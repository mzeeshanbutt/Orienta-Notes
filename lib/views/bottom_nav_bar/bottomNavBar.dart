import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:orienta_notes/views/screens/addnotescreen.dart';
import 'package:orienta_notes/views/screens/homescreen.dart';
import 'package:orienta_notes/views/screens/profilescreen.dart';

class Bottomnavbar extends StatefulWidget {
  const Bottomnavbar({super.key});

  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  int _currentIndex = 0;
  List<Widget> screens = [Homescreen(), Profilescreen()];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,

      // ignore: deprecated_member_use
      onPopInvoked: (bool didPop) {
        if (didPop) return;

        setState(() {
          _currentIndex = 0;
        });
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(index: _currentIndex, children: screens),

        // ignore: sized_box_for_whitespace
        floatingActionButton: Container(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Addnotescreen()));
            },
            backgroundColor: Color(0xff6A3EA1),
            elevation: 5,
            shape: CircleBorder(),
            child: Icon(Icons.add, size: 30.0, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
          ),

          child: BottomNavigationBar(
            showSelectedLabels: true,
            selectedLabelStyle: TextStyle(color: Color(0xff6A3EA1)),
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            elevation: 0,

            selectedItemColor: Color(0xff6A3EA1),
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.grey.shade100,

            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _currentIndex == 0 ? 'assets/images/coloredHome.svg' : 'assets/images/home.svg',

                  color: _currentIndex == 0 ? Color(0xff6A3EA1) : Colors.black54,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  _currentIndex == 1 ? 'assets/images/coloredsetting.svg' : 'assets/images/setting.svg',
                  height: 34,
                  color: _currentIndex == 1 ? Color(0xff6A3EA1) : Colors.black54,
                ),
                label: 'Setting',
              ),
            ],
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
