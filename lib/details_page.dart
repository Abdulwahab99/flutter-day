import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:flutterday/constants.dart';

class DetailsPage extends StatefulWidget {
  final int id;
  final String title;

  DetailsPage(this.id, this.title);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Dio dio = Dio();
  var details = "";

  Future<Response> getDetailsWithId() {

    return dio.get(BASE_URL_WITH_ID(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title ?? ""}"),
      ),
      body: FutureBuilder(
        future: getDetailsWithId(),
        builder:
            (BuildContext context, AsyncSnapshot<Response<dynamic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
              break;
            case ConnectionState.none:
              return Container();
            case ConnectionState.done:
              var detailsData = snapshot.data.data;
              return ListView(
                children: [
                  Stack(
                    children: [
                      Container(height: 320,),
                      Image.network(
                        "${detailsData["featured_image"]}",
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Card(
                          elevation: 4,
                          shadowColor: Colors.black45,
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    "${detailsData["title"]}",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            "${detailsData["author"]["avatar_URL"]}",
                          ),
                        ),
                      ),
                      title: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${detailsData["author"]["first_name"]} ",
                              style: TextStyle(color: Colors.black26),
                            ),
                            TextSpan(
                              text: "${detailsData["author"]["last_name"]}",
                              style: TextStyle(color: Colors.black26),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${detailsData["content"]}",
                        style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                      ),
                    ),
                  ),
                ],
              );

            default:
              return Container();
          }
        },
      ),
    );
  }
}
