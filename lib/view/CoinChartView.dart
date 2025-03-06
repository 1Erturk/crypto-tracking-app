import 'dart:typed_data';

import 'package:cryptocurrency_exchange/tools/NumberFormatter.dart';
import 'package:cryptocurrency_exchange/view_model/coindetailpage_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tools/AppColors.dart';
import '../view_model/CoinChartViewModel.dart';

class CoinChartView extends StatelessWidget {
  //final String coinId;

  //CoinChartView({required this.coinId});
  CoinChartView();

  @override
  Widget build(BuildContext context) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: false,
    );

    if (viewModel.isLine) {
      return _buildLineChartContainer(context);
    } else {
      return _buildBarChartContainer(context);
    }
  }

  Widget _buildLineChartContainer(BuildContext context) {
    CoinChartViewModel viewModel = Provider.of<CoinChartViewModel>(
      context,
      listen: false,
    );
    CoinDetailPageViewModel coinDetailPageViewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: false,
    );

    return Container(
      height: 200,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: FutureBuilder<List<FlSpot>>(
        future: coinDetailPageViewModel.selectedTime == "1D" ? viewModel.chartData1d
            : coinDetailPageViewModel.selectedTime == "1W" ? viewModel.chartData7d
            : coinDetailPageViewModel.selectedTime == "1M" ? viewModel.chartData30d
            : viewModel.chartData1y,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Veri yüklenirken hata oluştu: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<FlSpot> spots = snapshot.data!;

            return _buildLineChartData(context, spots);

          } else {
            return Center(child: Text('No data available', style: TextStyle(color: Colors.white60),));
          }
        },
      ),
    );
  }

  Widget _buildLineChartData(BuildContext context, List<FlSpot> spots) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: false,
    );

    double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return LineChart(
      LineChartData(
        gridData: _buildLineChartGridData(maxY, minY),
        titlesData: _buildLineChartTitlesData(maxY, minY),
        borderData: FlBorderData(show: false,),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: viewModel.selectedTime == "1D" ? viewModel.coin.priceChangePercentage24H > 0 ? AppColors.green : AppColors.red
                : viewModel.selectedTime == "1W" ? viewModel.priceChangePercentage7d > 0 ? AppColors.green : AppColors.red
                : viewModel.selectedTime == "1M" ? viewModel.priceChangePercentage30d > 0 ? AppColors.green : AppColors.red
                : viewModel.priceChangePercentage1y > 0 ? AppColors.green : AppColors.red,
            barWidth: 2,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: viewModel.selectedTime == "1D" ? viewModel.coin.priceChangePercentage24H > 0 ? [AppColors.green.withOpacity(0.30), AppColors.green.withOpacity(0)] : [AppColors.red.withOpacity(0.30), AppColors.red.withOpacity(0)]
                    : viewModel.selectedTime == "1W" ? viewModel.priceChangePercentage7d > 0 ? [AppColors.green.withOpacity(0.30), AppColors.green.withOpacity(0)] : [AppColors.red.withOpacity(0.30), AppColors.red.withOpacity(0)]
                    : viewModel.selectedTime == "1M" ? viewModel.priceChangePercentage30d > 0 ? [AppColors.green.withOpacity(0.30), AppColors.green.withOpacity(0)] : [AppColors.red.withOpacity(0.30), AppColors.red.withOpacity(0)]
                    : viewModel.priceChangePercentage1y > 0 ? [AppColors.green.withOpacity(0.30), AppColors.green.withOpacity(0)] : [AppColors.red.withOpacity(0.30), AppColors.red.withOpacity(0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: const FlDotData(
              show: false,
            ),
          ),
        ],
        lineTouchData: _buildLineTouchData(),
        maxY: maxY * 1,
        minY: minY * 1,
      ),
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: false,
        tooltipRoundedRadius: 8, // Tooltip'in köşe yuvarlaklığı
        tooltipPadding: const EdgeInsets.all(6), // Tooltip iç kenar boşluğu
        tooltipMargin: 30, // Tooltip ile grafik arasındaki mesafe
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            const textStyle = TextStyle(
              color: Colors.white, // Yazı rengi
              fontWeight: FontWeight.bold,
              fontSize: 12, // Yazı boyutu
            );
            return LineTooltipItem(
              'Time: ${NumberFormatter.formatDate(touchedSpot.x.toInt())}\nPrice: \$${NumberFormatter.formatPrice(touchedSpot.y)}',
              textStyle,
            );
          }).toList();
        },
      ),
      handleBuiltInTouches: true, // Dahili dokunma olaylarını etkinleştir
    );
  }

  FlGridData _buildLineChartGridData(double maxY, double minY) {
    return const FlGridData(show: false,);
  }

  FlTitlesData _buildLineChartTitlesData(double maxY, double minY) {
    return const FlTitlesData(
      bottomTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false,),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false,),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false,),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false,),
      ),
    );
  }

  Widget _buildBarChartContainer(BuildContext context) {
    CoinChartViewModel viewModel = Provider.of<CoinChartViewModel>(
      context,
      listen: false,
    );
    CoinDetailPageViewModel coinDetailPageViewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: false,
    );

    double width = MediaQuery.of(context).size.width;
    double candlestickWidth = width/95;


    return Container(
      height: 250,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: FutureBuilder<List<FlSpot>>(
        future: coinDetailPageViewModel.selectedTime == "1D" ? viewModel.chartData1d
            : coinDetailPageViewModel.selectedTime == "1W" ? viewModel.chartData7d
            : coinDetailPageViewModel.selectedTime == "1M" ? viewModel.chartData30d
            : viewModel.chartData1y,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Veri yüklenirken hata oluştu: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<FlSpot> spots = snapshot.data!;

            double totalWidth = spots.length * candlestickWidth;
            double chartWidth = totalWidth < width ? width : totalWidth;

            totalWidth >= width
                ? viewModel.maxScrollExtent = chartWidth - (width+25)
                : viewModel.maxScrollExtent = chartWidth - (width) ;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: viewModel.scrollController,
              physics: const ClampingScrollPhysics(),
              child: Container(
                width: chartWidth,
                child: _buildBarChart(context, spots, viewModel),
              ),
            );

          } else {
            return Center(child: Text('No data available', style: TextStyle(color: Colors.white60),));
          }
        },
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, List<FlSpot> spots, CoinChartViewModel viewModel) {
    double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    int desiredLines = 6;
    double interval = (maxY - minY) / desiredLines;

    return BarChart(
      BarChartData(
        gridData: _buildBarChartGridData(interval),
        titlesData: _buildBarChartTitlesData(interval),
        borderData: FlBorderData(show: false),
        barGroups: _getBarGroups(context, spots),
        barTouchData: _buildBarTouchData(spots, context, viewModel),
      ),
    );
  }

  FlGridData _buildBarChartGridData(double interval) {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      drawHorizontalLine: true,
      horizontalInterval: interval,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
    );
  }

  FlTitlesData _buildBarChartTitlesData(double interval) {
    return FlTitlesData(
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          maxIncluded: false,
          minIncluded: false,
          interval: interval,
          reservedSize: 50,
          getTitlesWidget: (value, titleMeta) {
            return Transform.translate(
              offset: const Offset(-50, 0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(

                  NumberFormatter.formatPrice2(value),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        ),
      ),
      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  BarTouchData _buildBarTouchData(List<FlSpot> spots, BuildContext context, CoinChartViewModel viewModel) {
    return BarTouchData(
      enabled: true,
      allowTouchBarBackDraw: true,
      touchTooltipData: BarTouchTooltipData(
        direction: TooltipDirection.top,
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        tooltipRoundedRadius: 10, // Tooltip'in köşe yuvarlaklığı
        tooltipPadding: const EdgeInsets.all(6), // Tooltip iç kenar boşluğu
        tooltipMargin: 250, // Tooltip ile grafik arasındaki mesafe
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          const textStyle = TextStyle(
            color: Colors.white, // Yazı rengi
            fontWeight: FontWeight.bold,
            fontSize: 12, // Yazı boyutu
          );

          double xValue = spots[groupIndex].x;

          return BarTooltipItem(
            'Time: ${NumberFormatter.formatDate(xValue.toInt())}\nPrice: \$${NumberFormatter.formatPrice(rod.toY)}',
            textStyle,
          );
        },
      ),
      handleBuiltInTouches: true, // Dahili dokunma olaylarını etkinleştir
    );
  }

  List<BarChartGroupData> _getBarGroups(BuildContext context, List<FlSpot> spots) {
    List<BarChartGroupData> bars = [];
    double width = MediaQuery.of(context).size.width;

    for (var i = 0; i < spots.length - 1; i++) {
      var currentData = spots[i];
      var nextData = spots[i+1];

      double open = currentData.y; // Açılış fiyatı
      double close = nextData.y;  // Kapanış fiyatı
      double high = currentData.y * 1;  // En yüksek fiyat (örnek: %5 daha fazla)
      double low = currentData.y * 1;  // En düşük fiyat (örnek: %5 daha az)

      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: high, // En yüksek değer
              fromY: low, // En düşük değer
              width: width/500, // Çubuğun genişliği
              color: close >= open
                  ? AppColors.green // Yeşil, artış
                  : AppColors.red, // Kırmızı, düşüş
            ),
            BarChartRodData(
              toY: open, // Açılış değeri
              fromY: close, // Kapanış değeri
              width: width/100, // Çubuğun genişliği
              color: close >= open
                  ? AppColors.green // Yeşil, artış
                  : AppColors.red, // Kırmızı, düşüş
            ),
          ],
        ),
      );
    }
    return bars;
  }

}


