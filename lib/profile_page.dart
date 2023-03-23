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
    return ListView(
      children: <Widget>[
        Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.account_circle,
                  size: 56,
                ),
                title: Text(user.email!.toString()),
                subtitle: Text(''),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
        ListTile(title: Text('Уведомления')),
        ListTile(title: Text('Забронировано')),
        ListTile(
          title: Text('Посещенные места'),
          onTap: () {
            Navigator.push(context, MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      color: Colors.green.shade600,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: Colors.white,
                    title: const Text('Искать'),
                  ),
                  body: const Center(
                    child: Text(
                      'Поиск',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ));
          },
        ),
        ListTile(title: Text('Любимые места')),
        ListTile(title: Text('Отзывы')),
        ListTile(title: Text('Сообщения')),
        ListTile(title: Text('Сохраненные карты')),
        ListTile(title: Text('Личные данные')),
        ListTile(title: Text('Служба поддержки')),
        ListTile(title: Text('О приложении')),
        SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: RichText(
              text: TextSpan(
            recognizer: TapGestureRecognizer(),
            text: user.email!,
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
                  text: 'Выйти из аккаунта',
                  style: TextStyle(
                      //color: Theme.of(context).colorScheme.onPrimary))
                      color: Colors.red))),
        ),
      ],
    );
  }
}
