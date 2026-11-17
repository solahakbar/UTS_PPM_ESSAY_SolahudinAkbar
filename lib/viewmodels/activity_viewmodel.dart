import 'package:flutter/foundation.dart';

import '../models/activity_model.dart';
import '../repositories/activity_repository.dart';

class ActivityViewModel extends ChangeNotifier {
  final ActivityRepository _repository;

  ActivityViewModel(this._repository);

  List<ActivityModel> get activities => _repository.getAll();

  ActivityModel? getById(String id) => _repository.getById(id);

  void addActivity(String name) {
    _repository.add(name.trim());
    notifyListeners();
  }

  void renameActivity(String id, String newName) {
    _repository.update(id, newName.trim());
    notifyListeners();
  }

  void deleteActivity(String id) {
    _repository.delete(id);
    notifyListeners();
  }

  void increment(String id) {
    final a = _repository.getById(id);
    if (a == null) return;
    _repository.updateCounter(id, a.counter + 1);
    notifyListeners();
  }

  bool decrement(String id) {
    final a = _repository.getById(id);
    if (a == null || a.counter <= 0) return false;
    _repository.updateCounter(id, a.counter - 1);
    notifyListeners();
    return true;
  }

  void reset(String id) {
    _repository.updateCounter(id, 0);
    notifyListeners();
  }
}
