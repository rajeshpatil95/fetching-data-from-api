import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  var isLoading = false;
  List<String> modelListUpper = [];
  List<String> modelListLower = [];

  _fetchResponse() async {
    setState(() {
      isLoading = true;
    });
    final response =
        await http.get("https://www.minds.com/api/v1/newsfeed/", headers: {
      "Authorization":
          "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjM1NzQ1YTlhZDEzM2I2ZWRmYjhjMzllZGQ0OTU4ZWY0ZjczZGViNDI3YzY3ZGY2NjUwMDhiYTU5MzJhMDM4ZWViNjZlZDg5OTUwMWQyZmFiIn0.eyJhdWQiOiJtb2JpbGUiLCJqdGkiOiIzNTc0NWE5YWQxMzNiNmVkZmI4YzM5ZWRkNDk1OGVmNGY3M2RlYjQyN2M2N2RmNjY1MDA4YmE1OTMyYTAzOGVlYjY2ZWQ4OTk1MDFkMmZhYiIsImlhdCI6MTU1NDUzNDc3OSwibmJmIjoxNTU0NTM0Nzc5LCJleHAiOjE1NTQ3OTM5NzksInN1YiI6Ijk1MjQxNzAwNzI1OTYyMzQyNiIsInNjb3BlcyI6W119.jB9ohtF__E3BFCrH8kQRO8OwI3krZ7iQXYcnHWC-6_p-T_u0TVB3tl_CgXTY-Fy0Ez5VvLSS6KkS6kb07Sxy-NJJtiDuuOSEP65A-LEd4tujZHhTE5-eEtSFKdgEKF1_6y3-9Eqo04aBH1jNayCG9Kf2LUxaFh2Zi6--AlmKXNRCQJ456pLKlozy9HR189UG6UuLW3TC_TIiSFyUtRZRjeAnh65zEn8o5vjDj9ywsxLrmN6iYk3ogdy2Ilp1ubAMXB3bEjkRPnJXszvF7OBNKcv8ObiJMKJW4LjfRea8o-t5JXzI7ZnSPxkmVQYEHhFR8UZ1WGus_v2M1Tu8w_yk1Q"
    });
    print('response $response');

    if (response.statusCode == 200) {
      _fetchIntoList(response.body);
    } else {
      throw Exception('Failed to load photos');
    }
  }

  _fetchIntoList(String jsonStr) {
    print("Response:  ${jsonStr}");
    Map<String, dynamic> myMapData = json.decode(jsonStr);
    List<dynamic> activity = myMapData["activity"];
    activity.forEach((activities) {
      modelListUpper.add(activities['guid']);
      modelListUpper.add(activities['time_created']);
    });
  }

  void _showDialog(String title, String data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(title),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Move Back"),
              onPressed: () {
                if (modelListUpper.contains(data)) {
                  print("Dont Add..!!");
                } else {
                  setState(() {
                    modelListUpper.add(data);
                    modelListLower.remove(data);
                    print("${modelListUpper}, ${modelListLower}");
                  });
                }

                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Show Toast"),
              onPressed: () {
                Fluttertoast.showToast(
                    msg: "$data",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                flex: 2,
                child: new Column(
                  children: <Widget>[
                    new Expanded(
                      flex: 1,
                      child: new ListView.builder(
                          itemCount: modelListUpper.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Center(
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        modelListLower
                                            .add(modelListUpper[index]);
                                        modelListUpper
                                            .remove(modelListUpper[index]);
                                      });
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        new Text("${modelListUpper[index]}"),
                                        new Divider(
                                          height: 8.0,
                                        ),
                                      ],
                                    )));
                          }),
                    ),
                  ],
                ),
              ),
              new Divider(
                height: 8.0,
              ),
              new Expanded(
                flex: 2,
                child: new Column(
                  children: <Widget>[
                    new Expanded(
                      flex: 1,
                      child: new ListView.builder(
                          itemCount: modelListLower.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return Center(
                                child: GestureDetector(
                                    onTap: () {
                                      _showDialog("Alert Pop Up..!!",
                                          modelListLower[index]);
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        new Text("${modelListLower[index]}"),
                                        new Divider(
                                          height: 8.0,
                                        ),
                                      ],
                                    )));
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
