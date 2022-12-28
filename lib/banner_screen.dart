import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coza_admin/provider/products_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String uniqueBannerName = DateTime.now().millisecondsSinceEpoch.toString();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Banner'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Consumer<ProductsProvider>(
              builder: (context, value, child) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                ),
                width: double.infinity,
                height: size.height * 0.24,
                child: value.image != null
                    ? Image.file(
                        value.image!,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.error,
                      ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ProductsProvider>(
                context,
                listen: false,
              ).pickImage();
            },
            child: const Text(
              '  Open Banner photo  ',
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<ProductsProvider>(
                context,
                listen: false,
              ).removeImage();
            },
            child: const Text(
              'Remove Banner photo',
            ),
          ),
          Consumer<ProductsProvider>(
            builder: (context, value, child) => ElevatedButton(
              onPressed: () async {
                //Get a reference to storage root -------->

                Reference referenceRoot = FirebaseStorage.instance.ref();
                Reference referenceDirImages =
                    referenceRoot.child('banner_images');

                //Create a reference for the image to be stored ------->

                Reference referenceImageToUpload =
                    referenceDirImages.child(uniqueBannerName);

                //Handle errors using try catch ------->

                try {
                  //Store the file ------->

                  if (value.image == null) {
                    return;
                  }
                  await referenceImageToUpload.putFile(
                    File(value.image!.path),
                  );

                  //Get the download URL ------->

                  value.imageUrl =
                      await referenceImageToUpload.getDownloadURL();
                } catch (err) {
                  log(err.toString());
                }

                //Created map for all data models ------->

                Map<String, String> bannerToSave = {
                  'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'imageURL': value.imageUrl,
                };

                //Addind all datas to firebase ------->

                FirebaseFirestore.instance
                    .collection('banner_list')
                    .add(bannerToSave);
              },
              child: const Text(
                '        Add to Cloud        ',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
