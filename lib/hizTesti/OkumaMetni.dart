import 'package:flutter/material.dart';
import "package:Hizlanio/hizTesti/metinlervesorular.dart";

Widget okumaMetni(
    Metin selectedMetin, double screenHeight, VoidCallback finishReading) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  selectedMetin.content,
                  style: TextStyle(
                    fontSize: screenHeight / 35,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: finishReading,
              child: const Text("Okumayı Bitir"),
            ),
          ],
        ),
      ),
    ),
  );
}
