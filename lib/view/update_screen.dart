import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite7/connection/database_con.dart';

import '../model/user_model.dart';

class UpdateUser extends StatefulWidget {
  UpdateUser({required this.user, Key? key}) : super(key: key);
  User user;

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.text = widget.user.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                // await DatabaseCon().updateDatabase(
                //     User(id: widget.user.id, name: controller.text));
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
              child: const Text('update'))
        ],
      ),
    );
  }
}
