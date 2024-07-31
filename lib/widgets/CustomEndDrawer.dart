import 'package:flutter/material.dart';
import 'package:Hizlanio/Kayitol.dart';
import 'package:Hizlanio/girisyap.dart';
import 'package:Hizlanio/iletisim.dart';

class CustomEndDrawer extends StatelessWidget {
  final double rowHeight;

  const CustomEndDrawer({Key? key, required this.rowHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menü'),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 4, 69, 122),
            ),
          ),
          ListTile(
            title: Text('Anasayfa'),
            onTap: () {
              Navigator.pushNamed(context, '/'); // Ana sayfaya yönlendirme
            },
          ),
          ListTile(
            title: Text('İletişim'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Iletisim()),
              );
            },
          ),
          ListTile(
            title: Text('Premium'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Giriş Yap'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Girisyap()),
              );
            },
          ),
          ListTile(
            title: Text('Kayıt Ol'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Kayitol()),
              );
            },
          ),
        ],
      ),
    );
  }
}
