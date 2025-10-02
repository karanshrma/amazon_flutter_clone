import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const String defaultImageUrl = "https://media.istockphoto.com/id/2173059563/vector/coming-soon-image-on-white-background-no-photo-available.jpg?s=612x612&w=0&k=20&c=v0a_B58wPFNDPULSiw_BmPyhSNCyrP_d17i2BPPyDTk=";
void showSnackbar(BuildContext context, String text) {
  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(text , style: const TextStyle(color: Colors.black),) , backgroundColor: Colors.orangeAccent,));
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();

  try {
    List<XFile>? files = await picker.pickMultiImage();
    if (files != null && files.isNotEmpty) {
      for (int i = 0; i < files.length; i++) {
        images.add(File(files[i].path));
      }
    }
  } catch (e) {
    debugPrint(e.toString());
  }
  return images;
}