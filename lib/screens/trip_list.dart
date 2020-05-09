import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertrippass/screens/trip_detail.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:fluttertrippass/models/trip_model.dart';
import 'package:fluttertrippass/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class TripList extends StatefulWidget {
  final TripModel tripModel;

  TripList(this.tripModel);

  @override
  _TripListState createState() => _TripListState(this.tripModel);
}

class _TripListState extends State<TripList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<TripModel> tripList;
  int count = 0;

  // databaseHelper
  DatabaseHelper helper = DatabaseHelper();

  TripModel tripModel;
  _TripListState(this.tripModel);

  @override
  Widget build(BuildContext context) {
    if (tripList == null) {
      tripList = List<TripModel>();
      updateListView();
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
            child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 15.0, right: 15.0, left: 15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Hello, Arthor',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      FlatButton(
                        color: Colors.blue,
                        onPressed: () {},
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Text(
                          '$count Trip(s)',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Create your \ntrips with us.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: count,
                  itemBuilder: (BuildContext context, int position) {
                    return Card(
                      elevation: 12.0,
                      margin: EdgeInsets.only(
                          top: 8.0, left: 15.0, right: 15.0, bottom: 3.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  this.tripList[position].departure ?? 'Lagos',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.plane,
                                  size: 20.0,
                                  color: Colors.grey,
                                ),
                                Text(
                                  this.tripList[position].destination,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  this.tripList[position].departureDate ??
                                      'Jan 01, 2020',
                                  style: TextStyle(fontSize: 13.0),
                                ),
                                Text(
                                  this.tripList[position].destinationDate,
                                  style: TextStyle(fontSize: 13.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  this.tripList[position].departureTime ??
                                      '00:00',
                                  style: TextStyle(fontSize: 13.0),
                                ),
                                Text(
                                  this.tripList[position].destinationTime,
                                  style: TextStyle(fontSize: 13.0),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Card(
                                  margin: EdgeInsets.all(0.0),
                                  color: getCategoryColor(
                                      this.tripList[position].categorySelected),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Text(
                                      this.tripList[position].categorySelected,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    child: Icon(
                                      Icons.more_vert,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    PopupMenuItem(
                                      value: "update_val",
                                      child: Text('Update'),
                                    ),
                                    PopupMenuItem(
                                      value: "delete_val",
                                      child: Text('Delete'),
                                    ),
                                  ],
                                  onSelected: (retrieveVal) {
                                    print(retrieveVal);
                                    if (retrieveVal == "update_val") {
                                      print('Updating...');
                                      _navigateToDetailPage(
                                          this.tripList[position], "Edit Trip");
                                    } else {
                                      print('deleting ...');
                                      _delete(context, tripList[position]);
                                      // _delete(context, tripModel);
                                    }
                                  },
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  'Created: ',
                                  style: TextStyle(fontSize: 10.0),
                                ),
                                SizedBox(width: 3.0),
                                Text(
                                  this.tripList[position].date,
                                  style: TextStyle(fontSize: 10.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add Trip',
        onPressed: () {
          debugPrint('Tapped FAB');
          _navigateToDetailPage(
              TripModel('', '', '', '', '', '', '', ''), 'Create a Trip');
        },
      ),
    );
  }

  // return category color
  Color getCategoryColor(String category) {
    switch (category) {
      case 'Business':
        return Colors.blue;
        break;
      case 'Education':
        return Colors.deepPurple;
        break;
      case 'Medical':
        return Colors.deepOrange;
        break;
      case 'Vacation':
        return Colors.orange;
        break;
      default:
        return Colors.orange;
    }
  }

  void _delete(BuildContext context, TripModel tripModel) async {
    int result = await databaseHelper.deleteTrip(tripModel.id);
    if (result != 0) {
      _showSnackBar(context, 'Trip Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _navigateToDetailPage(TripModel tripModel, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripDetail(tripModel, title),
      ),
    );
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TripModel>> tripListFuture = databaseHelper.getTripList();
      tripListFuture.then((tripList) {
        setState(() {
          this.tripList = tripList;
          this.count = tripList.length;
        });
      });
    });
  }
}
