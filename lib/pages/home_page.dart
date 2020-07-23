import 'package:flutter/material.dart';
import 'package:unsplash_init/data_provider.dart';

import 'photo_list.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Press button to login',
            ),
            FlatButton(
              child: Text("Login"),
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              onPressed: () => {doLogin(context)}, //TODO: add auth WebView here
            )
          ],
        ),
      ),
    );
  }
}

void doLogin(BuildContext context) {
  if (DataProvider.authToken == "") {
    //TODO: WebView must be here
    String oneTimeCode = 'ICSU40-wo3wl_yKskJAH9uEvfcyybWsNQ1s9HBNZCOs';
    DataProvider.doLogin(oneTimeCode: oneTimeCode).then((value) {
      DataProvider.authToken = value.accessToken;
    });
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PhotoListScreen(),
    ),
  );
}
