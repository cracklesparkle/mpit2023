import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:latlong2/latlong.dart';

class Nearby extends StatefulWidget {
  const Nearby({super.key});

  @override
  State<Nearby> createState() => _NearbyState();
}

class _NearbyState extends State<Nearby> {
  final _future = Supabase.instance.client
      .from('places')
      .select<List<Map<String, dynamic>>>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final places = snapshot.data!;
        return ListView.builder(
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
              location: km.toString(),
              imagePath: place['cover'],
            );
          }),
        );
      },
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
    return Card(
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
                gradient: LinearGradient(
                    colors: [Color.fromRGBO(0, 0, 0, 0.5), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter)),
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
    );
  }
}
