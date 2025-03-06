/*
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../model/news.dart';
import '../tools/AppColors.dart';

class WebViewPage extends StatefulWidget {
  final News news;

  WebViewPage({required this.news});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    if (widget.news.url.isNotEmpty && Uri.tryParse(widget.news.url) != null) {
      _controller.loadRequest(Uri.parse(widget.news.url));
    } else {
      // Geçersiz URL olduğu durumda kullanıcıya bir mesaj gösterin
      print("Geçersiz URL: ${widget.news.url}");
    }
  }

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
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "${widget.news.source_domain}",
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return WebViewWidget(controller: _controller,);
  }
}

 */