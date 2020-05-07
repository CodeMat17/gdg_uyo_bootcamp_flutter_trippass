import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertrippass/models/trip_model.dart';
import 'package:fluttertrippass/screens/trip_list.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  final TripModel tripModel;
  SplashScreen({this.tripModel});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _splashToFirstScreen();
  }

  Future<bool> _splashToFirstScreen() async {
    await Future.delayed(Duration(milliseconds: 5000), () {
      _navigateToFirstScreen();
    });
    return true;
  }

  void _navigateToFirstScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (BuildContext context) => TripList(tripModel)),
    );
  }

  TripModel tripModel;
  _SplashScreenState({this.tripModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              child: Shimmer.fromColors(
                baseColor: Colors.blueAccent,
                highlightColor: Colors.orangeAccent,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Trippas',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'RockSalt',
                          letterSpacing: 7.0,
                          shadows: <Shadow>[
                            Shadow(
                                blurRadius: 18.0,
                                color: Colors.white,
                                offset: Offset.fromDirection(120, 12))
                          ]),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
