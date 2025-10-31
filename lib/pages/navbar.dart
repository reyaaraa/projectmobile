import 'package:flutter/material.dart';
import 'package:projectmobile/pages/home_page.dart';
import 'package:projectmobile/pages/me.dart';
import 'package:projectmobile/pages/toko.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  // Daftar halaman yang akan ditampilkan
  static const List<Widget> _pages = <Widget>[HomePage(), TokoPage(), MePage()];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_mall_directory_outlined),
            label: 'Toko',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF00796B),
        onTap: onItemTapped,
      ),
    );
  }
}
