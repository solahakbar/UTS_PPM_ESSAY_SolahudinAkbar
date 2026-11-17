import '../data/activity_data.dart';
import '../models/activity_model.dart';

class ActivityRepository {
  final ActivityData _data;

  ActivityRepository(this._data);

  List<ActivityModel> getAll() => List.unmodifiable(_data.activities);

  ActivityModel? getById(String id) {
    for (final a in _data.activities) {
      if (a.id == id) return a;
    }
    return null;
  }

  void add(String name) {
    _data.activities.add(
      ActivityModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name,
      ),
    );
  }

  void update(String id, String newName) {
    final activity = getById(id);
    if (activity != null) activity.name = newName;
  }

  void delete(String id) {
    _data.activities.removeWhere((a) => a.id == id);
  }

  void updateCounter(String id, int value) {
    final activity = getById(id);
    if (activity != null) activity.counter = value;
  }
}
