class ListarContatosBack4AppModel {
  List<ListaContatosBack4AppModel> contato = [];

  ListarContatosBack4AppModel(this.contato);

  ListarContatosBack4AppModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      contato = <ListaContatosBack4AppModel>[];
      json['results'].forEach((v) {
        contato.add(ListaContatosBack4AppModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = contato.map((v) => v.toJson()).toList();
    return data;
  }
}

class ListaContatosBack4AppModel {
  String objectId = "";
  String nome = "";
  String fone = "";
  String foto = "";
  String createdAt = "";
  String updatedAt = "";

  ListaContatosBack4AppModel(this.objectId, this.nome, this.fone, this.foto,
      this.createdAt, this.updatedAt);

  ListaContatosBack4AppModel.criar(
    this.nome,
    this.fone,
    this.foto,
  );

  ListaContatosBack4AppModel.fromJson(Map<String, dynamic> json) {
    objectId = json['objectId'] ?? '';
    nome = json['nome'] ?? '';
    fone = json['fone'] ?? '';
    foto = json['foto'] ?? '';
    createdAt = json['createdAt'] ?? '';
    updatedAt = json['updatedAt'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = objectId;
    data['nome'] = nome;
    data['fone'] = fone;
    data['foto'] = foto;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }

  Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome'] = nome;
    data['fone'] = fone;
    data['foto'] = foto;
    return data;
  }
}
