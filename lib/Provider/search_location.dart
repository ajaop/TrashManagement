import 'package:flutter/foundation.dart';

class SearchLocation extends ChangeNotifier {
  bool search = false;

  SearchLocation(this.search);

  void updateState() {
    search = !search;
    notifyListeners();
  }
}
