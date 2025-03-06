import 'package:cryptocurrency_exchange/tools/AppColors.dart';
import 'package:cryptocurrency_exchange/view_model/bottom_navigation_bar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BottomNavigationBarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildBottomNavigationBar();
  }

  Widget _buildBottomNavigationBar() {
    return Consumer<BottomNavigationBarViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          color: AppColors.containerColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(context, viewModel, "trend", "Market", 22, 2, 0),
              _buildNavItem(context, viewModel, "favorite2", "Watchlist", 20, 4, 1),
              _buildNavItem(context, viewModel, "article", "News", 24, 0, 2),
              _buildNavItem(context, viewModel, "menu", "Menu", 22, 2, 3),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(BuildContext context, BottomNavigationBarViewModel viewModel,
      String iconName, String label, double size, double sizedBoxHeight, int index) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          viewModel.onItemTapped(context, index);
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8,),
            Image.asset(
              "assets/icons/$iconName.png",
              width: size,
              height: size,
              color: viewModel.selectedItem == index ? Colors.green : AppColors.gray,
            ),
            SizedBox(height: sizedBoxHeight,),
            Text(
              label,
              style: TextStyle(
                color: viewModel.selectedItem == index ? Colors.green : AppColors.gray,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}




/*
class BottomNavigationBarView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return _buildBottomNavigationBar();
  }

  Widget _buildBottomNavigationBar() {
    return Consumer<BottomNavigationBarViewModel>(
      builder: (context, viewModel, child) {
        return BottomNavigationBar(
          backgroundColor: AppColors.containerColor,
          items: <BottomNavigationBarItem> [
            BottomNavigationBarItem(
              icon: _buildIcon("trend", 22, viewModel.selectedItem == 0),
              label: "Market",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon("favorite2", 20, viewModel.selectedItem == 1),
              label: "Watchlist",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon("article", 24, viewModel.selectedItem == 2),
              label: "News",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon("menu", 20, viewModel.selectedItem == 3),
              label: "Menu",
            ),
          ],
          currentIndex: viewModel.selectedItem,
          selectedItemColor: Colors.green,
          unselectedItemColor: AppColors.gray,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => viewModel.onItemTapped(context, index),
        );
      },
    );
  }

  Widget _buildIcon(String iconName, double height, bool selectedItem) {
    return Image.asset(
        "assets/icons/$iconName.png",
        width: height,
        height: height,
        color: selectedItem == true ? Colors.green : AppColors.gray,
    );
  }

}
 */




