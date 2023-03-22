import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: RichText(
              text: TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                FirebaseAuth.instance.signOut();
              },
            text: 'Забронировано',,
            style: TextStyle(fontSize: 18)
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: RichText(
              text: TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                FirebaseAuth.instance.signOut();
              },
            text: 'Посещенные места',
            style: TextStyle(fontSize: 18)
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            // '$_counter',
            user.email!,
            style: TextStyle(fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: RichText(
              text: TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      FirebaseAuth.instance.signOut();
                    },
                  text: 'Выйти из аккаунта',
                  style: TextStyle(
                      //color: Theme.of(context).colorScheme.onPrimary))
                      color: Colors.red))),
        ),
      ],
    );
  }
}
