import 'package:uuid/uuid.dart';

class Task {
  String name;
  String uid = '';
  bool isComplete;

  Task({this.name = '', this.isComplete = false}) {
    // Create uuid object
    var uuid = const Uuid();

    // Generate a v4 (random) id
    uid = uuid.v4();
  }

  void toggleComplete() {
    isComplete = !isComplete;
  }
}
