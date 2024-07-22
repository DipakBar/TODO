import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditUser extends StatefulWidget {
  final String docId;
  final String title;
  final String description;
  final bool isCompleted;

  EditUser({
    required this.docId,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
    _isCompleted = widget.isCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'EDIT TODO',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
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
                controller: _descriptionController,
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
                    value: _isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value ?? false;
                      });
                    },
                  ),
                  Text('Completed'),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.docId)
                        .update({
                      'title': _titleController.text,
                      'description': _descriptionController.text,
                      'isCompleted': _isCompleted,
                    }).then((_) {
                      Navigator.pop(context);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to update TODO: $error'),
                        ),
                      );
                    });
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
