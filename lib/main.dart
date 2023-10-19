import 'package:async/async.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  CancelableOperation? cancelableOperation;
  var consoleLogList = <String>[];

  @override
  void initState() {
    super.initState();
  }

  void addLogMessage(String message) {
    setState(() {
      consoleLogList.add(message);
    });
  }

  Future<void> dummyFutureMock() async {
    addLogMessage("future call initiated");
    await Future.delayed(const Duration(seconds: 5), () {
      if (cancelableOperation?.isCanceled ?? true) {
        return;
      }
      addLogMessage("dummyFuture invocation done");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              OutlinedButton(
                onPressed: () async {
                  cancelableOperation =
                      CancelableOperation.fromFuture(dummyFutureMock());
                  await cancelableOperation?.value;
                },
                child: const Text("Start Future Call"),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () {
                  cancelableOperation?.cancel();
                  addLogMessage("future cancelled");
                },
                child: const Text("Cancel Future Call"),
              ),
            ]),
            Expanded(
              child: ListView.builder(
                itemCount: consoleLogList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(consoleLogList.elementAt(index)),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
