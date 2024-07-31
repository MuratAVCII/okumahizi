import 'package:Hizlanio/widgets/full_screen_button.dart';
import 'package:flutter/material.dart';
import 'package:Hizlanio/iletisim.dart';
import 'package:Hizlanio/girisyap.dart';
import 'package:Hizlanio/Kayitol.dart';

class CustomAppBar extends StatelessWidget {
  final double sidePadding;
  final double screenWidth;
  final double rowHeight;

  const CustomAppBar({
    Key? key,
    required this.sidePadding,
    required this.screenWidth,
    required this.rowHeight,
    required List<FullScreenButton> actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final maxWidth = 1200.0;
    final appBarWidth =
        screenWidth > maxWidth ? maxWidth : screenWidth - 2 * sidePadding;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: appBarWidth,
          height: MediaQuery.of(context).size.height / 10,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/'); // Ana sayfaya yönlendirme
                },
                child: Container(
                  padding: EdgeInsets.only(left: sidePadding),
                  child: Image.asset(
                    'images/Group 1774.png', // Logonuzun yolu
                    height: MediaQuery.of(context).size.height / 10,
                  ),
                ),
              ),
              if (screenWidth > 550)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, '/'); // Ana sayfaya yönlendirme
                        },
                        child: Text("Anasayfa",
                            style: TextStyle(
                                fontSize: rowHeight / 5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Iletisim()));
                        },
                        child: Text("İletişim",
                            style: TextStyle(
                                fontSize: rowHeight / 5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      TextButton(
                        onPressed: () {},
                        child: Text("Premium",
                            style: TextStyle(
                                fontSize: rowHeight / 5,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange)),
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Girisyap()),
                          );
                        },
                        child: Text("Giriş Yap",
                            style: TextStyle(
                                fontSize: rowHeight / 5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ],
                  ),
                )
              else
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
