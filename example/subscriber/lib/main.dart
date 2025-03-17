import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:rosbridge/core/ros.dart';
import 'package:rosbridge/core/topic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Roslibdart subscriber Example',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late Ros ros;
  late Topic chatter;

  @override
  void initState() {
    ros = Ros(url: 'ws://127.0.0.1:9090');
    chatter = Topic(
        ros: ros,
        name: '/topic',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    super.initState();
    ros.connect();
    Timer(const Duration(seconds: 3), () async {
      await chatter.subscribe(subscribeHandler);
      // await chatter.subscribe();
    });
  }

  void destroyConnection() async {
    await chatter.unsubscribe();
    await ros.close();
    setState(() {});
  }

  String msgReceived = '';
  Future<void> subscribeHandler(Map<String, dynamic> msg) async {
    msgReceived = json.encode(msg);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roslibdart Subscriber Example'),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('$msgReceived received'),
          ],
        ),
      ),
    );
  }
}
