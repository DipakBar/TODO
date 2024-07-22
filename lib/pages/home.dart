import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/pages/edituser.dart';

import 'add_Users.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'TODO',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Something went wrong: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: (context, index) {
                final doc = data.docs[index];
                final title = doc['title'];
                final description = doc['description'];
                bool isCompleted = doc['isCompleted'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.red,
                                  value: isCompleted,
                                  onChanged: (value) async {
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(doc.id)
                                        .update({
                                      'isCompleted': value,
                                    });

                                    setState(() {
                                      isCompleted = value!;
                                    });
                                  },
                                ),
                                Text(
                                  "title : $title \n description: $description",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditUser(
                                              docId: doc.id,
                                              title: title,
                                              description: description,
                                              isCompleted: isCompleted,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(doc.id)
                                            .delete();
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUsers(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
