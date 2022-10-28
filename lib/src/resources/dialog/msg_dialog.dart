import 'package:flutter/material.dart';

class MsgDialog {
  static void showMsgDialog(BuildContext context, String title, String msg) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: SizedBox(
                  height: 90, width: 100, child: Center(child: Text(msg))),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop(MsgDialog);
                      },
                    ),
                  ),
                )
              ],
            ));
  }
}
