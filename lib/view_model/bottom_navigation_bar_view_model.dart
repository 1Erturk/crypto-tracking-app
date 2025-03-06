import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BottomNavigationBarViewModel with ChangeNotifier {
  int _selectedItem = 0;

  int get selectedItem => _selectedItem;

  void onItemTapped(BuildContext context, int index) {
    if(_selectedItem == index) {
      return;
    }
    _selectedItem = index;
    //openSelectedPage(context);
    notifyListeners();
  }

  /*
  void openSelectedPage(BuildContext context) {
    MaterialPageRoute pageRoute;

    switch(_selectedItem) {
      case 0 :
        pageRoute = MaterialPageRoute(
            builder: (context) {
              return ChangeNotifierProvider(
                create: (context) => MarketViewModel(),
                child: MarketView(),
              );
            });
      case 1 :
        pageRoute = MaterialPageRoute(
            builder: (context) {
              return ChangeNotifierProvider(
                create: (context) => WatchlistViewModel(),
                child: WatchlistView(),
              );
            });
      case 2 :
        pageRoute = MaterialPageRoute(
            builder: (context) {
              return ChangeNotifierProvider(
                create: (context) => NewsViewModel(),
                child: NewsView(),
              );
            });
      case 3 :

      default :
        pageRoute = MaterialPageRoute(
            builder: (context) {
              return ChangeNotifierProvider(
                create: (context) => MarketViewModel(),
                child: MarketView(),
              );
            });
    }

    Navigator.pushReplacement(context, pageRoute);
    //Navigator.pushAndRemoveUntil(context, pageRoute, (route) => false);
    //Navigator.push(context, pageRoute);

  }

   */
}
