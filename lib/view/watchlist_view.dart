import 'package:cryptocurrency_exchange/view_model/watchlist_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/coin.dart';
import '../tools/AppColors.dart';
import '../tools/AppIcons.dart';
import '../view_model/coindetailpage_view_model.dart';
import '../view_model/market_view_model.dart';
import 'coindetailpage_view.dart';

class WatchlistView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor2,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height * 0.05;
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Watchlist",
          style: TextStyle(
            fontSize: 36,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleTextStyle: TextStyle(),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<WatchlistViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.watchlist.isEmpty) {
            return const Center(
              child: Text("No Coins Available"),
            );
          }

          return Column(
            children: [
              _buildCoinInformation(context),
              const SizedBox(height: 8,),
              _buildCoinList(context),
            ],
          );
        }
    );

  }

  Widget _buildCoinInformation(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 25, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCoinInformationTitle(1, "Coin", TextAlign.center),
          _buildCoinInformationTitle(2, "MarketCap", TextAlign.end),
          _buildCoinInformationTitle(2, "Price", TextAlign.end),
          _buildCoinInformationTitle(2, "24H", TextAlign.end),
        ],
      ),
    );
  }

  Expanded _buildCoinInformationTitle(int flex, String text, TextAlign textAlign) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: textAlign,
        style: const TextStyle(
          color: AppColors.gray,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCoinList(BuildContext context) {
    WatchlistViewModel viewModel = Provider.of<WatchlistViewModel>(
      context,
      listen: true,
    );

    double screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: ListView.builder(
        itemCount: viewModel.watchlist.length + 1,
        itemBuilder: (context, index) {
          if (index == viewModel.watchlist.length) {
            return viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox();
          }

          final coin = viewModel.watchlist[index];
          return Column(
            children: [
              _buildDivider(),
              Container(
                height: screenHeight * 0.09,
                padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                child: _buildCoinListTile(context, coin, viewModel),
              ),
              viewModel.watchlist[index] == viewModel.watchlist[viewModel.watchlist.length-1]
                  ? _buildDivider()
                  : const SizedBox(height: 0, width: 0,),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCoinListTile(BuildContext context, Coin coin, WatchlistViewModel viewModel) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 1,),
      tileColor: Colors.transparent,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCoinLogoAndSymbol(coin),
          _buildCoinMarketCap(viewModel, coin),
          _buildCoinPrice(viewModel, coin),
          _buildCoin24H(viewModel, coin),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          _buildCoinDetailPage(context, coin),
        );
      },
    );
  }

  PageRouteBuilder<dynamic> _buildCoinDetailPage(BuildContext context, Coin coin) {
    MarketViewModel viewModel = Provider.of<MarketViewModel>(
      context,
      listen: false,
    );
    double marketCap = viewModel.marketCap;

    return PageRouteBuilder(
      opaque: true,
      pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
        backgroundColor: Colors.black,
        body: ChangeNotifierProvider.value(
          value: CoinDetailPageViewModel(coin),
          child: CoinDetailPageView(coin: coin, marketCap: marketCap,),
        ),
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  Widget _buildCoinLogoAndSymbol(Coin coin) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(coin.imageUrl, width: 30),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              coin.symbol.toUpperCase(),
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
              ),
              //maxLines: 1,
              //softWrap: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPrice(WatchlistViewModel viewModel, Coin coin) {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "\$${viewModel.formatPrice(coin.currentPrice)}",
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ]
      ),
    );
  }

  Widget _buildCoin24H(WatchlistViewModel viewModel, Coin coin) {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          viewModel.isHigherThan0(coin.priceChangePercentage24H)
              ? AppIcons.triangleUp
              : AppIcons.triangleDown,
          SizedBox(width: 4,),
          Text(
            "${coin.priceChangePercentage24H.toStringAsFixed(2)}\%",
            textAlign: TextAlign.end,
            style: TextStyle(
              color: viewModel.isHigherThan0(coin.priceChangePercentage24H)
                  ? AppColors.green
                  : AppColors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinMarketCap(WatchlistViewModel viewModel, Coin coin) {
    return Expanded(
      flex: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "\$${viewModel.formatMarketCap(coin.marketCap)}",
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }

  Divider _buildDivider() {
    return const Divider(
      color: AppColors.dividerColor,
      height: 1,
      thickness: 2,
      indent: 0,
      endIndent: 0,
    );
  }

}