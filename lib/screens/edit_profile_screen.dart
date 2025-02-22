import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalchat/providers/userProvider.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameText = TextEditingController();
  var editProfileForm = GlobalKey<FormState>();
  var db = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    nameText.text = Provider.of<UserProvider>(context, listen: false).userName;
    super.initState();
  }

  void updateData() {
    Map<String, dynamic> dataToUpdate = {
      "name": nameText.text,
    };
    db
        .collection('users')
        .doc(Provider.of<UserProvider>(context, listen: false).userId)
        .update(dataToUpdate);
    Provider.of<UserProvider>(context, listen: false).getUserDetail();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          InkWell(
              onTap: () {
                if (editProfileForm.currentState!.validate()) {
                  updateData();
                }
              },
              child: Icon(Icons.check)),
        ],
      ),
      body: Container(
        width: double.infinity,
        child: Form(
          key: editProfileForm,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                  },
                  controller: nameText,
                  decoration: InputDecoration(
                    label: Text('Name'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
