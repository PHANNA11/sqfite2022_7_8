import 'dart:io';
import 'dart:math';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite7/view/update_screen.dart';

import '../connection/database_con.dart';
import '../model/user_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  Future<List<User>>? listUser;
  File? imageFile;
  late DatabaseCon db;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DatabaseCon();
    db.intializeDatabase().whenComplete(() {
      setState(() {
        listUser = db.readDatabase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
            // Container(
            //   height: 600,
            //   width: double.infinity,
            //   child: FutureBuilder(
            //     future: listUser,
            //     builder: (context, AsyncSnapshot<List<User>> snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const CircularProgressIndicator();
            //       }
            //       return ListView.builder(
            //         itemCount: snapshot.data!.length,
            //         itemBuilder: (context, index) {
            //           var datadb = snapshot.data![index];
            //           return InkWell(
            //             onTap: () {
            //               Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => UpdateUser(user: datadb),
            //                   ));
            //             },
            //             child: Card(
            //               child: ListTile(
            //                 title: Text(datadb.name),
            //                 trailing: IconButton(
            //                   onPressed: () async {
            //                     print('object');
            //                     await DatabaseCon().deleteDatabase(datadb.id);
            //                   },
            //                   icon: const Icon(Icons.delete, color: Colors.red),
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await DatabaseCon().insertDatabase(User(
              id: Random().nextInt(100),
              name: nameController.text,
              address: adressController.text,
              profileImage: imageFile!.path,
              sex: genderController.text,
              userDOB: dobController.text));
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
