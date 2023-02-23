import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

class BottomNavBarCustom extends ConsumerWidget {
  const BottomNavBarCustom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.thermostat),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: 1,
      selectedItemColor: Colors.blue[800],
      // onTap: _onItemTapped,
    );
  }
}

