import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtest/TodoForm/todo_form.dart';
import 'package:riverpodtest/data/todo_model.dart';
import 'package:riverpodtest/home/todos_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todosLength = ref.watch(todosProvider).when(
          data: (todos) => todos.length,
          loading: () => 0,
          error: (err, stack) => -1,
        );
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
          return const Divider();
        },
        itemCount: todosLength,
      ),
    );
  }
}
