import 'package:isar/isar.dart';

part 'todo_model.g.dart';

enum TodoStatus { active, completed, pending }

@Collection()
class TodoModel {
  Id id = Isar.autoIncrement;
  @Index(type: IndexType.value)
  String? title;
  @Index(type: IndexType.value)
  String? description;
  @enumerated
  TodoStatus status = TodoStatus.active;
  DateTime? createdAt = DateTime.now();

  TodoModel({this.title, this.description, this.status = TodoStatus.active});
}
