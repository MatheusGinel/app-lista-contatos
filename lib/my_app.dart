import 'package:applistacontatos/page/lista_contatos_page.dart';
import 'package:applistacontatos/repositories/back4app/contato_back4app_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ContatoBack4AppRepository contatoRepository = ContatoBack4AppRepository();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.purple,
          textTheme: GoogleFonts.robotoTextTheme()),
      home: ListaContatosPage(contatoRepository),
    );
  }
}
