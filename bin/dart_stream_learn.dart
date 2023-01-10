import 'dart:async';

void main() {
  streamControllerConstructorSync();
}

void streamControllerConstructorSync() {
  StreamController<int> controller = StreamController(sync: true);
  StreamSubscription sub;
  sub = controller.stream.listen((event) {
    print(event);
  });
  print('one');
  controller.add(1);
  controller.add(2);
  controller.add(3);
  controller.add(4);
  print('two');
  controller.add(5);
  controller.add(6);
  controller.add(7);
  Future.delayed(
    Duration(seconds: 5),
    () {
      controller.add(8);
      controller.close();
      sub.cancel();
    },
  );
}

void streamControllerConstructor() {
  StreamController<int> controller = StreamController(
    onCancel: () => print('onCancel'),
    onListen: () => print('onListen'),
    onPause: () => print('onPause'),
    onResume: () => print('onResume'),
  );
  StreamSubscription sub;
  controller.add(1);
  controller.add(2);
  controller.add(3);
  controller.add(4);

  final stream = controller.stream;
  sub = stream.listen((event) {
    print(event);
  });

  Future.delayed(
    Duration(seconds: 1),
    () {
      controller.onPause!();
    },
  );
  Future.delayed(
    Duration(seconds: 2),
    () {
      controller.onResume!();
    },
  );
  controller.add(5);
  controller.add(6);
  controller.add(7);
  Future.delayed(
    Duration(seconds: 5),
    () {
      controller.add(8);
      controller.close();
      sub.cancel();
    },
  );
}

void streamControllerAsyncBroadcast() {
  StreamController<int> controller = StreamController();
  StreamSubscription sub;
  StreamSubscription sub2;
  controller.add(1);
  controller.add(2);
  controller.add(3);
  controller.add(4);

  final stream = controller.stream.asBroadcastStream();
  sub = stream.listen((event) {
    print(event);
  });
  sub2 = stream.listen((event) {
    print(event);
  });
  controller.add(5);
  controller.add(6);
  controller.add(7);
  Future.delayed(
    Duration(seconds: 3),
    () {
      controller.add(8);
      controller.close();
      sub.cancel();
    },
  );
}

void streamControllerAsync() {
  StreamController<int> controller = StreamController();
  StreamSubscription sub;
  controller.add(1);
  controller.add(2);
  controller.add(3);
  controller.add(4);

  sub = controller.stream.listen((event) async {
    if (event % 2 == 0) {
      await Future.delayed(Duration(seconds: 1));
    }
    print(event);
  });
  controller.add(5);
  controller.add(6);
  controller.add(7);
  Future.delayed(
    Duration(seconds: 3),
    () {
      controller.add(8);
      controller.close();
      sub.cancel();
    },
  );
}

void streamControllerClassic() {
  StreamController<int> controller = StreamController();
  StreamSubscription sub;
  controller.add(1);
  controller.add(2);
  controller.add(3);
  controller.add(4);
  sub = controller.stream.listen((event) {
    print(event);
  });
  controller.add(5);
  controller.add(6);
  controller.add(7);
  Future.delayed(
    Duration(seconds: 3),
    () {
      controller.add(8);
      controller.close();
      sub.cancel();
    },
  );
}

void streamClassicDoubleSubscriptionAwait() {
  Stream<int> stream;

  stream = Stream.periodic(
    Duration(seconds: 1),
    (computationCount) => computationCount,
  ).take(10).asBroadcastStream();

  Future<void> listen1() async {
    await for (var i in stream) {
      print(i);
    }
  }

  Future<void> listen2() async {
    await for (var i in stream) {
      print(i);
    }
  }

  listen1();
  listen2();
}

void streamClassicDoubleSubscription() {
  Stream<int> stream;
  StreamSubscription sub;
  StreamSubscription sub2;
  stream = Stream.periodic(
    Duration(seconds: 1),
    (computationCount) => computationCount,
  ).take(10);
  stream = stream.asBroadcastStream();
  sub = stream.listen((event) {
    print(event);
  });
  sub2 = stream.listen((event) {
    print(event);
  });
  Future.delayed(
    Duration(seconds: 5),
    () {
      sub.cancel();
      sub2.cancel();
    },
  );
}

void streamClassicSubscription() {
  Stream<int> stream;
  Stream<String> stream2;
  StreamSubscription sub;
  StreamSubscription sub2;

  stream = Stream.periodic(
    Duration(seconds: 1),
    (computationCount) => computationCount,
  ).take(10);
  stream2 = Stream.periodic(
    Duration(seconds: 1),
    (computationCount) => '$computationCount --',
  ).take(20);
  sub = stream.listen((event) {
    print(event);
  });
  sub2 = stream2.listen((event) {
    print(event);
  });
  Future.delayed(
    Duration(seconds: 3),
    () => sub.pause(),
  );
  Future.delayed(
    Duration(seconds: 5),
    () => sub.resume(),
  );
  Future.delayed(
    Duration(seconds: 7),
    () {
      sub.cancel();
      sub2.cancel();
    },
  );
}
