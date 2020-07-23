import 'package:flutter/material.dart';
import 'package:unsplash_init/data_provider.dart';
import 'package:unsplash_init/models/photo_list/model.dart';

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Unsplash photos"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
                future: DataProvider.getPhotos(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                        "Error loading photos: ${snapshot.error.toString()}");
                  } else if (snapshot.hasData) {
                    return _buildListView(snapshot.data.photos);
                  }
                  return CircularProgressIndicator();
                })
          ],
        ),
      ),
    );
  }
}

Widget _buildListView(List<Photo> photos) {
  return ListView.builder(
    itemBuilder: (context, i) {
      return GestureDetector(
          child: _buildPhotoRow(photos[i]),
          onTap: () {
            Navigator.pop(context, photos[i]);
          });
    },
    itemCount: photos.length,
  );
}

Widget _buildPhotoRow(Photo photo) {
  return Center(
      child: Column(
    children: [Image.network(photo.urls.thumb), Text(photo.altDescription)],
  ));
}
