import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final String logoOne = 'logo_one.svg';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 32,
            ),
            // SvgPicture.asset(logoOne, semanticsLabel: 'ТУТиТАМ'),
            Container(
                width: 100, child: Image(image: AssetImage('logo_two.png'))),
            SizedBox(
              height: 32,
            ),
            Text(
              'Найди базу отдыха по душе',
              style: TextStyle(color: Colors.green.shade800, fontSize: 18),
            ),
            SizedBox(
              height: 32,
            ),
            TextField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                  labelText: 'Логин или E-mail',
                  labelStyle: TextStyle(color: Colors.green.shade600),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          BorderSide(color: Colors.green.shade600, width: 2.5)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
              obscureText: false,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  labelText: 'Пароль',
                  labelStyle: TextStyle(color: Colors.green.shade600),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide:
                          BorderSide(color: Colors.green.shade600, width: 2.5)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25))),
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
              child: Text(
                'Войти',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: signIn,
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 12),
                    text: 'Нет аккаунта? ',
                    children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignUp,
                      text: 'Зарегистрироваться',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          //color: Theme.of(context).colorScheme.onPrimary))
                          color: Colors.green.shade600))
                ])),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //       minimumSize: Size.fromHeight(50),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(25))),
            //   child: Text(
            //     'Зарегистрироваться',
            //     style: TextStyle(fontSize: 16),
            //   ),
            //   onPressed: signIn,
            // )
          ],
        ));
  }

  Future signIn() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ),
        barrierDismissible: false);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
