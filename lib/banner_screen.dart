// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BannerScreen extends StatelessWidget {
  BannerScreen({super.key}) {
    _stream = _reference.snapshots();
  }

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('banner_list');

  //_reference.get() --> returns Future<QuerySnapshot>
  //_reference.Snapshot() --> Stream<QuerySnapshot> --realtime updates

  late Stream<QuerySnapshot> _stream;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner list'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder: (context, AsyncSnapshot snapshot) {
            //check error -------->

            if (snapshot.hasError) {
              return Center(
                child: Text('Error${snapshot.error}'),
              );
            }

            //check if data is arrived ------->

            if (snapshot.hasData) {
              // get data ------->

              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot.docs;

              //Converting the documents to map -------->

              List<Map> items = documents
                  .map((e) => {'id': e['id'], 'image': e['imageURL']})
                  .toList();

              //Display the list ------->

              return ListView.builder(
                itemCount: items.length,
                itemBuilder: ((context, index) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: size.width * 0.8,
                            height: size.height * 0.22,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                            ),
                            child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                items[index]['image'],
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                //Function for deleting the data ------->

                                _reference.doc(items[index]['id']).delete();
                              },
                              icon: const Icon(Icons.delete_outline))
                        ],
                      ),
                    )),
              );
            }

            //show loader if it is loading ------->

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
