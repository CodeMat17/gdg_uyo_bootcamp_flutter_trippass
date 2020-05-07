import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertrippass/models/trip_model.dart';

class DatabaseHelper {
  //Singleton DatabaseHelper
  static DatabaseHelper _databaseHelper;
  // singleton database
  static Database _database;

  String tripTable = 'tripTable';
  String colId = 'id';
  String colDeparture = 'departure';
  String colDepartureDate = 'departureDate';
  String colDepartureTime = 'departureTime';
  String colDestination = 'destination';
  String colDestinationDate = 'destinationDate';
  String colDestinationTime = 'destinationTime';
  //String colCategory = 'category';
  String colDate = 'date';
  String colCategorySelected = 'categorySelected';

  // Named constructor to create instance of DatabaseHelper
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      // this is executed only once. singleton object
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both android and ios to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'trips.db';

    // open/create the database at a given path
    var tripsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return tripsDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tripTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colDeparture TEXT, $colDepartureDate TEXT, $colDepartureTime TEXT, $colDestination TEXT, $colDestinationDate TEXT, $colDestinationTime TEXT, $colDate TEXT, $colCategorySelected TEXT)');
  }

  // fetch operation: get all objects fro database
  Future<List<Map<String, dynamic>>> getTripMapList() async {
    Database db = await this.database;
    var result = await db.query(tripTable);
    return result;
  }

  // insert operation: insert a trip object to database
  Future<int> insertTrip(TripModel tripModel) async {
    Database db = await this.database;
    var result = await db.insert(tripTable, tripModel.toMap());
    return result;
  }

  // update operation: update a trip object a nd save to database
  Future<int> updateTrip(TripModel tripModel) async {
    var db = await this.database;
    var result = await db.update(tripTable, tripModel.toMap(),
        where: '$colId = ?', whereArgs: [tripModel.id]);
    return result;
  }

  // delete operation: delete a trip object from database
  Future<int> deleteTrip(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $tripTable WHERE $colId = $id');
    return result;
  }

  // get number of trip objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $tripTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // get map list and convert to trip object list
  Future<List<TripModel>> getTripList() async {
    var tripMapList = await getTripMapList(); // get map list from db
    int count = tripMapList.length;

    List<TripModel> tripList = List<TripModel>();
    // for loop to create a 'tripModel list' from map list
    for (int i = 0; i < count; i++) {
      tripList.add(TripModel.fromMapObject(tripMapList[i]));
    }
    return tripList;
  }
}
