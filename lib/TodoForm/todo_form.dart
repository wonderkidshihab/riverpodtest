import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtest/data/todo_model.dart';
import 'package:riverpodtest/home/todos_provider.dart';

class TodoFormPage extends ConsumerStatefulWidget {
  final TodoModel? todoModel;
  const TodoFormPage({super.key, this.todoModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoFormPageState();
}

class _TodoFormPageState extends ConsumerState<TodoFormPage> {
  late Todos todosNotifier;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TodoStatus status = TodoStatus.active;
  final key = GlobalKey<FormState>();

  @override
  void initState() {
    todosNotifier = ref.read(todosProvider.notifier);
    if (widget.todoModel != null) {
      titleController.text = widget.todoModel!.title ?? '';
      descriptionController.text = widget.todoModel!.description ?? '';
      status = widget.todoModel!.status;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todoModel == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: Form(
        key: key,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TodoStatus>(
              value: status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              items: const [
                DropdownMenuItem(
                  value: TodoStatus.active,
                  child: Text('Active'),
                ),
                DropdownMenuItem(
                  value: TodoStatus.completed,
                  child: Text('Completed'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    status = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (key.currentState!.validate()) {
                  if (widget.todoModel == null) {
                    await todosNotifier.addTodo(
                      TodoModel(
                        title: titleController.text,
                        description: descriptionController.text,
                        status: status,
                      ),
                    );
                  } else {
                    await todosNotifier.updateTodoStatus(
                      widget.todoModel!
                        ..title = titleController.text
                        ..description = descriptionController.text
                        ..status = status,
                    );
                  }
                  Navigator.pop(context);
                }
              },
              child: Text(widget.todoModel == null ? 'Add' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
