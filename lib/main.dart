import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: UiAuthorization(),
  ));
}

class UiAuthorization extends StatefulWidget {
  @override
  State<UiAuthorization> createState() => _UiAuthorizationState();
}

class _UiAuthorizationState extends State<UiAuthorization> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Widget sizedBox = const SizedBox(height: 16.0);
  bool isButtonVisible = false;
  bool isSendingData = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(updateButtonVisibility);
    _emailController.addListener(updateButtonVisibility);
    _messageController.addListener(updateButtonVisibility);
  }

  void updateButtonVisibility() {
    setState(() {
      isButtonVisible = _nameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _messageController.text.isNotEmpty &&
          _formKey.currentState!.validate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                _nameController.clear();
                _emailController.clear();
                _messageController.clear();
              },
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
            ),
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 30),
                  child: Text(
                    'Contact us',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(children: [
                //Name field
                method("Name", _nameController, (value) {
                  if (value!.isEmpty) {
                    return "Please enter your name";
                  }
                  () {
                    setState(() {
                      isButtonVisible = true;
                    });
                  };
                  return null;
                }, 1),

                //Email field
                method("Email", _emailController, (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  setState(() {
                    isButtonVisible = true;
                  });
                  return null;
                }, 1),
                sizedBox,

                //Message field
                method("Message", _messageController, (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your message';
                  }
                  setState(() {
                    isButtonVisible = true;
                  });
                  return null;
                }, 3),

                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            isButtonVisible == true
                                ? Colors.purple
                                : Color.fromARGB(255, 216, 160, 226)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0))),
                        minimumSize: MaterialStateProperty.all(
                          const Size(double.infinity, 70),
                        )),
                    onPressed: isButtonVisible
                        ? () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              Map<String, dynamic> formData = {
                                "name": _nameController.text,
                                "email": _emailController.text,
                                "message": _messageController.text,
                              };
                              String jsonData = jsonEncode(formData);
                              setState(() {
                                isSendingData = true;
                              });
                              try {
                                http.Response response = await http.post(
                                  Uri.parse(
                                      "https://api.byteplex.info/api/test/contact/"),
                                  headers: {"Content-Type": "application/json"},
                                  body: jsonData,
                                );
                                if (response.statusCode == 201) {
                                  print('Data sent');
                                } else {
                                  print("Status ${response.statusCode}");
                                }
                              } catch (e) {
                                print('Error sending data -$e');
                              } finally {
                                setState(() {
                                  isSendingData = false;
                                });
                              }

                              print('Form is valid');
                            }
                          }
                        : null,
                    child: Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: (isSendingData) == false
                                    ? Text(
                                        'Send',
                                        style: TextStyle(fontSize: 22),
                                      )
                                    : Text(
                                        'Please wait',
                                        style: TextStyle(fontSize: 22),
                                      ))),
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

method(
  String labelText,
  TextEditingController controller,
  String? Function(String?)? validator,
  int line,
) {
  return Row(
    children: [
      const CircleAvatar(
        radius: 25,
        backgroundColor: Color.fromARGB(255, 243, 227, 209),
        child: Icon(Icons.lock_open_sharp,
            color: Color.fromARGB(255, 199, 163, 122)),
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextFormField(
              maxLines: line,
              controller: controller,
              decoration: InputDecoration(labelText: labelText),
              validator: validator),
        ),
      ),
    ],
  );
}
