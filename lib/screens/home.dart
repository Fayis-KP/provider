import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _image; // Variable to store the selected image
  final ImagePicker _picker = ImagePicker();
  late CollectionReference<Map<String, dynamic>> userCollection;

  @override
  void initState() {
    super.initState();
    userCollection= FirebaseFirestore.instance.collection('user');
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _image = File(image.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> uploadImage() async {
    if (_image == null) return;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('User/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(_image!);

      final imageUrl = await ref.getDownloadURL();
      await saveData(imageUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }


  Future<void> saveData(String imageUrl) async {
    final bikeData = {
      'email': _emailController.text,
      'phone': _phoneController.text,
      'image': imageUrl,
    };

    try {
      await userCollection.add(bikeData);
      // Navigator.pop(context);
    } catch (e) {
      print('Error saving data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Information'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 50,
              ),
            )
                : CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(_image!),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            MaterialButton(
              onPressed: () async {
                await uploadImage();
                _emailController.clear();
                _phoneController.clear();
                // userPriceController.clear();

              },
              child: const Text('Update Data'),
              color: Colors.blue,
              textColor: Colors.white,
              minWidth: 300,
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}