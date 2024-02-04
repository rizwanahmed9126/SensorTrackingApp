import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sensor_tracking_app/layers/presentation/notifiers/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Permission.locationWhenInUse.request();
    context.read<HomeProvider>().startConnectivityListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor Tracking App"),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Builder(builder: (context) {
        return Consumer<HomeProvider>(builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 16, left: 16.0, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildManualReader(context, value.logModel?.reading ?? 0.0,
                    value.logModel?.readAt ?? 'null'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Collect compass data"),
                    CupertinoSwitch(
                      value: value.isCompassEnabled,
                      onChanged: (vl) {
                        value.startAndPause();
                      },
                      activeColor: Colors.lightGreen,
                      focusColor: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      }),
    );
  }

  Widget _buildManualReader(context, double heading, String dateTime) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          ElevatedButton(
            child: const Text('Read Value'),
            onPressed: () async {
              Provider.of<HomeProvider>(context, listen: false).getLogs();
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('$heading'),
                  Text(dateTime),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
