import 'dart:developer';

import 'package:assignment/Components/button.dart';
import 'package:assignment/Components/text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _dateOfBirth = TextEditingController();
  String _gender = "Male";
  String name = '';
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _key,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * .03),
              const Text(
                'Add Students Details',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * .03),
              CustomTextField(
                labelText: 'Name',
                hintText: 'Enter Full Name',
                callback: (val) {
                  name = val;
                },
                obsecure: false,
                preIcon: Icons.person,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Enter Name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  try {
                    DateFormat('dd/MM/yyyy').parse(value);
                    return null;
                  } catch (e) {
                    return 'Invalid date format';
                  }
                },
                controller: _dateOfBirth,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  hintText: 'DD/MM/YYYY',
                  suffixIcon: IconButton(
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (picked != null) {
                        setState(() {
                          _dateOfBirth.text =
                              DateFormat('dd/MM/yyyy').format(picked);
                          log(_dateOfBirth.text);
                        });
                      }
                    },
                    icon: const Icon(Icons.date_range_rounded),
                  ),
                  prefixIcon: const Icon(Icons.calendar_view_day_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height / 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: ListTile(
                    leading: Icon(MdiIcons.genderMaleFemale),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Gender',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(_gender)
                      ],
                    ),
                  ),
                ),
              ),
              RadioListTile(
                title: const Text('Male'),
                value: 'Male',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Female'),
                value: 'Female',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              RadioListTile(
                title: const Text('Others'),
                value: 'Others',
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              const SizedBox(height: 30),
              CustomButton(
                icon: Icons.done,
                label: 'Submit',
                voidCallback: () {
                  if (_key.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (ctx) => const AlertDialog(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        content: SizedBox(
                          height: 70,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Colors.white,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Please Wait...",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    CollectionReference collectionReference =
                        FirebaseFirestore.instance.collection('client');
                    collectionReference.add({
                      'name': name,
                      'dob': _dateOfBirth.text,
                      'gender': _gender
                    });

                    Future.delayed(
                      const Duration(seconds: 1),
                      () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green.shade800,
                            content: const Text(
                                'Students Details Added Succesfully'),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
