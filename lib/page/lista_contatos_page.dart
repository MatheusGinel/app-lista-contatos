// ignore_for_file: use_build_context_synchronously, must_be_immutable

import 'dart:io';
import 'package:applistacontatos/model/lista_contatos_back4app.dart';
import 'package:applistacontatos/page/novo_contato_page.dart';
import 'package:applistacontatos/repositories/back4app/contato_back4app_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListaContatosPage extends StatefulWidget {
  ListaContatosPage(this.contatoRepository, {super.key});

  ContatoBack4AppRepository contatoRepository;

  @override
  State<ListaContatosPage> createState() => _ListaContatosPageState();
}

class _ListaContatosPageState extends State<ListaContatosPage> {
  //ContatoBack4AppRepository contatoRepository = ContatoBack4AppRepository();
  var _listaContatoBack4App = ListarContatosBack4AppModel([]);

  var dio = Dio();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    obterContatos();
  }

  void obterContatos() async {
    setState(() {
      loading = true;
    });
    _listaContatoBack4App = await widget.contatoRepository.obterContato();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Lista de Contatos",
            style: TextStyle(
              fontSize: 18.5,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: FaIcon(
              FontAwesomeIcons.solidAddressBook,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: _listaContatoBack4App.contato.length,
                      itemBuilder: (BuildContext bc, int index) {
                        var contato = _listaContatoBack4App.contato[index];
                        return Dismissible(
                          background: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.red, // Define a cor de fundo aqui
                            alignment: Alignment.centerLeft,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed:
                              (DismissDirection dismissDirection) async {
                            await widget.contatoRepository
                                .remover(contato.objectId);
                            obterContatos();
                            setState(() {});
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                "Contato deletado com sucesso!",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ));
                          },
                          key: Key(contato.objectId),
                          child: Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                color: Colors.amber,
                                elevation: 16,
                                shadowColor: Colors.blue,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  title: Text(
                                    "Nome: ${contato.nome}\nFone: ${contato.fone}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      File(contato.foto),
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      })),
              Visibility(
                  visible: loading, child: const CircularProgressIndicator())
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            //cepController.text = "";
            showDialog(
                context: context,
                builder: (BuildContext bc) {
                  return AlertDialog(
                    title: const Text("Você quer adicionar um novo contato?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancelar")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const NovoContatoPage()));
                          },
                          child: const Text("Novo Contato"))
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
