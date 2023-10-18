// ignore_for_file: use_build_context_synchronously, prefer_final_fields, unused_field, depend_on_referenced_packages

import 'dart:io';
import 'package:applistacontatos/model/lista_contatos_back4app.dart';
import 'package:applistacontatos/repositories/back4app/back4app_custon_dio.dart';
import 'package:applistacontatos/repositories/back4app/contato_back4app_repository.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class NovoContatoPage extends StatefulWidget {
  const NovoContatoPage({super.key});

  @override
  State<NovoContatoPage> createState() => _NovoContatoPageState();
}

class _NovoContatoPageState extends State<NovoContatoPage> {
  var nomeController = TextEditingController();
  var foneController = TextEditingController();
  var _listaContatoBack4App = ListarContatosBack4AppModel([]);
  final _custonDio = Back4AppCustonDio();
  ContatoBack4AppRepository contatoRepository = ContatoBack4AppRepository();

  XFile? photo;
  var dio = Dio();
  bool loading = false;

  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
      photo = XFile(croppedFile.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Novo Contato",
            style: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Nome:",
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                maxLength: 24,
                controller: nomeController,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Telefone:",
                style: TextStyle(fontSize: 20),
              ),
              TextField(
                controller: foneController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  TelefoneInputFormatter(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  photo = await picker.pickImage(source: ImageSource.camera);
                  cropImage(photo!);
                  setState(() {});
                },
                child: const Text("Nova Foto"),
              ),
              OutlinedButton(
                onPressed: () async {
                  final ImagePicker picker = ImagePicker();
                  photo = await picker.pickImage(source: ImageSource.gallery);
                  cropImage(photo!);
                  setState(() {});
                },
                child: const Text("Adicionar Foto da Galeria"),
              ),
              const SizedBox(
                height: 10,
              ),
              photo != null
                  ? Center(
                      child: Image.file(
                        File(photo!.path),
                        alignment: Alignment.center,
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: () async {
                  if (photo != null &&
                      nomeController.text.isNotEmpty &&
                      foneController.text.isNotEmpty) {
                    try {
                      await contatoRepository.criar(
                        ListaContatosBack4AppModel.criar(
                          nomeController.text,
                          foneController.text,
                          photo!.path,
                        ),
                      );
                      setState(() {});
                      Navigator.pop(context, true);

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "Contato criado com sucesso",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "Erro ao criar o contato! Confira os dados",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                        "Preencha todos os campos e adicione uma foto",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ));
                  }
                },
                child: const Text(
                  "Salvar",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.red,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