/*
import 'dart:typed_data';
import 'package:cryptocurrency_exchange/tools/NumberFormatter.dart';
import 'package:cryptocurrency_exchange/view_model/coindetailpage_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../tools/AppColors.dart';
import '../view_model/CoinChartViewModel.dart';

class CoinChartView extends StatelessWidget {
  //final String coinId;

  //CoinChartView({required this.coinId});
  CoinChartView();

  @override
  Widget build(BuildContext context) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: false,
    );

    if (viewModel.isLine) {
      return _buildLineChartContainer(context);
    } else {
      return _buildBarChartContainer(context);
    }
  }

  Widget _buildLineChartContainer(BuildContext context) {
    CoinChartViewModel viewModel = Provider.of<CoinChartViewModel>(
      context,
      listen: false,
    );
    CoinDetailPageViewModel coinDetailPageViewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: false,
    );

    return Container(
      height: 200,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: FutureBuilder<List<FlSpot>>(
        future: coinDetailPageViewModel.selectedTime == "1D" ? viewModel.chartData1d
            : coinDetailPageViewModel.selectedTime == "1W" ? viewModel.chartData7d
            : coinDetailPageViewModel.selectedTime == "1M" ? viewModel.chartData30d
            : viewModel.chartData1y,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Veri yüklenirken hata oluştu: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<FlSpot> spots = snapshot.data!;

            return _buildLineChartData(context, spots);

          } else {
            return Center(child: Text('No data available', style: TextStyle(color: Colors.white60),));
          }
        },
      ),
    );
  }

  Widget _buildLineChartData(BuildContext context, List<FlSpot> spots) {
    CoinDetailPageViewModel viewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: false,
    );

    double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    return LineChart(
      LineChartData(
        gridData: _buildGridData(maxY, minY),
        titlesData: _buildTitlesData(maxY, minY),
        borderData: FlBorderData(show: false,),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: viewModel.selectedTime == "1D" ? viewModel.coin.priceChangePercentage24H > 0 ? AppColors.green : AppColors.red
                : viewModel.selectedTime == "1W" ? viewModel.priceChangePercentage7d > 0 ? AppColors.green : AppColors.red
                : viewModel.selectedTime == "1M" ? viewModel.priceChangePercentage30d > 0 ? AppColors.green : AppColors.red
                : viewModel.priceChangePercentage1y > 0 ? AppColors.green : AppColors.red,
            barWidth: 2,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: viewModel.selectedTime == "1D" ? viewModel.coin.priceChangePercentage24H > 0 ? [AppColors.green.withOpacity(0.30), AppColors.green.withOpacity(0)] : [AppColors.red.withOpacity(0.30), AppColors.red.withOpacity(0)]
                    : viewModel.selectedTime == "1W" ? viewModel.priceChangePercentage7d > 0 ? [AppColors.green.withOpacity(0.30), AppColors.green.withOpacity(0)] : [AppColors.red.withOpacity(0.30), AppColors.red.withOpacity(0)]
                    : viewModel.selectedTime == "1M" ? viewModel.priceChangePercentage30d > 0 ? [AppColors.green.withOpacity(0.30), AppColors.green.withOpacity(0)] : [AppColors.red.withOpacity(0.30), AppColors.red.withOpacity(0)]
                    : viewModel.priceChangePercentage1y > 0 ? [AppColors.green.withOpacity(0.30), AppColors.green.withOpacity(0)] : [AppColors.red.withOpacity(0.30), AppColors.red.withOpacity(0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dotData: const FlDotData(
              show: false,
            ),
          ),
        ],
        lineTouchData: _buildLineTouchData(),
        maxY: maxY * 1,
        minY: minY * 1,
      ),
    );
  }

  LineTouchData _buildLineTouchData() {
    return LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: false,
        tooltipRoundedRadius: 8, // Tooltip'in köşe yuvarlaklığı
        tooltipPadding: const EdgeInsets.all(6), // Tooltip iç kenar boşluğu
        tooltipMargin: 16, // Tooltip ile grafik arasındaki mesafe
        getTooltipItems: (List<LineBarSpot> touchedSpots) {
          return touchedSpots.map((LineBarSpot touchedSpot) {
            const textStyle = TextStyle(
              color: Colors.white, // Yazı rengi
              fontWeight: FontWeight.bold,
              fontSize: 12, // Yazı boyutu
            );
            return LineTooltipItem(
              'Time: ${NumberFormatter.formatDate(touchedSpot.x.toInt())}\nPrice: \$${NumberFormatter.formatPrice(touchedSpot.y)}',
              textStyle,
            );
          }).toList();
        },
      ),
      handleBuiltInTouches: true, // Dahili dokunma olaylarını etkinleştir
    );
  }

  FlGridData _buildGridData(double maxY, double minY) {
    return const FlGridData(show: false,);
  }

  FlTitlesData _buildTitlesData(double maxY, double minY) {
    return const FlTitlesData(
      bottomTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false,),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false,),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false,),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false,),
      ),
    );
  }

  Widget _buildBarChartContainer(BuildContext context) {
    CoinChartViewModel viewModel = Provider.of<CoinChartViewModel>(
      context,
      listen: false,
    );
    CoinDetailPageViewModel coinDetailPageViewModel = Provider.of<CoinDetailPageViewModel>(
      context,
      listen: false,
    );

    double width = MediaQuery.of(context).size.width;
    double candlestickWidth = width/95;


    return Container(
      height: 250,
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: FutureBuilder<List<FlSpot>>(
        future: coinDetailPageViewModel.selectedTime == "1D" ? viewModel.chartData1d
            : coinDetailPageViewModel.selectedTime == "1W" ? viewModel.chartData7d
            : coinDetailPageViewModel.selectedTime == "1M" ? viewModel.chartData30d
            : viewModel.chartData1y,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Veri yüklenirken hata oluştu: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<FlSpot> spots = snapshot.data!;

            double totalWidth = spots.length * candlestickWidth;
            double chartWidth = totalWidth < width ? width : totalWidth;

            totalWidth >= width
                ? viewModel.maxScrollExtent = chartWidth - (width+25)
                : viewModel.maxScrollExtent = chartWidth - (width) ;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: viewModel.scrollController,
              physics: const ClampingScrollPhysics(),
              child: Container(
                width: chartWidth,
                child: _buildBarChart(context, spots),
              ),
            );

          } else {
            return Center(child: Text('No data available', style: TextStyle(color: Colors.white60),));
          }
        },
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, List<FlSpot> spots) {
    double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    int desiredLines = 6;
    double interval = (maxY - minY) / desiredLines;

    return BarChart(
      BarChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          drawHorizontalLine: true,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.white12,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              maxIncluded: false,
              minIncluded: false,
              interval: interval,
              reservedSize: 50,
              getTitlesWidget: (value, titleMeta) {
                return Transform.translate(
                  offset: const Offset(-50, 0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(

                      NumberFormatter.formatPrice2(value),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: _getBarGroups(context, spots),
        barTouchData: _buildBarTouchData(spots, context),
      ),
    );
  }

  BarTouchData _buildBarTouchData(List<FlSpot> spots, BuildContext context) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        fitInsideHorizontally: true,
        fitInsideVertically: true,
        tooltipRoundedRadius: 10, // Tooltip'in köşe yuvarlaklığı
        tooltipPadding: const EdgeInsets.all(6), // Tooltip iç kenar boşluğu
        tooltipMargin: 30, // Tooltip ile grafik arasındaki mesafe
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          const textStyle = TextStyle(
            color: Colors.white, // Yazı rengi
            fontWeight: FontWeight.bold,
            fontSize: 12, // Yazı boyutu
          );

          double xValue = spots[groupIndex].x;

          return BarTooltipItem(
            'Time: ${NumberFormatter.formatDate(xValue.toInt())}\nPrice: \$${NumberFormatter.formatPrice(rod.toY)}',
            textStyle,
          );
        },

      ),
      handleBuiltInTouches: true, // Dahili dokunma olaylarını etkinleştir
    );
  }

  List<BarChartGroupData> _getBarGroups(BuildContext context, List<FlSpot> spots) {
    List<BarChartGroupData> bars = [];
    double width = MediaQuery.of(context).size.width;

    for (var i = 0; i < spots.length - 1; i++) {
      var currentData = spots[i];
      var nextData = spots[i+1];

      double open = currentData.y; // Açılış fiyatı
      double close = nextData.y;  // Kapanış fiyatı
      double high = currentData.y * 1;  // En yüksek fiyat (örnek: %5 daha fazla)
      double low = currentData.y * 1;  // En düşük fiyat (örnek: %5 daha az)

      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: high, // En yüksek değer
              fromY: low, // En düşük değer
              width: width/500, // Çubuğun genişliği
              color: close >= open
                  ? AppColors.green // Yeşil, artış
                  : AppColors.red, // Kırmızı, düşüş
            ),
            BarChartRodData(
              toY: open, // Açılış değeri
              fromY: close, // Kapanış değeri
              width: width/100, // Çubuğun genişliği
              color: close >= open
                  ? AppColors.green // Yeşil, artış
                  : AppColors.red, // Kırmızı, düşüş
            ),
          ],
        ),
      );
    }
    return bars;
  }

}
*/