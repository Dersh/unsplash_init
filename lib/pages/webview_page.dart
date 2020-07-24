import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../data_provider.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  showSnack() async {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
        content: const Text('Successed')));
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: const Text('WebView')),
      body: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: DataProvider.authUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: <JavascriptChannel>[
            _toasterJavascriptChannel(context),
          ].toSet(),
          onPageStarted: (String url) async {
            if (url.contains(
                'https://unsplash.com/oauth/authorize/native?code=')) {
              showSnack().then((_) => Navigator.pop(context, url));
            }
          },
          onPageFinished: (String url) {},
          gestureNavigationEnabled: true,
        );
      }),
      //   floatingActionButton: favoriteButton(),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Print',
        onMessageReceived: (JavascriptMessage message) {
          print(message);
        });
  }
}
