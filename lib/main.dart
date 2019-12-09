import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zigbee Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Zigbeast Demo Home Page'),
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

  double _r = 20;
  double _g = 20;
  double _b = 20;

  int count = 0;

  String _message = "";

  bool _state = true;

  String _stateString = "OFF";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateR(double r) {
    setState(() => _r = r);
  }

  void updateRAndSend(double r) {
    setState(() => _r = r);
    sendJson();
  }

  void updateG(double g) {
    setState(() => _g = g);
  }

  void updateGAndSend(double g) {
    setState(() => _g = g);
    sendJson();
  }

  void updateB(double b) {
    setState(() => _b = b);
  }

  void updateBAndSend(double b) {
    setState(() => _b = b);
    sendJson();
  }

  void toggleState(bool state) {
    setState(() => _state = state);
    sendJson();
  }

  void sendJson() async {
    if(_state){
      _stateString = "ON";

    }
    else _stateString = "OFF";
    // set up POST request arguments
    // _message = "Sending JSON...";
    String url = 'http://192.168.1.15:1880/set';
    Map<String, String> headers = {"Content-type": "application/json"};
    // make POST request
    String json = '{"state": "' + _stateString.toString() + '", "brightness": ' + max(_b, max(_r, _g)).toString() + ', "color": { "r": ' + _r.toString() + ', "g": ' + _g.toString() +  ',"b": ' + _b.toString() +  '}}';
    try{
      await post(url, headers: headers, body: json);
    }
    catch(exception, stacktrace){
      print("Caught Exception for HTTP POST: " + exception.runtimeType.toString());
      //print("Stacktrace: " + stacktrace.toString());
    }


//    int statusCode = response.statusCode;
//    _message = statusCode.toString();
//    sleep(const Duration(seconds:1));
//    _message = "";
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
        appBar: AppBar(
          title: const Text('Zigbeast Demo'),
        ),
        body: Column(
            children: <Widget> [
              Slider(
                activeColor: Colors.red,
                min: 0.0,
                max: 255.0,
                divisions: 255,
                onChanged: updateR,
                onChangeEnd: updateRAndSend,
                label: _r.toString(),
                value: _r,
              ),
              Slider(
                activeColor: Colors.green,
                min: 0.0,
                max: 255.0,
                divisions: 255,
                onChanged: updateG,
                onChangeEnd: updateGAndSend,
                label: _g.toString(),
                value: _g,
              ),
              Slider(
                activeColor: Colors.blue,
                min: 0.0,
                max: 255.0,
                divisions: 255,
                onChanged: updateB,
                onChangeEnd: updateBAndSend,
                label: _b.toString(),
                value: _b,
              ),
              Switch(
                onChanged: toggleState,
                value: _state,
              ),
              Center(
                child: Text(_message)
              )
            ]
        )

    );

  }
}
