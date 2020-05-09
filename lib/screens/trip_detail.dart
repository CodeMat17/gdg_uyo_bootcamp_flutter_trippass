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
  TextEditingController departureController = TextEditingController();
  TextEditingController departureDate = TextEditingController();
  TextEditingController departureTime = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController destinationDate = TextEditingController();
  TextEditingController destinationTime = TextEditingController();
  TextEditingController categorySelected = TextEditingController();

  // dropDown menu categories
  final tripType = ['Business', 'Education', 'Medical', 'Vacation'];
  //String categorySelected = 'Medical';

  // databaseHelper
  DatabaseHelper helper = DatabaseHelper();

  // appBar title
  String appBarTitle;
  TripModel tripModel;
  _TripDetailState(this.tripModel, this.appBarTitle);

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
    departureController.text = tripModel.departure;
    departureDate.text = tripModel.departureDate;
    departureTime.text = tripModel.departureTime;
    destinationController.text = tripModel.destination;
    destinationDate.text = tripModel.destinationDate;
    destinationTime.text = tripModel.destinationTime;
    categorySelected.text = tripModel.categorySelected;

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
                        this.tripModel.departure = departureController.text;
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
                            child: DateTimeField(
                              controller: departureDate,
                              format: DateFormat.yMMMd("en_US"),
                              onShowPicker: (context, currentValue) async {
                                return await showDatePicker(
                                  context: context,
                                  initialDate: currentValue ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                              },
                              decoration:
                                  InputDecoration(labelText: 'Enter Date'),
                              onChanged: (dt) {
                                debugPrint('$dt');
                                this.tripModel.departureDate =
                                    DateFormat.yMMMd("en_US").format(dt);
                                debugPrint(tripModel.departureDate);
                                debugPrint(departureDate.text);
                                updateDepartureDate();
                              },
                            )),
                        SizedBox(width: 20.0),
                        Expanded(
                          flex: 3,
                          child: DateTimeField(
                            controller: departureTime,
                            format: DateFormat.jm(),
                            decoration:
                                InputDecoration(labelText: 'Enter Time'),
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: currentValue ?? TimeOfDay.now(),
                              );
                              return DateTimeField.convert(time);
                            },
                            onChanged: (t) {
                              this.tripModel.departureTime =
                                  DateFormat.jm().format(t);
                              updateDepartureTime();
                            },
                          ),
                        ),
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
                            child: DateTimeField(
                              controller: destinationDate,
                              format: DateFormat.yMMMd("en_US"),
                              onShowPicker: (context, currentValue) async {
                                return await showDatePicker(
                                  context: context,
                                  initialDate: currentValue ?? DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                              },
                              decoration:
                                  InputDecoration(labelText: 'Enter Date'),
                              onChanged: (dt) {
                                debugPrint('$dt');
                                this.tripModel.destinationDate =
                                    DateFormat.yMMMd("en_US").format(dt);
                                debugPrint(tripModel.destinationDate);
                                debugPrint(destinationDate.text);
                                updateDestinationDate();
                              },
                            )),
                        SizedBox(width: 20.0),
                        Expanded(
                          flex: 3,
                          child: DateTimeField(
                            controller: destinationTime,
                            format: DateFormat.jm(),
                            decoration:
                                InputDecoration(labelText: 'Enter Time'),
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: currentValue ?? TimeOfDay.now(),
                              );
                              return DateTimeField.convert(time);
                            },
                            onChanged: (t) {
                              this.tripModel.destinationTime =
                                  DateFormat.jm().format(t);
                              updateDestinationTime();
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: DropdownButton<String>(
                            items: tripType.map((String value) {
                              return DropdownMenuItem<String>(
                                child: Text(value),
                                value: value,
                              );
                            }).toList(),
                            hint: Text('Trip Type'),
                            value: getCategoryAsString(categorySelected.text),
                            //value: tripModel.categorySelected,
                            onChanged: (value) {
                              setState(() {
                                debugPrint('Value: $value');
                                //getCategoryAsString(categorySelected.text);
                                categorySelected.text = value;
                                this.tripModel.categorySelected = value;
                                debugPrint(
                                    'categorySelected: $tripModel.categorySelected.');
                                updateCategorySelected();
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

  // convert int category to string category and display in dropdown
  String getCategoryAsString(String value) {
    String category;
    switch (value) {
      case 'Business':
        category = tripType[0]; // 'Business
        break;
      case 'Education':
        category = tripType[1]; // 'Business
        break;
      case 'Medical':
        category = tripType[2]; // 'Business
        break;
      case 'Vacation':
        category = tripType[3]; // 'Business
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
    tripModel.categorySelected = categorySelected.text;
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
