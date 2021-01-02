import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_template/map_state_cubit.dart';
import 'package:flutter_template/push_notifications.dart';
import 'package:latlong/latlong.dart';
import "rest_util.dart";

void main() async {
  // getDefis().then((_) => null);
  runApp(MyApp());
}

// https://lz4.overpass-api.de/api/interpreter?data=[out:json][timeout:25];area(3600051701)-%3E.searchArea;(node[%22emergency%22=%22defibrillator%22][%22opening_hours%22=%2224/7%22](area.searchArea);way[%22emergency%22=%22defibrillator%22][%22opening_hours%22=%2224/7%22](area.searchArea);relation[%22emergency%22=%22defibrillator%22][%22opening_hours%22=%2224/7%22](area.searchArea););out;%3E;out%20skel%20qt;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var pushNotification = PushNotificationsManager();
    pushNotification.init();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        // home: MyHomePage(title: 'Flutter Demo Home Page'),
        home: BlocProvider<MapStateCubit>(
            create: (_) => MapStateCubit(MapController()),
            child: MapHomePage()));
  }
}

class MapHomePage extends StatelessWidget {
  Future<List<Marker>> _getMarkersOnline(BuildContext context) async {
    List<DefiNode> defis = await getDefis();
    return defis
        .map((defi) => Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(defi.lat, defi.lon),
            builder: (ctx) => Container(child: Icon(Icons.place))))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Defi"),
        ),
        body: FutureBuilder(
          future: _getMarkersOnline(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return MapPage(snapshot.data);
              // Center(
              //   child: Text(
              //     snapshot.data,
              //   ),
              // );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => BlocProvider.of<MapStateCubit>(context).zoomIn(),
            heroTag: null,
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            child: Icon(Icons.remove),
            onPressed: () => BlocProvider.of<MapStateCubit>(context).zoomOut(),
            heroTag: null,
          )
        ]));
  }
}

class MapPage extends StatelessWidget {
  MapPage(this._markers);
  final List<Marker> _markers;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: BlocProvider.of<MapStateCubit>(context).controller,
      options: new MapOptions(
        center: new LatLng(47.36667, 8.55),
        // center: new LatLng(47.6780089, 8.8311129),
        zoom: BlocProvider.of<MapStateCubit>(context).state,
        plugins: [
          MarkerClusterPlugin(),
        ],
      ),
      layers: [
        new TileLayerOptions(
            // urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            urlTemplate: "https://tile.osm.ch/osm-swiss-style/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c']),
        MarkerClusterLayerOptions(
          maxClusterRadius: 120,
          size: Size(40, 40),
          fitBoundsOptions: FitBoundsOptions(
            padding: EdgeInsets.all(50),
          ),
          markers: _markers,
          polygonOptions: PolygonOptions(
              borderColor: Colors.blueAccent,
              color: Colors.black12,
              borderStrokeWidth: 3),
          builder: (context, markers) {
            return FloatingActionButton(
              child: Text(markers.length.toString()),
              onPressed: null,
            );
          },
        ),
        // new MarkerLayerOptions(markers: _markers
        // [
        //   new Marker(
        //     width: 80.0,
        //     height: 80.0,
        //     point: new LatLng(51.5, -0.09),
        //     builder: (ctx) => new Container(
        //       child: new FlutterLogo(),
        //     ),
        //   ),
        // ],
        // ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
