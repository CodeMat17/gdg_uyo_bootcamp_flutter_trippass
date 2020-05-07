import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertrippass/models/trip_model.dart';
import 'package:fluttertrippass/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class TripDetail extends StatefulWidget {
  // appBar title
  final String appBarTitle;
  final TripModel tripModel;

  TripDetail(this.tripModel, this.appBarTitle);

  @override
  _TripDetailState createState() =>
      _TripDetailState(this.tripModel, this.appBarTitle);
}

class _TripDetailState extends State<TripDetail> {
  //texFields controllers
  var departureController = TextEditingController();
  var departureDate = TextEditingController();
  var departureTime = TextEditingController();
  var destinationController = TextEditingController();
  var destinationDate = TextEditingController();
  var destinationTime = TextEditingController();

  // dropDown menu categories
  final _categories = ['Business', 'Education', 'Medical', 'Vacation'];
  String categorySelected = 'Medical';

  // databaseHelper
  DatabaseHelper helper = DatabaseHelper();

  // appBar title
  String appBarTitle;
  TripModel tripModel;
  _TripDetailState(this.tripModel, this.appBarTitle);

  //dateTime picker formField
  final dateFormat = DateFormat("MMMM d, yyyy");
  final timeFormat = DateFormat("h:mm a");

  //validation
  bool _validate = false;

  @override
  void dispose() {
    departureController.dispose();
    departureDate.dispose();
    departureTime.dispose();
    destinationController.dispose();
    destinationDate.dispose();
    destinationTime.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    departureController.text = tripModel.departure;
    departureDate.text = tripModel.departureDate;
    departureTime.text = tripModel.departureTime;
    destinationController.text = tripModel.destination;
    destinationDate.text = tripModel.destinationDate;
    destinationTime.text = tripModel.destinationTime;
    categorySelected = tripModel.categorySelected;

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Container(
        //margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: <Widget>[
                    TextField(
                      controller: departureController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        debugPrint('something changed');
                        updateDeparture();
                      },
                      decoration: InputDecoration(
                        hintText: 'From:',
                        labelText: 'Enter Departure',
                        errorText: _validate ? 'All fields are required' : null,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: TextField(
                            controller: departureDate,
                            keyboardType: TextInputType.datetime,
                            onChanged: (value) {
                              debugPrint('something changed');
                              updateDepartureDate();
                            },
                            decoration: InputDecoration(
                              hintText: 'From: ',
                              labelText: 'Enter Date',
                            ),
                          ),
                        ),
                        Expanded(flex: 1, child: Text('')),
//                        Expanded(
//                          flex: 3,
//                          child: DateTimeField(
//                              format: timeFormat,
//                              onShowPicker: (
//                                context,
//                                currentValue,
//                              ) async {
//                                departureTime = await showTimePicker(
//                                  context: context,
//                                  initialTime: TimeOfDay.fromDateTime(
//                                      currentValue ?? DateTime.now()),
//                                );
//                                return DateTimeField.convert(departureTime);
//                              }),
//                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: departureTime,
                            keyboardType: TextInputType.datetime,
                            onChanged: (value) {
                              debugPrint('something changed');
                              updateDepartureTime();
                            },
                            decoration: InputDecoration(
                              hintText: 'From:',
                              labelText: 'Enter Time',
                            ),
                          ),
                        )
                      ],
                    ),
                    TextField(
                      controller: destinationController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        debugPrint('something changed');
                        updateDestination();
                      },
                      decoration: InputDecoration(
                        hintText: 'To:',
                        labelText: 'Enter Destination',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 4,
                          child: TextField(
                            controller: destinationDate,
                            keyboardType: TextInputType.datetime,
                            onChanged: (value) {
                              debugPrint('something changed');
                              updateDestinationDate();
                            },
                            decoration: InputDecoration(
                              hintText: 'To:',
                              labelText: 'Enter Date',
                            ),
                          ),
                        ),
                        Expanded(flex: 1, child: Text('')),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: destinationTime,
                            keyboardType: TextInputType.datetime,
                            onChanged: (value) {
                              debugPrint('something changed');
                              updateDestinationTime();
                            },
                            decoration: InputDecoration(
                              hintText: 'To: ',
                              labelText: 'Enter Time',
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      children: <Widget>[
                        Expanded(child: Text('Trip Type: ')),
                        Expanded(
                          child: DropdownButton<String>(
                            items: _categories.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(dropDownStringItem),
                              );
                            }).toList(),
                            style: textStyle,
                            value:
                                getCategoryAsString(tripModel.categorySelected),
                            onChanged: (value) {
                              setState(() {
                                debugPrint('$value');
                                categorySelected = value;
                                debugPrint(
                                    'categorySelected: $categorySelected');
                                updateCategorySelected();
                                getCategoryAsString(categorySelected);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            color: Colors.blue,
                            onPressed: () {
                              setState(() {
                                destinationController.text.isEmpty
                                    ? _validate = true
                                    : _validate = false;
                              });
                              if (_validate != null) {
                                _save();
                              } else {
                                return null;
                              }
                              //_save();
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: Text(
                                'Add Trip',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // convert the string category in the
// form of integer before saving to db
//  void updateCategoryAsInt(String value) {
//    switch (value) {
//      case 'Business':
//        tripModel.category = 1;
//        break;
//      case 'Education':
//        tripModel.category = 2;
//        break;
//      case 'Medical':
//        tripModel.category = 3;
//        break;
//      case 'Vacation':
//        tripModel.category = 4;
//        break;
//    }
//  }

  // convert int category to string category and display in dropdown
  String getCategoryAsString(String value) {
    String category;
    switch (value) {
      case 'Business':
        category = _categories[0]; // 'Business
        break;
      case 'Education':
        category = _categories[1]; // 'Business
        break;
      case 'Medical':
        category = _categories[2]; // 'Business
        break;
      case 'Vacation':
        category = _categories[3]; // 'Business
        break;
    }
    return category;
  }

  // update the textFields of tripModel object
  void updateDeparture() {
    tripModel.departure = departureController.text;
  }

  void updateDepartureDate() {
    tripModel.departureDate = departureDate.text;
  }

  void updateDepartureTime() {
    tripModel.departureTime = departureTime.text;
  }

  void updateDestination() {
    tripModel.destination = destinationController.text;
  }

  void updateDestinationDate() {
    tripModel.destinationDate = destinationDate.text;
  }

  void updateDestinationTime() {
    tripModel.destinationTime = destinationTime.text;
  }

  void updateCategorySelected() {
    tripModel.categorySelected = categorySelected;
  }

  // save data to database
  void _save() async {
    Navigator.pop(context, true);

    tripModel.date = DateFormat('MMM d, yyyy - hh:mm a').format(DateTime.now());
    int result;
    if (tripModel.id != null) {
      //case 1: update operation
      result = await helper.updateTrip(tripModel);
    } else {
      //case 2: insert operation
      result = await helper.insertTrip(tripModel);
    }
    if (result != 0) {
      //success
      _showAlertDialog('Saved Successfully');
    } else {
      // failure
      _showAlertDialog('Failed !!!');
    }
  }

  void _showAlertDialog(String message) {
    AlertDialog alertDialog = AlertDialog(
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog,
    );
  }
}
