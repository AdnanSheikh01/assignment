import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllStudentsPage extends StatefulWidget {
  const AllStudentsPage({super.key});

  @override
  State<AllStudentsPage> createState() => _AllStudentsPageState();
}

class _AllStudentsPageState extends State<AllStudentsPage> {
  int counting = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('client').snapshots(),
        builder: (context, snapshot) {
          List<Column> clientWidgets = [];
          if (snapshot.hasData) {
            final clients = snapshot.data?.docs.reversed.toList();
            for (var client in clients!) {
              final clientWidget = Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 30,
                          foregroundImage: client['gender'] == 'Male'
                              ? const AssetImage(
                                  'assets/images/man.png',
                                )
                              : const AssetImage('assets/images/women.png'),
                        ),
                        title: Text(client['name']),
                        subtitle: Row(
                          children: [
                            Text('${client['dob']}, '),
                            Text(client['gender']),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
              clientWidgets.add(clientWidget);
            }
          }

          return Expanded(child: ListView(children: clientWidgets));
        },
      ),
    );
  }
}
