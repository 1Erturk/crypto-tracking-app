import 'package:cryptocurrency_exchange/view/web_view.dart';
import 'package:cryptocurrency_exchange/view_model/news_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/news.dart';
import '../tools/AppColors.dart';

class NewsView extends StatelessWidget {
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
          "Last News",
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
    return Column(
      children: [
        _buildCattegoryButtons(context),
        Expanded(
          child: _buildNewsList(context),
        ),
      ],
    );
  }

  Widget _buildCattegoryButtons(BuildContext context) {
    NewsViewModel viewModel = Provider.of<NewsViewModel>(
      context,
      listen: true,
    );
    List<String> categories = ["Blockchain", "Finance", "Technology", "Economy"];

    double buttonWidth = MediaQuery.of(context).size.width / (categories.length + 0.5);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Container(
            constraints: BoxConstraints(maxWidth: buttonWidth,),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.containerColor,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 18),
              ),
              onPressed: () {
                viewModel.changeCategory(category);
              },
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  category,
                  style: TextStyle(
                    color: viewModel.selectedCategory == category
                        ? AppColors.white
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

  Widget _buildNewsList(BuildContext context) {
    NewsViewModel viewModel = Provider.of<NewsViewModel>(
      context,
      listen: true,
    );

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator(),);
    }

    if (viewModel.news.isEmpty) {
      return const Center(
        child: Text(
          "No news available",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    }

    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: viewModel.news.length,
        itemBuilder: (context, index) {
          final news = viewModel.news[index];
          //print(news.title);
          return SizedBox(
            child: _buildCard(context, news, viewModel),
          );
        },
      ),
    );
  }
  
  Widget _buildCard(BuildContext context, News news, NewsViewModel viewModel) {
    return GestureDetector(
      onTap: () {
        /*
        Navigator.push(
          context,
          _buildWebViewPage(news),
        );

         */
      },
      child: Card(
        color: Colors.transparent,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4,),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildImage(news, context),
                  const SizedBox(width: 16,),
                  _buildTitle(news),
                ],
              ),
              const SizedBox(height: 6,),
              _buildTimeAndSource(news, viewModel),
              const SizedBox(height: 12,),
            ],
          ),
        ),
      ),
    );
  }

  /*
  PageRouteBuilder<dynamic> _buildWebViewPage(News news) {
    return PageRouteBuilder(
      opaque: true,
      pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
        backgroundColor: Colors.black,
        body: WebViewPage(news: news),
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

   */

  Widget _buildImage(News news, BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double newsItemHeight = screenHeight / 10;
    double newsItemWidth = newsItemHeight * 1.333;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: newsItemWidth,
        height: newsItemHeight,
        color: Colors.transparent,
        child: Image.network(
          news.banner_image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.network(
              "https://www.alticeusa.com/sites/default/files/2022-10/2022_Altice_Corp_Site_Homepage_Icons_Only_Solid_Black_News.png",
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle(News news) {
    return Expanded(
      child: Text(
        news.title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 3,
      ),
    );
  }

  Widget _buildTimeAndSource(News news, NewsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(
        "${viewModel.timeFormatter(news.time_published)}  -  ${news.source_domain}",
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.gray,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

}