/*
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../tools/AppColors.dart';

class ProfileWebView extends StatefulWidget {
  final String text1;
  final String text2;

  ProfileWebView({required this.text1, required this.text2});

  @override
  State<ProfileWebView> createState() => _ProfileWebViewState();
}

class _ProfileWebViewState extends State<ProfileWebView> {
  late final WebViewController _controller;
  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    _controller.loadRequest(Uri.parse(widget.text2));
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
        title: Text(
          "${widget.text1}",
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
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