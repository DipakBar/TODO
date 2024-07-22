import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:todo/service/database.dart';
import 'package:uuid/uuid.dart';

class AddUsers extends StatefulWidget {
  const AddUsers({super.key});

  @override
  State<AddUsers> createState() => _AddUsersState();
}

class _AddUsersState extends State<AddUsers> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isCompleted = false;

  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('ADD TODO'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Title Field
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              Row(
                children: [
                  Checkbox(
                    value: isCompleted,
                    onChanged: (value) {
                      setState(() {
                        isCompleted = value ?? false;
                      });
                    },
                  ),
                  Text('Completed'),
                ],
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    print('odd');
                    String id = uuid.v4();
                    Map<String, dynamic> user = {
                      'id': id,
                      'title': titleController.text,
                      'description': descriptionController.text,
                      'isCompleted': isCompleted,
                    };

                    await Database().addUsers(user, id).then((value) {
                      titleController.clear();
                      descriptionController.clear();

                      Fluttertoast.showToast(msg: 'added successfully');
                      Navigator.pop(context);
                    }).catchError((error) {
                      Fluttertoast.showToast(msg: 'Failed to add: $error');
                    });
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
