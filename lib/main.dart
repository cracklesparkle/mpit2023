import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mpit2023/map_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'auth_page.dart';
import 'firebase_options.dart';
import 'nearby_page.dart';
import 'profile_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: 'https://hubrelozpwhnirdykdqk.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imh1YnJlbG96cHdobmlyZHlrZHFrIiwicm9sZSI6ImFub24iLCJpYXQiOjE2Nzk1MDM0NTgsImV4cCI6MTk5NTA3OTQ1OH0.wNvYZsDi6NDax4zXl9UIEyVjc8XrgcEUOiGM6vgbojM',
  );
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'ТУТиТАМ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(title: 'ТУТиТАМ'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    ShapesPage(),
    Text(
      'Поиск',
      style: optionStyle,
    ),
    Nearby(),
    Text(
      'События',
      style: optionStyle,
    ),
    Profile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: IconButton(
          icon: Image(image: AssetImage('filter.png')),
          onPressed: () => {},
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.more_vert,
            color: Colors.green,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('В разработке')));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search, color: Colors.green),
            onPressed: () {
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
        ],
      ),
      body: Container(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Карта'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Бонусы'),
          BottomNavigationBarItem(icon: Icon(Icons.navigation), label: 'Рядом'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'События'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Профиль'),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.green[600],
        onTap: _onItemTapped,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Ой, что-то пошло не так :('));
            } else if (snapshot.hasData) {
              return MyHomePage(title: 'Hello');
            } else {
              return AuthPage();
            }
          }),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
