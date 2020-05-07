class TripModel {
  int _id;
  String _departure;
  String _departureDate;
  String _departureTime;
  String _destination;
  String _destinationDate;
  String _destinationTime;
  String _date;
  //int _category;
  String _categorySelected;

  TripModel(
    this._departure,
    this._departureDate,
    this._departureTime,
    this._destination,
    this._destinationDate,
    this._destinationTime,
    this._date,
    //this._category,
    this._categorySelected,
  );

  TripModel.withId(
    this._id,
    this._departure,
    this._departureDate,
    this._departureTime,
    this._destination,
    this._destinationDate,
    this._destinationTime,
    this._date,
    //this._category,
    this._categorySelected,
  );

  int get id => _id;
  String get departure => _departure;
  String get departureDate => _departureDate;
  String get departureTime => _departureTime;
  String get destination => _destination;
  String get destinationDate => _destinationDate;
  String get destinationTime => _destinationTime;
  //int get category => _category;
  String get date => _date;
  String get categorySelected => _categorySelected;

  set departure(String newDeparture) {
    if (newDeparture.length <= 255) {
      this._departure = newDeparture;
    }
  }

  set departureDate(String newDepartureDate) {
    this._departureDate = newDepartureDate;
  }

  set departureTime(String newDepartureTime) {
    this._departureTime = newDepartureTime;
  }

  set destination(String newDestination) {
    if (newDestination.length <= 255) {
      this._destination = newDestination;
    }
  }

  set destinationDate(String newDestinationDate) {
    this._destinationDate = newDestinationDate;
  }

  set destinationTime(String newDestinationTime) {
    this._destinationTime = newDestinationTime;
  }

//  set category(int newCategory) {
//    if (newCategory >= 1 && newCategory >= 4) {
//      this._category = newCategory;
//    }
//  }

  set date(String newDate) {
    this._date = newDate;
  }

  set categorySelected(String newCategorySelected) {
    this._categorySelected = newCategorySelected;
  }

  // Convert TripModel object to Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['departure'] = _departure;
    map['departureDate'] = _departureDate;
    map['departureTime'] = _departureTime;
    map['destination'] = _destination;
    map['destinationDate'] = _destinationDate;
    map['destinationTime'] = _destinationTime;
    //map['category'] = _category;
    map['date'] = _date;
    map['categorySelected'] = _categorySelected;

    return map;
  }

  // Extract TripModel object from from Map object
  TripModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._departure = map['departure'];
    this._departureDate = map['departureDate'];
    this._departureTime = map['departureTime'];
    this._destination = map['destination'];
    this._destinationDate = map['destinationDate'];
    this._destinationTime = map['destinationTime'];
    //this._category = map['category'];
    this._date = map['date'];
    this._categorySelected = map['categorySelected'];
  }
}
