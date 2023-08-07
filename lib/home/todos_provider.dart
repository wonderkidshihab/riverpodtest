import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpodtest/data/todo_model.dart';

part 'todos_provider.g.dart';

@riverpod
class Todos extends _$Todos {
  late final Isar _isar;
  Future<List<TodoModel>> getAllTodos() async {
    return await _isar.todoModels.where().findAll();
  }

  @override
  FutureOr<List<TodoModel>> build() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open([TodoModelSchema], directory: dir.path);
    return getAllTodos();
  }

  Future<void> addTodo(TodoModel todoModel) async {
    state = const AsyncValue.loading();
    await _isar.writeTxn(() async {
      await _isar.todoModels.put(todoModel);
    });
    state = AsyncValue.data(await getAllTodos());
  }

  Future<void> updateTodoStatus(TodoModel todoModel) async {
    state = const AsyncValue.loading();
    await _isar.writeTxn(() async {
      await _isar.todoModels.put(todoModel);
    });
    state = AsyncValue.data(await getAllTodos());
  }

  Future<void> deleteTodoById(int id) async {
    state = const AsyncValue.loading();
    await _isar.writeTxn(() async {
      await _isar.todoModels.delete(id);
    });
    state = AsyncValue.data(await getAllTodos());
  }
}
