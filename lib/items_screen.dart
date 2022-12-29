// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coza_admin/product_screen.dart';
import 'package:flutter/material.dart';

class ItemsScreen extends StatelessWidget {
  ItemsScreen({super.key}) {
    _stream = _reference.snapshots();
  }

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('items_list');

  //_reference.get() --> returns Future<QuerySnapshot>
  //_reference.Snapshot() -->  Stream<QuerySnapshot> -- realtime updates

  late Stream<QuerySnapshot> _stream;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          //check error ------->

          if (snapshot.hasError) {
            return Center(child: Text('Error${snapshot.error}'));
          }

          //Check if data is arrived ------->

          if (snapshot.hasData) {
            //get data ------->

            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;

            //Converting the documents to map -------->

            List<Map> items = documents
                .map((e) => {
                      'id': e['id'],
                      'name': e['name'],
                      'org_price': e['original_price'],
                      'image': e['imageUrl'],
                      'dis_price': e['discounted_price'],
                      'desciption': e['desciption']
                    })
                .toList();

            //Display the list ------->

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                Map thisItem = items[index];

                return ListTile(
                    leading: Container(
                      width: size.width * 0.15,
                      height: size.height * 0.07,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          thisItem['image'],
                        ),
                      ),
                    ),
                    title: Text(
                      thisItem['name'],
                    ),
                    subtitle: Text(
                      thisItem['org_price'],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        _reference.doc(thisItem['id']).delete();
                      },
                      icon: const Icon(
                        Icons.delete_outlined,
                        color: Colors.redAccent,
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) => ProductScreen(
                                  id: thisItem['id'],
                                  name: thisItem['name'],
                                  orgPrice: thisItem['org_price'],
                                  disPrice: thisItem['dis_price'],
                                  desciption: thisItem['desciption'],
                                  imageUrl: thisItem['image'],
                                )),
                          ),
                        ));
              },
            );
          }

          //show loader if it is loading -------->

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
