import 'package:flutter/material.dart';
import 'dart:html' as html;

class FullScreenButton extends StatefulWidget {
  const FullScreenButton({super.key});

  @override
  _FullScreenButtonState createState() => _FullScreenButtonState();
}

class _FullScreenButtonState extends State<FullScreenButton> {
  bool isFullScreen = false;

  void toggleFullScreen() {
    final element = html.document.documentElement!;
    if (!isFullScreen) {
      element.requestFullscreen();
    } else {
      html.document.exitFullscreen();
    }
    setState(() {
      isFullScreen = !isFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool showText = MediaQuery.of(context).size.width > 1200;

    return ElevatedButton(
      onPressed: toggleFullScreen,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black38,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          ),
        ),
        padding:
            const EdgeInsets.symmetric(vertical: 20), // Butonun yüksekliğini artırır
      ),
      child: Row(
        children: [
          Icon(
            isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
            color: Colors.white, // İkonun rengi
          ),
          if (showText) const SizedBox(width: 8),
          if (showText)
            Text(
              isFullScreen ? '' : 'Tam Ekran Yap',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
        ],
      ),
    );
  }
}
