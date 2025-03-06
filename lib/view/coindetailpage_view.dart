import 'package:cryptocurrency_exchange/tools/AppIcons.dart';
import 'package:cryptocurrency_exchange/view/alert_view.dart';
import 'package:cryptocurrency_exchange/view/profile_web_view.dart';
import 'package:cryptocurrency_exchange/view_model/CoinChartViewModel.dart';
import 'package:cryptocurrency_exchange/view_model/alert_view_model.dart';
import 'package:cryptocurrency_exchange/view_model/coindetailpage_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../model/coin.dart';
import '../tools/AppColors.dart';
import '../tools/NumberFormatter.dart';
import 'CoinChartView.dart';

class CoinDetailPageView extends StatelessWidget {
  final Coin coin;
  final double marketCap;
  const CoinDetailPageView({Key? key, required this.coin, required this.marketCap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor2,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: _buildBody(context),
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    double appBarHeight = MediaQuery.of(context).size.height * 0.05;
    return PreferredSize(
      preferredSize: Size.fromHeight(appBarHeight),
      child: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: Colors.transparent,

        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: _buildTitle(),
        ),

        actions: [
          _buildIcon(context),
        ],

      ),
    );
  }

  Widget _buildTitle() {
    return Row(
      children: [
        _buildMarketCapRank(),
        const SizedBox(width: 50,),
        Image.network(coin.imageUrl, width: 40, height: 40,),
        const SizedBox(width: 8,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              coin.symbol.toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              coin.name,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.gray,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarketCapRank() {
    return Text(
      "\#${coin.marketCapRank}",
      style: const TextStyle(
        color: AppColors.gray,
        fontWeight: FontWeight.normal,
        fontSize: 35,
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: true,
    );
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: IconButton(
        onPressed: () {
          if (viewModel.isFavorite == true) {
            viewModel.deleteFavoriteCoin(context);
          } else {
            viewModel.addFavoriteCoin(context);
          }
        },
        icon: viewModel.isFavorite == true ? Image.asset("assets/icons/favorite2.png", width: 35, height: 35, color: AppColors.red,)
            : viewModel.isFavorite == false ? Image.asset("assets/icons/favorite2.png", width: 35, height: 35, color: AppColors.gray,)
            : CircularProgressIndicator(),

      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildDivider(),
        _buildPrice(context),

        const SizedBox(height: 25,),
        _buildIconButton(context),
        const SizedBox(height: 5,),
        ChangeNotifierProvider(
          create: (context) => CoinChartViewModel(coin.id),
          child: CoinChartView(),
        ),
        const SizedBox(height: 10,),
        _buildIntervalButtons(context),
        const SizedBox(height: 25,),

        _buildCoinStatisticsTitle(),
        _buildCoinStatistics(context),
        const SizedBox(height: 25,),
        _buildDivider(),
        _buildProfileTitle(),
        _buildProfile(context),
        const SizedBox(height: 25,),
        _buildDivider(),
        _buildCoinDescriptionTitle(),
        _buildCoinDescription(context),
        _buildDivider(),
        _buildAvailableMarketsTitle(),
        const SizedBox(height: 10,),
        _buildAvailableMarkets(context),
        const SizedBox(height: 25,),
      ],
    );
  }


  Widget _buildPrice(BuildContext context) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: true,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 25,),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: Text(
                  "\$${NumberFormatter.formatPrice(coin.currentPrice)}",
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildAlertButton(context),
            ],
          ),
          const SizedBox(height: 2,),
          _buildPriceChange(viewModel),
        ],
      ),
    );
  }

  Widget _buildAlertButton(BuildContext context) {
    return Positioned(
      right: 25,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray, width: 1.25,),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: AppIcons.notification,
          onPressed: () {
            /*
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: AppColors.containerColor,
                  child: ChangeNotifierProvider(
                    create: (_) => AlertViewModel(),
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: MediaQuery.of(context).size.width*0.9,
                        height: MediaQuery.of(context).size.height*0.9,
                        child: AlertView(
                          coinImage: Image.network(coin.imageUrl, width: 40, height: 40,),
                          coinSymbol: coin.symbol.toUpperCase(),
                          coinPrice: coin.currentPrice,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
             */
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return Scaffold(
                    backgroundColor: AppColors.containerColor,
                    appBar: _buildAlertButtonAppBar(),
                    body: ChangeNotifierProvider(
                      create: (_) => AlertViewModel(),
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: AlertView(
                            coinId: coin.id,
                            coinImage: coin.imageUrl,
                            coinSymbol: coin.symbol.toUpperCase(),
                            coinPrice: coin.currentPrice,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );

          },
        ),
      ) ,
    );
  }

  AppBar _buildAlertButtonAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.white),
      title: Container(
        child: _buildAlertButtonTitle(),
      ),
    );
  }

  Widget _buildAlertButtonTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 95,),
        Image.network(coin.imageUrl, width: 40, height: 40,),
        const SizedBox(width: 8,),
        Text(
          coin.symbol.toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceChange(CoinDetailPageViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: viewModel.selectedTime == "1D" ? _buildPriceChangeText(coin.priceChangePercentage24H)
          : viewModel.selectedTime == "1W" ? _buildPriceChangeText(viewModel.priceChangePercentage7d)
          : viewModel.selectedTime == "1M" ? _buildPriceChangeText(viewModel.priceChangePercentage30d)
          : _buildPriceChangeText(viewModel.priceChangePercentage1y),
    );
  }

  List<Widget> _buildPriceChangeText(double priceChangePercentage) {
    return [
      priceChangePercentage >= 0 ? AppIcons.triangleUp : AppIcons.triangleDown,
      const SizedBox(width: 4,),
      Text(
        "${priceChangePercentage.toStringAsFixed(2)}%",
        style: TextStyle(
          color: priceChangePercentage < 0
              ? AppColors.red
              : AppColors.green,
          fontSize: 27,
          fontWeight: FontWeight.normal,
        ),
      ),
    ];
  }

  Widget _buildDivider() {
    return const Divider(
      color: AppColors.dividerColor,
      thickness: 3,
      height: 5,
    );
  }

  Widget _buildDividerGray() {
    return const Divider(
      color: Colors.black87,
      thickness: 1,
      height: 5,
    );
  }

  Widget _buildIconButton(BuildContext context) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: true,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,  // Butonu sağa hizalar
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.containerColor.withOpacity(0.75),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(0),
            child: IconButton(
              onPressed: () {
                viewModel.changeChart();
              },
              icon: viewModel.isLine == true
                  ? Image.asset("assets/icons/candlestickchart.png", width: 15, height: 15, color: AppColors.gray,)
                  : viewModel.isLine == false
                  ? Image.asset("assets/icons/linechart.png", width: 15, height: 15, color: AppColors.gray,)
                  : CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIntervalButtons(BuildContext context) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: true,
    );
    List<String> intervals = ["1D", "1W", "1M", "1Y"];

    double buttonWidth = MediaQuery.of(context).size.width / (intervals.length + 0.5);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: intervals.map((interval) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Container(
            constraints: BoxConstraints(maxWidth: buttonWidth,),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.containerColor.withOpacity(0.75),
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
              ),
              onPressed: () {
                viewModel.changeTimeInterval(interval);
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  interval,
                  style: TextStyle(
                    color: viewModel.selectedTime == interval
                        ? AppColors.green
                        : AppColors.gray,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );

  }

  Widget _buildCoinStatisticsTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 35, top: 15),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Statistics",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCoinStatistics(BuildContext context) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: true,
    );
    double volume24H = ((coin.marketCap/viewModel.marketCap)*100);
    String volume24HFormatted = volume24H.toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
      child: Container(
        height: 360,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.containerColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Flex(
          direction: Axis.vertical,
          children: [
            _buildCoinStatisticRow("Rank", "${coin.marketCapRank}"),
            _buildDividerGray(),
            _buildCoinStatisticRow("Market Cap", "\$${NumberFormatter.formatMarketCap(coin.marketCap)}"),
            _buildDividerGray(),
            _buildCoinStatisticRow("Volume 24H", "\$${NumberFormatter.formatMarketCap(coin.totalVolume)}"),
            _buildDividerGray(),
            _buildCoinStatisticRow("Circulating Supply", "${NumberFormatter.formatSupply(coin.circulatingSupply)}"),
            _buildDividerGray(),
            _buildCoinStatisticRow("Total Supply", "${NumberFormatter.formatSupply(coin.totalSupply)}"),
            _buildDividerGray(),
            _buildCoinStatisticRow("Max Supply", "${NumberFormatter.formatSupply(coin.maxSupply)}"),
            _buildDividerGray(),
            _buildCoinStatisticRow("Market Dominance", "${volume24HFormatted}%"),
            _buildDividerGray(),
            _buildCoinStatisticRow("All Time High (ATH)", "\$${NumberFormatter.formatPrice(coin.ath)}"),
            _buildDividerGray(),
            _buildCoinStatisticRow("All Time Low (ATL)", "\$${NumberFormatter.formatPrice(coin.atl)}"),
            _buildDividerGray(),
            coin.priceChangePercentage24H<0
                ? _buildCoinStatisticRow("Change 24H", "${coin.priceChangePercentage24H.toStringAsFixed(2)}%", color:AppColors.red)
                : _buildCoinStatisticRow("Change 24H", "${coin.priceChangePercentage24H.toStringAsFixed(2)}%", color:AppColors.green),
          ],
        ),
      ),
    );

  }

  Widget _buildCoinStatisticRow(String text1, String text2, {Color color = AppColors.white}) {
    Widget? icon;
    if (text1 == "Change 24H") {
      icon = color == AppColors.green ? AppIcons.triangleUp
          : color == AppColors.red ? AppIcons.triangleDown : null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text1,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          Row(
            children: [
              if(icon!=null) icon,
              const SizedBox(width: 4,),
              Text(
                text2,
                style: TextStyle(
                  fontSize: 16,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildProfileTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 25, top: 25),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Profile",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(BuildContext context) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: true,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildProfileRow(context, "Website:", viewModel.website),
          _buildProfileRow(context, "Whitepaper:", viewModel.whitepaper),
          _buildProfileRow(context, "Community:", viewModel.community),
          _buildProfileRow(context, "Genesis Date:", viewModel.genesisDate),
        ],
      ),
    );
  }

  Widget _buildProfileRow(BuildContext context, String text1, String text2) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            text1,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: text1 == "Genesis Date:" ? null : () => _launchUrl(context, text1, text2),
            child: Text(
              text2,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.white,
                decoration: text1 == "Genesis Date:" ? null : TextDecoration.underline,
                decorationColor: AppColors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  void _launchUrl(BuildContext context, String text1, String text2) async {
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileWebView(text1: text1,text2: text2),
      ),
    );

     */
  }

  Widget _buildCoinDescriptionTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 25, top: 25),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "ABOUT ${coin.name}",
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildCoinDescription(BuildContext context) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: true,
    );
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom:  25),
      child: Text(
        viewModel.description,
        style: const TextStyle(
          color: AppColors.gray,
        ),
      ),
    );
  }

  Widget _buildAvailableMarketsTitle() {
    return const Padding(
      padding: EdgeInsets.only(left: 25, top: 25),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Available Markets",
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }


  Widget _buildAvailableMarkets(BuildContext context) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: true,
    );
    if(viewModel.tickers.isEmpty) {
      return const Text(
        "No markets Available.",
        style: TextStyle(
          color: AppColors.gray,
        ),
      );
    }
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: viewModel.tickers.length,
        itemBuilder: (context, index) {
          final market = viewModel.tickers[index];
          return _buildAvailableMarketsCard(market);
        },
      ),
    );
  }

  Widget _buildAvailableMarketsCard(dynamic market) {
    return Card(
      color: AppColors.containerColor,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Market: ${market['market']['name']}",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Text(
                  market["trust_score"] == "green" ? "Trusted Market"
                      : market["trust_score"] == "red" ? "Untrusted Market" : "",
                  style: TextStyle(
                    color:  market["trust_score"] == "green" ? AppColors.green : AppColors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            market['base'].toString().length < 25 && market['target'].toString().length < 25
                ? textFormatter("Pair: ", "${market['base']}/${market['target']}")
                : textFormatter("Pair: ", " "),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                textFormatter("Price: ", "\$${NumberFormatter.formatPrice(market['last'])}"),
                textFormatter("Volume(24H): ", "\$${NumberFormatter.formatMarketCap(market['converted_volume']['usd'].toDouble())}"),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget textFormatter(String text1, String text2) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(color: AppColors.gray),
        children: [
          TextSpan(
            text: text1,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: text2,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }


}