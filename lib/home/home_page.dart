import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtest/TodoForm/todo_form.dart';
import 'package:riverpodtest/data/todo_model.dart';
import 'package:riverpodtest/home/todos_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosLength =
        ref.watch(todosProvider.select((value) => value.value?.length ?? 0));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos List'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return Text(
                todosLength.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TodoFormPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final todo = ref.watch(todosProvider
              .select((value) => value.value!.elementAtOrNull(index)));
          if (todo == null) {
            return const SizedBox();
          }
          return InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TodoFormPage(todoModel: todo),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: todo.status == TodoStatus.completed
                    ? Colors.green
                    : Colors.red,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          todo.title ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(todosProvider.notifier)
                              .deleteTodoById(todo.id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          todo.description ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ref.read(todosProvider.notifier).updateTodoStatus(
                                todo
                                  ..status = todo.status == TodoStatus.completed
                                      ? TodoStatus.active
                                      : TodoStatus.completed,
                              );
                        },
                        icon: Icon(
                          todo.status == TodoStatus.completed
                              ? Icons.check_circle
                              : Icons.circle,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 16);
        },
        itemCount: todosLength,
      ),
    );
  }
}
