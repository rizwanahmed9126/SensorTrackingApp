import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import '../../data/models/log_model.dart';
import '../../domain/usecases/remote_tasks.dart';
import '../../domain/usecases/local_tasks.dart';

class HomeProvider extends ChangeNotifier {
  final LocalTasks _localStorageTasks;
  final RemoteTasks _remoteTasks;

  HomeProvider({
    required LocalTasks localStorageTasks,
    required RemoteTasks remoteTasks,
  })  : _remoteTasks = remoteTasks,
        _localStorageTasks = localStorageTasks;

  //variables
  LogModel? logModel;
  bool isCompassEnabled = false;
  Timer? _timer;
  Timer? _timer2;

  //get local saved data and send to server
  Future<void> processAndSendDataBatches() async {
    bool hasMoreData = true;
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      while (hasMoreData) {
        String jsonLogs = await getLogs();
        List<dynamic> logList = jsonDecode(jsonLogs);

        if (logList.isNotEmpty) {
          var result = await uploadDataOnServer(jsonLogs);
          if (result) {
            List<int> sentLogIds =
                logList.map((log) => log['id'] as int).toList();
            await deleteLogs(sentLogIds);
          }
        } else {
          hasMoreData = false;
          break; // No more data to send
        }
      }
    } else {
      debugPrint("not connected to any network");
    }
  }

  //send to server
  Future<bool> uploadDataOnServer(String body) async {
    bool? result;

    final response = await _remoteTasks.execute(body);

    response.fold(
      (e) {
        result = false;
      },
      (list) {
        result = true;
      },
    );

    return result ?? false;
  }

  //delete local data
  Future<void> deleteLogs(List<int> ids) async {
    final fetched = await _localStorageTasks.deleteLogs(ids);
    fetched.fold(
      (e) {
        debugPrint("fail to delete logs");
      },
      (list) {
        debugPrint("deleted logs");
      },
    );
  }

  //get local data
  Future<String> getLogs() async {
    String? data;
    final fetched = await _localStorageTasks.showLogs();
    fetched.fold(
      (e) {
        debugPrint("fail to fetch logs");
      },
      (list) {
        data = list;
        debugPrint(data);
      },
    );

    return data ?? 'null';
  }

  //send data to server after every minute
  void sendDataToServer() async {
    _timer2 = Timer.periodic(const Duration(minutes: 1), (timer) {
      processAndSendDataBatches();
    });
  }

  //get and save compass data
  void startData() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final result = await _localStorageTasks.getAndSaveLogLocal();
      result.fold(
        (e) {
          debugPrint(e.toString());
        },
        (list) {
          logModel = list;
        },
      );
      notifyListeners();
    });
  }

  //stop getting and saving compass data
  void pauseData() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    if (_timer2 != null) {
      _timer2!.cancel();
      _timer2 = null;
    }
  }

  //toggle start pause
  void startAndPause() async {
    isCompassEnabled = !isCompassEnabled;

    if (isCompassEnabled) {
      startData();
      sendDataToServer();
    } else {
      pauseData();
      processAndSendDataBatches();
    }
    notifyListeners();
  }

  //continues listening to internet connectivity
  void startConnectivityListener() {
    var connectivity = Connectivity();
    ConnectivityResult? previousResult;

    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (previousResult == ConnectivityResult.none &&
          result != ConnectivityResult.none) {
        processAndSendDataBatches();
      }

      previousResult = result;
    });
  }
}
