import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MensagemModelo {
  String id;
  String nome;
  String texto;
  DateTime data;

  MensagemModelo({
    required this.id,
    required this.nome,
    required this.texto,
    required this.data,
  });

  String get dataFormatada {
    return DateFormat('dd/MM/yyy', 'pt_BR').format(data);
  }

  //Método para converter um map para o objeto Mensagem(vindo do banco de dados)
  MensagemModelo.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        nome = map["nome"],
        texto = map["texto"] ?? 'Sem conteúdo',
        data = (map['data'] as Timestamp).toDate();

  //Método para converter um objeto Mensagem em map (enviar para o banco de dados)
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "texto": texto,
      "data": Timestamp.fromDate(data),
    };
  }
}
