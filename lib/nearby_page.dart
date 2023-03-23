import 'package:carousel_slider/carousel_slider.dart';
import 'package:filter_list/filter_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:floating_tabbar/Models/tab_item.dart';
import 'package:floating_tabbar/floating_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:latlong2/latlong.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=195&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=195&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=195&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=195&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=135&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class Nearby extends StatefulWidget {
  const Nearby({super.key});

  @override
  State<Nearby> createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  final _future = Supabase.instance.client
      .from('places')
      .select<List<Map<String, dynamic>>>();
  final _momentCount = 5;
  final _momentDuration = const Duration(seconds: 5);
  @override
  Widget build(BuildContext context) {
    final promoList = ['Акции', 'Бонусы', 'Вакансии', 'Горячие туры'];
    final images = List.generate(
      _momentCount,
      (idx) => Container(color: Colors.green),
    );

    return Column(
      children: [
        // Container(
        //     child: CarouselSlider(
        //   options: CarouselOptions(
        //     padEnds: false,
        //     aspectRatio: 2.0,
        //     enlargeCenterPage: false,
        //     enableInfiniteScroll: false,
        //     initialPage: 0,
        //     autoPlay: false,
        //   ),
        //   items: imageSliders,
        // )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text('отдых'),
                labelStyle: TextStyle(color: Colors.black),
              ),
              Chip(
                label: Text('поесть'),
                labelStyle: TextStyle(color: Colors.black),
              ),
              Chip(
                label: Text('рыбалка'),
                labelStyle: TextStyle(color: Colors.black),
              ),
              Chip(
                label: Text('лыжи'),
                labelStyle: TextStyle(color: Colors.black),
              ),
              Chip(
                label: Text('хайкинг'),
                labelStyle: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
          ),
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     GestureDetector(
          //       child: PromoStories(
          //         promoListItem: promoList[0],
          //         color: Colors.blue,
          //       ),
          //       onTap: () {
          //         showDialog(
          //             context: context,
          //             builder: (context) {
          //               return Scaffold(
          //                 body: Story(
          //                   onFlashForward: Navigator.of(context).pop,
          //                   onFlashBack: Navigator.of(context).pop,
          //                   momentCount: 5,
          //                   momentDurationGetter: (idx) => _momentDuration,
          //                   momentBuilder: (context, idx) => images[idx],
          //                 ),
          //               );
          //             });
          //       },
          //     ),
          //     PromoStories(
          //       promoListItem: promoList[1],
          //       color: Colors.yellow,
          //     ),
          //     PromoStories(
          //       promoListItem: promoList[2],
          //       color: Colors.green,
          //     ),
          //     PromoStories(
          //       promoListItem: promoList[3],
          //       color: Colors.red,
          //     ),
          //   ],
          // ),
        ),
        NearbyPlace()
      ],
    );
  }

  FutureBuilder<List<Map<String, dynamic>>> NearbyPlace() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final places = snapshot.data!;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: places.length,
          itemBuilder: ((context, index) {
            final place = places[index];
            final Distance distance = new Distance();
            final km = distance.as(
                LengthUnit.Kilometer,
                new LatLng(place['lat'], place['long']),
                new LatLng(62.035454, 129.675476));

            return NearbyCard(
              name: place['name'],
              location: km.toString() + ' км',
              imagePath: place['cover'],
            );
          }),
        );
      },
    );
  }
}

class PromoStories extends StatelessWidget {
  const PromoStories(
      {super.key, required this.promoListItem, required this.color});

  final String promoListItem;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: color,
          border: Border.all(width: 2, color: Colors.transparent)),
      child: Center(
          child: Text(
        promoListItem,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Arial Black'),
      )),
    );
  }
}

class NearbyCard extends StatelessWidget {
  const NearbyCard(
      {super.key,
      required this.name,
      required this.location,
      required this.imagePath});

  final name;
  final location;
  final imagePath;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(context, MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return Scaffold(
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
                floatingActionButton: FloatingActionButton.extended(
                    onPressed: () {},
                    label: Text(
                        'Построить маршрут')), // This trailing comma makes auto-formatting nicer for build methods.
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    color: Colors.green.shade600,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Image.network(
                      'https://hubrelozpwhnirdykdqk.supabase.co/storage/v1/object/public/places/organisation_logo_01.png'),
                ),
                body: Column(children: [
                  Card(
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                              'https://hubrelozpwhnirdykdqk.supabase.co/storage/v1/object/public/places/organisation_banner.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                Color.fromRGBO(0, 0, 0, 0.5),
                                Colors.transparent
                              ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter)),
                          height: 180,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  'АКТИВНЫЙ СЕМЕЙНЫЙ И ЭКСТРЕМАЛЬНЫЙ ОТДЫХ В ЯКУТИИ \nСпортивно-развлекательный центр «Техтюр» \n\n— все для лучших условий вашего досуга.',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat'),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            ),
                          )),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(15),
                      //       color: Colors.grey),
                      //   child: Text('Лето'),
                      // ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Лето'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Colors.transparent)),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Text('Зима'),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_album),
                    title: Text('Галерея'),
                  ),
                  ListTile(
                    leading: Icon(Icons.star_border_rounded),
                    title: Text('Отзывы'),
                    trailing: RatingBar.builder(
                      itemSize: 16,
                      initialRating: 4.5,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                  ListTile(
                    title: Text('О нас'),
                    leading: Icon(Icons.info),
                  ),
                  ListTile(
                    title: Text('Адрес'),
                    leading: Icon(Icons.navigation),
                    trailing: Text('Покровское шоссе 46 км, 1а'),
                  ),
                  ListTile(
                    title: Text('Время работы'),
                    leading: Icon(Icons.info),
                    trailing: Text('Ежедневно 10:00-19:00'),
                  ),
                  ListTile(
                    title: Text('Связаться:'),
                    leading: Icon(Icons.info),
                    trailing: Text('+ 7 (4112) 25-15-07'),
                  ),
                ]));
          },
        ))
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imagePath),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(0, 0, 0, 0.5),
                Colors.transparent
              ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              height: 180,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                          child: Icon(
                            Icons.place_outlined,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                        Text(
                          location,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                ),
              )),
        ),
      ),
    );
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'No. ${imgList.indexOf(item)} image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
