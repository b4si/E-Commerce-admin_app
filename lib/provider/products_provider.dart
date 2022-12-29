// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProductsProvider with ChangeNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController originalPriceController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();
  TextEditingController discriptionController = TextEditingController();

  File? image;
  var imagePath;

  String imageUrl = '';

  pickImage() async {
    final imagePick =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imagePick == null) {
      return;
    } else {
      File imagePath = File(imagePick.path);

      image = imagePath;
    }
    notifyListeners();
  }

  removeImage() async {
    if (image == null) {
      return;
    } else {
      image = null;
    }
    notifyListeners();
  }

  textfieldclear() {
    nameController.clear();
    originalPriceController.clear();
    discountedPriceController.clear();
    discriptionController.clear();
    notifyListeners();
  }

  bannerFieldClear() {
    image = null;
    notifyListeners();
  }
}
