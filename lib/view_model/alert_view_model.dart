import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../model/alert.dart';
import '../repository/firestore_repository.dart';
import '../tools/NumberFormatter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../tools/locator.dart';

class AlertViewModel extends ChangeNotifier {
  FirestoreRepository _firestoreRepository = locator<FirestoreRepository>();
  final TextEditingController controller = TextEditingController();
  bool isButtonEnabled = false;
  bool isEqual = false;
  List<Alert> _alerts = [];
  List<String> _categories = ["Set Price Alert", "Price Alerts"];
  String _selectedCategory = "Set Price Alert";

  List<Alert> get alerts => _alerts;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;

  AlertViewModel() {
    _init();
  }

  void _init() {
    getAlertsStream();
  }

  Future<void> addAlert(Alert alert) async {
    await _firestoreRepository.addAlert(alert);
  }

  Future<void> deleteAlert(String alertId) async {
    await _firestoreRepository.deleteAlert(alertId);
  }

  void getAlertsStream() {
    _firestoreRepository.getAlertsStream().listen((alerts) {
      _alerts = alerts;
      notifyListeners();
    });
  }

  void onButtonPressed(String value, double price) {
    if (value == ".") {
      if (controller.text.isEmpty || controller.text.contains(".")) return;
    }

    if (value == "0" && controller.text == "0") return;
    if (controller.text.replaceAll(',', '').length >= 16) return;

    controller.text += value;
    controller.text = NumberFormatter.removeCommas(controller.text);
    controller.text = NumberFormatter.formatAlertPrice(controller.text);

    if (controller.text.isEmpty || double.parse(NumberFormatter.removeCommas(controller.text)) == 0
        || double.parse(NumberFormatter.removeCommas(controller.text)) == price) {
      isButtonEnabled = false;
    } else {
      isButtonEnabled = true;
    }
    notifyListeners();
  }

  void onDeletePressed(double price) {
    if (controller.text.isNotEmpty) {
      controller.text = controller.text.substring(0, controller.text.length - 1);
      controller.text = NumberFormatter.removeCommas(controller.text);
      controller.text = NumberFormatter.formatAlertPrice(controller.text);

      if (controller.text.isEmpty || double.parse(NumberFormatter.removeCommas(controller.text)) == 0
          || double.parse(NumberFormatter.removeCommas(controller.text)) == price) {
        isButtonEnabled = false;
      } else {
        isButtonEnabled = true;
      }

      notifyListeners();
    }
  }

  Future<bool> checkNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      PermissionStatus newStatus = await Permission.notification.request();
      return newStatus.isGranted;
    } else if (status.isPermanentlyDenied) {
      return false;
    }
    return false;
  }

  void openSettings() {
    openAppSettings();
  }

  void changeCategory(String category) {
    if(_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  String createdAt(DateTime date) {
    Duration difference = DateTime.now().difference(date);
    int daysAgo = difference.inDays;

    if (daysAgo == 0) {
      return "Created today";
    } else {
      return "Created ${daysAgo}d ago";
    }
  }


}