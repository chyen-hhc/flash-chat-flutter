import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';

Future<String> createAlert(BuildContext context, String alert) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(alert),
          actions: [
            MaterialButton(
              onPressed: () {},
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'OK',
                  style: kSendButtonTextStyle,
                ),
              ),
            ),
          ],
        );
      });
}
