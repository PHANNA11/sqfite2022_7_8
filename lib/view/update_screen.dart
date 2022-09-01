import 'dart:io';
import 'dart:math';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite7/view/homepages.dart';
import 'package:sqflite7/view/update_screen.dart';

import '../connection/database_con.dart';
import '../model/user_model.dart';

class EditDataScreen extends StatefulWidget {
  EditDataScreen({Key? key, required this.user}) : super(key: key);
  User user;

  @override
  State<EditDataScreen> createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  File? imageFile;
  late DatabaseCon db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DatabaseCon();
    db.intializeDatabase();
    nameController.text = widget.user.name;
    genderController.text = widget.user.sex;
    adressController.text = widget.user.address;
    imageFile = File(widget.user.profileImage);
    dobController.text = widget.user.userDOB;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit'),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      image: imageFile == null
                          ? const DecorationImage(
                              image: AssetImage(
                                  'assets/images/file/def_profile.jpeg'))
                          : DecorationImage(
                              image: FileImage(File(imageFile!.path))),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 10,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          //  color: Colors.red,
                        ),
                        child: Center(
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  takePictureFromCamera();
                                  //getImageFromGallary();
                                });
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 35,
                              )),
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: 'Enter name', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: genderController,
                decoration: const InputDecoration(
                    hintText: 'Enter gender', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: adressController,
                decoration: const InputDecoration(
                    hintText: 'Enter address', border: OutlineInputBorder()),
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: DateTimePicker(
                  controller: dobController,
                  dateMask: 'dd-MM-yyyy',
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  decoration: const InputDecoration(
                      label: Text('Date of Birth'),
                      border: OutlineInputBorder()),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DatabaseCon()
              .updateDatabase(User(
                  id: widget.user.id,
                  name: nameController.text,
                  address: adressController.text,
                  profileImage: imageFile!.path,
                  sex: genderController.text,
                  userDOB: dobController.text))
              .whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false);
          });
        },
        tooltip: 'save',
        child: const Icon(Icons.done),
      ),
    );
  }

  getImageFromGallary() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(file!.path);
    });
  }

  takePictureFromCamera() async {
    var file = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(file!.path);
    });
  }
}
