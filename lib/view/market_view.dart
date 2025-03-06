import 'package:cryptocurrency_exchange/tools/AppColors.dart';
import 'package:cryptocurrency_exchange/tools/AppIcons.dart';
import 'package:cryptocurrency_exchange/view/coindetailpage_view.dart';
import 'package:cryptocurrency_exchange/view_model/coindetailpage_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../model/coin.dart';
import '../view_model/market_view_model.dart';
import '../view_model/watchlist_view_model.dart';

class MarketView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.backgroundColor2,
      appBar: _buildAppBar(context),
      body: _buildBody(),
    );

  }

  PreferredSize _buildAppBar(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height * 0.05;
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Market",
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

  Widget _buildBody() {
    return Consumer<MarketViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (viewModel.coins.isEmpty) {
            return const Center(
              child: Text("No Coins Available"),
            );
          }

          return Column(
            children: [
              _buildContainer(context),
              _buildButtonRow(context),
              _buildCoinInformation(context),
              const SizedBox(height: 8,),
              _buildCoinList(context),
            ],
          );
        }
    );
  }

  Widget _buildContainer(BuildContext context) {
    MarketViewModel viewModel = Provider.of<MarketViewModel>(
      context,
      listen: true,
    );
    double marketCap = viewModel.marketCap;
    double volume24H = viewModel.volume24H;
    double dominance = viewModel.dominance;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 8, 10),
      child: Container(
        height: 60,
        width: double.infinity,
        padding: EdgeInsets.only(left: screenWidth * 0.03),
        decoration: BoxDecoration(
          color: AppColors.containerColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(flex: 10,child: _buildContainerMarketCap(viewModel, marketCap),),
            Flexible(flex: 12,child: _buildContainerVolume(viewModel, volume24H),),
            Flexible(flex: 13,child: _buildContainerDominance(viewModel, dominance),),
            //_buildContainerMarketCap(viewModel, marketCap),
            //_buildContainerVolume(viewModel, volume24H),
            //_buildContainerDominance(viewModel, dominance),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerMarketCap(MarketViewModel viewModel, double marketCap) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //SizedBox(width: 10,),
            Text(
              "Market Cap",
              style: TextStyle(fontSize: 16, color: AppColors.gray,),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //const SizedBox(width: 10,),
            Text(
              "\$${viewModel.formatMarketCap(marketCap)}",
              style: const TextStyle(
                fontSize: 22,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),

      ],
    );
  }

  Widget _buildContainerVolume(MarketViewModel viewModel, double volume24H) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Volume (24H)",
              style: TextStyle(fontSize: 16, color: AppColors.gray,),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "\$${viewModel.formatMarketCap(volume24H)}",
              style: const TextStyle(
                fontSize: 22,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContainerDominance(MarketViewModel viewModel, double dominance) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //SizedBox(width: 10,),
            Flexible(
              child: Text(
                "BTC Dominance",
                style: TextStyle(fontSize: 15, color: AppColors.gray,),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //const SizedBox(width: 10,),
            Text(
              "${dominance.toStringAsFixed(2)}%",
              style: const TextStyle(
                fontSize: 22,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),

      ],
    );
  }

  Widget _buildButtonRow(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 3, 20, 17),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _searchArea(context),
          SizedBox(width: screenWidth * 0.05),
          _sortButton(context),
        ],
      ),
    );
  }

  Widget _searchArea(BuildContext context) {
    MarketViewModel viewModel = Provider.of<MarketViewModel>(
      context,
      listen: true,
    );

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
        flex: 7,
        child: Container(
          height: screenHeight * 0.05,
          child: TextField(
            controller: viewModel.searchController,
            focusNode: viewModel.searchFocusNode,
            style: const TextStyle(color: AppColors.white,),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.white,
              ),
              hintText: "Search",
              hintStyle: const TextStyle(color: AppColors.gray),
              filled: true,
              fillColor: AppColors.containerColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              viewModel.filterCoins();
            },
          ),
        )
    );
  }

  Widget _sortButton(BuildContext context) {
    MarketViewModel viewModel = Provider.of<MarketViewModel>(
      context,
      listen: true,
    );

    return Expanded(
      flex: 3,
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: AppColors.containerColor,
                child: Container(
                  width: 400,
                  height: 305,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      OptionButton(context, viewModel.sortOptions[0]),
                      _buildDivider(),
                      OptionButton(context, viewModel.sortOptions[1]),
                      _buildDivider(),
                      OptionButton(context, viewModel.sortOptions[2]),
                      _buildDivider(),
                      OptionButton(context, viewModel.sortOptions[3]),
                      _buildDivider(),
                      OptionButton(context, viewModel.sortOptions[4]),
                    ],
                  ),
                ),
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.containerColor,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          "Sort by",
          style: TextStyle(
            color: AppColors.gray,
          ),
        ),
      ),
    );
  }

  Widget OptionButton(BuildContext context, String option) {
    MarketViewModel viewModel = Provider.of<MarketViewModel>(
      context,
      listen: true,
    );
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        minimumSize: const Size(double.infinity, 60),
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      onPressed: () {
        viewModel.setSortBy(option);
        viewModel.sortCoins();
        Navigator.of(context).pop();
      },
      child: Text(
        option,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.green,
        ),
      ),
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
    MarketViewModel viewModel = Provider.of<MarketViewModel>(
      context,
      listen: true,
    );

    double screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: ListView.builder(
        controller: viewModel.scrollController,
        itemCount: viewModel.filteredCoins.length + 1,
        itemBuilder: (context, index) {
          if (index == viewModel.filteredCoins.length) {
            return viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox();
          }

          final coin = viewModel.filteredCoins[index];
          return Column(
            children: [
              _buildDivider(),
              Container(
                height: screenHeight * 0.09,
                padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                child: _buildCoinListTile(context, coin, viewModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCoinListTile(BuildContext context, Coin coin, MarketViewModel viewModel) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1,),
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
      /*
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: CoinDetailPageViewModel(coin)),
              ChangeNotifierProvider(create: (context) => WatchlistViewModel()),
            ],
            child: CoinDetailPageView(coin: coin),
          ),
        );
      },
       */
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

  Widget _buildCoinPrice(MarketViewModel viewModel, Coin coin) {
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

  Widget _buildCoin24H(MarketViewModel viewModel, Coin coin) {
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

  Widget _buildCoinMarketCap(MarketViewModel viewModel, Coin coin) {
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



