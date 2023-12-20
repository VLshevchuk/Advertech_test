import 'package:flutter/material.dart';

class Test {
  late String name;
  late String email;
  late String message;
  Test({required name, required email, required message});
}

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
                Row(
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
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: "Name"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter your name";
                            }
                            setState(() {
                              isButtonVisible = true;
                            });
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                sizedBox,
                Row(
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
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            setState(() {
                              isButtonVisible = true;
                            });
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
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
                          controller: _messageController,
                          maxLines: 3,
                          decoration:
                              const InputDecoration(labelText: 'Message'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your message';
                            }
                            setState(() {
                              isButtonVisible = true;
                            });
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // isButtonVisible == true
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
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              // Валидация прошла успешно, выполните необходимые действия
                              print('Form is valid');
                            }
                          }
                        : null,
                    child: const Row(
                      children: [
                        Expanded(
                            child: Center(
                                child: Text(
                          'Send',
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
