import 'package:flutter/material.dart';
import 'package:sqflite_app/add_contact.dart';
import 'package:sqflite_app/contacts.dart';
import 'package:sqflite_app/helper.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SqfLite Demo'),
      ),
      body: FutureBuilder<List<Contact>>(
        future: DBHelper.readContacts(),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text("Loading...")
                ],
              ),
            );
          }
          return snapshot.data!.isEmpty
              ? const Center(
                  child: Text("No Contacts"),
                )
              : ListView(
                  children: snapshot.data!.map((contacts) {
                    return Center(
                      child: ListTile(
                        title: Text(contacts.name),
                        subtitle: Text(contacts.contact),
                        trailing: IconButton(
                            onPressed: () async {
                              await DBHelper.deleteContacts(contacts.id!);
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete)),
                        onLongPress: () async {
                          final refresh = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (_) => AddContacts(
                                        contact: Contact(
                                            id: contacts.id,
                                            name: contacts.name,
                                            contact: contacts.contact),
                                      )));
                          if (refresh) {
                            setState(() {
                              //if return true rebuild whole widget
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final refresh = await Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AddContacts()));
            if (refresh) {
              setState(() {
                //if return true rebuild whole widget
              });
            }
          },
          child: const Icon(Icons.add)),
    );
  }
}
