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
    context.read<HomeProvider>().processAndSendDataBatches();
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


}
