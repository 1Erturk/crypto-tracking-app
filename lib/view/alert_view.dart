import 'package:cryptocurrency_exchange/tools/AppColors.dart';
import 'package:cryptocurrency_exchange/tools/AppIcons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../model/alert.dart';
import '../tools/NumberFormatter.dart';
import '../view_model/alert_view_model.dart';

class AlertView extends StatelessWidget {
  final String coinId;
  final String coinImage;
  final String coinSymbol;
  final double coinPrice;

  AlertView({required this.coinId, required this.coinImage, required this.coinSymbol, required this.coinPrice});

  @override
  Widget build(BuildContext context) {
    AlertViewModel viewModel = Provider.of<AlertViewModel>(
      context,
      listen: true,
    );
    return viewModel.selectedCategory == viewModel.categories[0]
        ? _buildSetPriceAlert(context, viewModel)
        : _buildPriceAlerts(context, viewModel);
  }

  Widget _buildSetPriceAlert(BuildContext context, AlertViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildButtons(context),
        _buildTextField(viewModel),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCurrentPrice(),
              _buildSetPriceAlertButton(context),
              _buildNumberPad(viewModel),
              _buildNumberPad2(viewModel),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    AlertViewModel viewModel = Provider.of<AlertViewModel>(
      context,
      listen: true,
    );

    double screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth = screenWidth / (viewModel.categories.length + 0.5);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: viewModel.categories.map((category) {
          bool isSelected = viewModel.selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: GestureDetector(
              onTap: () {
                viewModel.changeCategory(category);
              },
              child: Container(
                constraints: BoxConstraints(maxWidth: buttonWidth),
                padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05, vertical: 5),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.gray : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.gray,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextField(AlertViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(top: 64,),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("When price is", style: TextStyle(color: AppColors.gray, fontSize: 18),),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              controller: viewModel.controller,
              keyboardType: TextInputType.none,
              style: const TextStyle(overflow: TextOverflow.ellipsis, color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold,),
              decoration: const InputDecoration(
                filled: false,
                fillColor: Colors.transparent,
                border: InputBorder.none,
              ),
              enabled: false,
              textAlign: TextAlign.center,
              minLines: 1,
              maxLines: 2,
              textInputAction: TextInputAction.done,
            ),
          ),
          const Text("USD", style: TextStyle(color: AppColors.gray, fontSize: 18),),
        ],
      ),
    );
  }

  Widget _buildPriceAlerts(BuildContext context, AlertViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildButtons(context),
        const SizedBox(width: 24,),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildListView(context, viewModel),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context, AlertViewModel viewModel) {
    double screenHeight = MediaQuery.of(context).size.height;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: viewModel.alerts.length,
      itemBuilder: (context, index) {
        final alert = viewModel.alerts[index];

        return Card(
          color: Colors.white12,
          margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: screenHeight/200, horizontal: 6),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  alert.coinImage,
                  width: 30,
                  height: 30,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 2),
                Text(
                  alert.coinSymbol.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.white,),
                ),
              ],
            ),
            title: Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        alert.above == true
                            ? "Above:"
                            : "Below:",
                        style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.normal),
                      ),
                      Text(
                        "\$${NumberFormatter.formatPrice2(alert.targetPrice)}",
                        style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),

                    ],
                  ),
                  /*
                    Column(
                      children: [
                        const Text(
                          "Created at:",
                          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.normal),
                        ),
                        Text(
                          viewModel.createdAt(alert.createdAt),
                          style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                     */
                ],
              ),
            ),
            trailing: IconButton(
              icon: AppIcons.delete,
              onPressed: () {
                viewModel.deleteAlert(alert.id!);
              },
            ),
          ),

        );
      },
    );
  }

  Widget _buildCurrentPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Current Price is \$ ${NumberFormatter.formatPrice(coinPrice)}",
          style: const TextStyle(color: AppColors.gray, fontSize: 18,),
        ),
      ],
    );
  }

  Widget _buildSetPriceAlertButton(BuildContext context) {
    AlertViewModel viewModel = Provider.of<AlertViewModel>(
      context,
      listen: false,
    );

    return SizedBox(
      width: MediaQuery.of(context).size.width*0.8,
      height: MediaQuery.of(context).size.height*0.05,
      child: IgnorePointer(
        ignoring: !viewModel.isButtonEnabled,
        child: ElevatedButton(
          onPressed: () async {
            bool hasPermission = await viewModel.checkNotificationPermission();
            if (!hasPermission || viewModel.alerts.length >= 3) {
              if (!hasPermission) {
                _showNotificationDialog(viewModel, context);
              } else {
                _showMaxAlertsDialog(viewModel, context);
              }
            } else {
              String alertPrice = viewModel.controller.text;
              alertPrice = NumberFormatter.removeCommas(alertPrice);
              double alertPriceDouble = double.parse(alertPrice);
              if (alertPriceDouble > coinPrice) {
                Alert alert = Alert(true, coinId, coinImage.toString(), coinSymbol, alertPriceDouble);
                viewModel.addAlert(alert);
                viewModel.controller.text = "";
                viewModel.isButtonEnabled = false;
              } else if (alertPriceDouble < coinPrice) {
                Alert alert = Alert(false, coinId, coinImage.toString(), coinSymbol, alertPriceDouble);
                viewModel.addAlert(alert);
                viewModel.controller.text = "";
                viewModel.isButtonEnabled = false;
              } else {

              }
              //Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: viewModel.isButtonEnabled
                ? AppColors.turquoise
                : AppColors.gray,
            elevation: 0,
          ),
          child: const Text(
            "Set Price Alert", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showNotificationDialog(AlertViewModel viewModel, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.containerColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          title: const Text("Enable Notifications"),
          content: const Text("Please enable notifications in your App's settings to receive alerts."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("CANCEL", style: TextStyle(color: AppColors.turquoise,),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                viewModel.openSettings(); // Kullanıcıyı ayarlara yönlendir
              },
              child: const Text("OPEN SETTINGS", style: TextStyle(color: AppColors.turquoise,),),
            ),
          ],
        );
      },
    );
  }

  void _showMaxAlertsDialog(AlertViewModel viewModel, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.containerColor,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          title: const Text("Max Alerts Reached"),
          content: const Text("You can only set up to 3 alerts. Please remove an existing alert to add a new one."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK", style: TextStyle(color: AppColors.turquoise, fontSize: 22),),
            ),

          ],
        );
      },
    );
  }

  Widget _buildNumberPad(AlertViewModel viewModel) {
    return Container(
      padding: EdgeInsets.zero,
      width: double.infinity,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 1.5,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              viewModel.onButtonPressed((index + 1).toString(), coinPrice);
            },
            child: Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontSize: 28, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNumberPad2(AlertViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildGestureDetector(const Text('.', style: TextStyle(fontSize: 28, color: Colors.white)), viewModel),
          _buildGestureDetector(const Text('0', style: TextStyle(fontSize: 28, color: Colors.white)), viewModel),
          _buildGestureDetector(const Icon(Icons.backspace, size: 24, color: Colors.white), viewModel),
        ],
      ),
    );
  }

  Widget _buildGestureDetector(Widget child, AlertViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        if (child is Icon) {
          viewModel.onDeletePressed(coinPrice);
        } else if (child is Text) {
          viewModel.onButtonPressed(child.data!, coinPrice);
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 60,
        height: 60,
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}