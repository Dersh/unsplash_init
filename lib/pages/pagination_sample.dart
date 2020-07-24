import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PaginationSample extends StatefulWidget {
  @override
  _PaginationSampleState createState() => _PaginationSampleState();
}

class _PaginationSampleState extends State<PaginationSample> {
  ScrollController _scrollController = ScrollController();
  int pageCount = 0;
  bool isLoading = false;
  var data = List();
  final dio = Dio();

  @override
  void initState() {
    this._getData(pageCount);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getData(pageCount);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaginationSample'),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: data.length + 1,
          padding: EdgeInsets.symmetric(vertical: 8.0),
          itemBuilder: (BuildContext context, int index) {
            if (index == data.length) {
              return Center(
                child: Opacity(
                  opacity: isLoading ? 1 : 0,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return ListTile(
                leading: Stack(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                        data[index]['picture']['large'],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: Text(
                        '$index',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                title: Text(
                    ('${data[index]['name']['title']} ${data[index]['name']['first']} ${data[index]['name']['last']}')),
                subtitle: Text('${data[index]['email']}'),
              );
            }
          },
          controller: _scrollController,
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  void _getData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      var url = 'https://randomuser.me/api/?page=$index&results=20&seed=abc';
      final response = await dio.get(url);
      List tempList = List();
      for (int i = 0; i < response.data['results'].length; i++) {
        tempList.add(response.data['results'][i]);
      }

      setState(() {
        isLoading = false;
        data.addAll(tempList);
        pageCount++;
      });
    }
  }
}
