import 'dart:io';

import 'package:contatos/helpers/contact_help.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  ContactPage({this.contact});
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editContact;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _userEdit = false;
  final _nameFocus = FocusNode();
  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editContact = Contact();
    } else {
      _editContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editContact.name;
      _emailController.text = _editContact.email;
      _phoneController.text = _editContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _editContact.name ?? "Novo Contato",
          ),
          centerTitle: true,
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editContact.img != null
                              ? FileImage(File(_editContact.img))
                              : AssetImage("images/person.png"))),
                ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return BottomSheet(
                            onClosing: () {},
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: FlatButton(
                                        onPressed: () {
                                          ImagePicker.pickImage(
                                                  source: ImageSource.camera)
                                              .then((file) {
                                            if (file == null) return;
                                            setState(() {
                                              _editContact.img = file.path;
                                            });
                                          });
                                        },
                                        child: Text(
                                          "Tirar Foto",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: FlatButton(
                                        onPressed: () {
                                          ImagePicker.pickImage(
                                                  source: ImageSource.gallery)
                                              .then((file) {
                                            if (file == null) return;
                                            setState(() {
                                              _editContact.img = file.path;
                                            });
                                          });
                                        },
                                        child: Text(
                                          "Galeria",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      });
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(
                  labelText: "Nome",
                ),
                onChanged: (text) {
                  _userEdit = true;
                  setState(() {
                    _editContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "email",
                ),
                onChanged: (text) {
                  _userEdit = true;
                  _editContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "phone",
                ),
                onChanged: (text) {
                  _userEdit = true;
                  _editContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
          onPressed: () {
            if (_editContact.name != null && _editContact.name.isNotEmpty) {
              Navigator.pop(context, _editContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdit) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
