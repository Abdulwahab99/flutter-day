import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterday/constants.dart';
import 'package:flutterday/details_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Day App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Dio dio = Dio();

  Future<Response> getData() {
    return dio.get(BASE_URL);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<Response>(
        future: getData(),
        builder:
            (BuildContext context, AsyncSnapshot<Response<dynamic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );

            case ConnectionState.none:
              return Container(
                child: Text("No data"),
              );

            case ConnectionState.done:
              var dataList = snapshot.data.data["posts"];

              return ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: ListTile(
                      onTap: () {
                        print(dataList[index]["ID"]);

                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                          return DetailsPage(dataList[index]["ID"],dataList[index]["title"]);
                        }));
                      },
                      title: Text("${dataList[index]["title"]}"),
                    ),
                  );
                },
              );

            default:
              return Container();
          }
        },
      ),
    );
  }
}
//
