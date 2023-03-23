import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Organisation extends StatefulWidget {
  const Organisation({super.key});

  @override
  State<Organisation> createState() => _OrganisationState();
}

class _OrganisationState extends State<Organisation> {
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
        ListTile(title: Text('Описание')),
        ListTile(title: Text('Галерея')),
        ListTile(
          title: Text('Тарифы'),
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
        ListTile(title: Text('Посещения')),
        ListTile(title: Text('Продолжительность тура')),
        ListTile(title: Text('Категории')),
        ListTile(title: Text('Вид тура')),
        ListTile(title: Text('Форма собственности')),
        ListTile(title: Text('Информация о страховке')),
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
