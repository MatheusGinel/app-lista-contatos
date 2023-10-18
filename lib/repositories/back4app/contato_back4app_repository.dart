import 'package:applistacontatos/model/lista_contatos_back4app.dart';
import 'package:applistacontatos/repositories/back4app/back4app_custon_dio.dart';

class ContatoBack4AppRepository {
  final _custonDio = Back4AppCustonDio();

  ContatoBack4AppRepository();

  Future<ListarContatosBack4AppModel> obterContato() async {
    var url = "/Contato";
    var result = await _custonDio.dio.get(url);
    return ListarContatosBack4AppModel.fromJson(result.data);
  }

  Future<void> criar(
      ListaContatosBack4AppModel listaContatosBack4AppModel) async {
    try {
      await _custonDio.dio
          .post("/Contato", data: listaContatosBack4AppModel.toJsonEndpoint());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizar(
      ListaContatosBack4AppModel listaContatosBack4AppModel) async {
    try {
      await _custonDio.dio.put(
          "/Contato/${listaContatosBack4AppModel.objectId}",
          data: listaContatosBack4AppModel.toJsonEndpoint());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      await _custonDio.dio.delete(
        "/Contato/$objectId",
      );
    } catch (e) {
      rethrow;
    }
  }
}
