import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coza_admin/provider/products_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String uniqueImageName = DateTime.now().microsecondsSinceEpoch.toString();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Consumer<ProductsProvider>(
                    builder: (context, value, child) => Container(
                      width: size.width * 0.4,
                      height: size.height * 0.2,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2),
                      ),
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
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<ProductsProvider>(context, listen: false)
                          .pickImage();
                    },
                    child: const Text('Add Image'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Provider.of<ProductsProvider>(context, listen: false)
                          .removeImage();
                    },
                    child: const Text('Remove'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: Provider.of<ProductsProvider>(
                    context,
                    listen: false,
                  ).nameController,
                  decoration: InputDecoration(
                    hintText: 'Product name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(width: 2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: Provider.of<ProductsProvider>(
                    context,
                    listen: false,
                  ).originalPriceController,
                  decoration: InputDecoration(
                    hintText: 'Original Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(width: 2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: Provider.of<ProductsProvider>(
                    context,
                    listen: false,
                  ).discountedPriceController,
                  decoration: InputDecoration(
                    hintText: 'Discounted Price',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(width: 2),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: Provider.of<ProductsProvider>(
                    context,
                    listen: false,
                  ).discriptionController,
                  style: const TextStyle(),
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Discription',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(width: 2),
                    ),
                  ),
                ),
              ),
              Consumer<ProductsProvider>(
                builder: (context, value, child) => ElevatedButton(
                  onPressed: () async {
                    //Get a reference to storage root -------->

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('Images');

                    //Create a reference for the image to be stored ------->

                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqueImageName);

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

                    Map<String, String> dataToSave = {
                      'id': DateTime.now().millisecondsSinceEpoch.toString(),
                      'imageUrl': value.imageUrl,
                      'name': value.nameController.text,
                      'original_price': value.originalPriceController.text,
                      'discounted_price': value.discountedPriceController.text,
                      'desciption': value.discriptionController.text,
                    };

                    //Addind all datas to firebase ------->

                    FirebaseFirestore.instance
                        .collection('items_list')
                        .add(dataToSave)
                        .whenComplete(
                          () => value.textfieldclear(),
                        );
                  },
                  child: const Text('Upload'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
