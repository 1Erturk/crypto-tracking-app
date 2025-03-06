/*
import 'package:cryptocurrency_exchange/tools/locator.dart';
import 'package:cryptocurrency_exchange/view/market_view.dart';
import 'package:cryptocurrency_exchange/view_model/NavigationViewModel.dart';
import 'package:cryptocurrency_exchange/view_model/bottom_navigation_bar_view_model.dart';
import 'package:cryptocurrency_exchange/view_model/market_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MarketViewModel()),
        ChangeNotifierProvider(create: (context) => BottomNavigationBarViewModel()),
        ChangeNotifierProvider(create: (context) => NavigationViewModel()),
      ],
      child: MaterialApp(
        home: MarketView(),
      ),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (BuildContext context) => MarketViewModel(),
          ),
          ChangeNotifierProvider(
              create: (BuildContext context) => BottomNavigationBarViewModel(),
          ),
        ],
        child: MarketView(),
      ),
    );
  }

   */



  /*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => MarketViewModel(),
        child: MarketView(),
      ),
    );
  }
   */
}

 */

import 'package:cryptocurrency_exchange/tools/AppColors.dart';
import 'package:cryptocurrency_exchange/tools/locator.dart';
import 'package:cryptocurrency_exchange/view/bottom_navigation_bar_view.dart';
import 'package:cryptocurrency_exchange/view/market_view.dart';
import 'package:cryptocurrency_exchange/view/news_view.dart';
import 'package:cryptocurrency_exchange/view/watchlist_view.dart';
import 'package:cryptocurrency_exchange/view_model/bottom_navigation_bar_view_model.dart';
import 'package:cryptocurrency_exchange/view_model/market_view_model.dart';
import 'package:cryptocurrency_exchange/view_model/news_view_model.dart';
import 'package:cryptocurrency_exchange/view_model/watchlist_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

/*
void initializeWorkManager() {
  try {
    print("Initialize Work manager");
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    print("WorkManager initialized successfully");
  } catch (e) {
    print("Error initializing WorkManager: $e");
  }

  try {
    /*
    Workmanager().registerPeriodicTask(
      "news_update",
      "news_update_task",
      frequency: Duration(minutes: 15),
      inputData: <String, dynamic>{},
    );
     */
    Workmanager().registerOneOffTask(
      "news_update",
      "news_update_task",
      inputData: <String, dynamic>{},
    );
    print("Periodic task registered successfully");
  } catch (e) {
    print("Error registering periodic task: $e");
  }
}

void callbackDispatcher() {
  print("CallbackDispatcher");
  Workmanager().executeTask((task, inputData) async {
    if (task == "news_update") {
      print("news_update task started");
      try {
        await newsTask();
        print("Simple task executed successfully");
      } catch (e) {
        print("Error in executing news_update task: $e");
      }
    }
    return Future.value(true);
  });
}

Future<void> newsTask() async {
  try {
    print("Executing newsTask");
    final viewModel = NewsViewModel();
    await viewModel.updateNews();
    print("newsTask completed");
  } catch (e) {
    print("Error in newsTask: $e");
  }
}
 */

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MarketViewModel()),
        ChangeNotifierProvider(create: (context) => BottomNavigationBarViewModel()),
        //ChangeNotifierProvider(create: (context) => NavigationViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeView(),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationBarViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: IndexedStack(
            index: viewModel.selectedItem,
            children: <Widget>[
              ChangeNotifierProvider(
                create: (context) => MarketViewModel(),
                child: MarketView(), // MarketView
              ),
              ChangeNotifierProvider(
                create: (context) => WatchlistViewModel(),
                child: WatchlistView(), // WatchlistView
              ),
              ChangeNotifierProvider(
                create: (context) => NewsViewModel(),
                child: NewsView(), // NewsView
              ),
              /*
              ChangeNotifierProvider(
                create: (context) => CoinDetailPageViewModel(),
                child: CoinDetailPageView(), // NewsView
              ),
               */
            ],
          ),
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: AppColors.containerColor
            ),
            child: BottomNavigationBarView(),
          ),
        );
      },
    );
  }

}