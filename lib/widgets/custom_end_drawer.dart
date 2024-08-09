import 'package:flutter/material.dart';
import 'package:Hizlanio/Kayitol.dart';
import 'package:Hizlanio/girisyap.dart';
import 'package:Hizlanio/iletisim.dart';

class CustomEndDrawer extends StatelessWidget {
  final double rowHeight;

  const CustomEndDrawer({super.key, required this.rowHeight});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 4, 69, 122),
            ),
            child: Text('Menü'),
          ),
          ListTile(
            title: const Text('Anasayfa'),
            onTap: () {
              Navigator.pushNamed(context, '/'); // Ana sayfaya yönlendirme
            },
          ),
          ListTile(
            title: const Text('İletişim'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Iletisim()),
              );
            },
          ),
          ListTile(
            title: const Text('Premium'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Giriş Yap'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Girisyap()),
              );
            },
          ),
          ListTile(
            title: const Text('Kayıt Ol'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Kayitol()),
              );
            },
          ),
        ],
      ),
    );
  }
}
