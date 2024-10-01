import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:staircase/model/mensagem.dart';

class MensagemServico {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> adicionarMensagem(MensagemModelo mensagemModelo) async {
    await _firestore
        .collection("mensagens")
        .doc(mensagemModelo.id)
        .set(mensagemModelo.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> conectarStreamMensagens() {
    return _firestore
        .collection("mensagens")
        .orderBy("data", descending: true)
        .snapshots();
  }

  Future<void> removerMensagem({required String idMensagem}) {
    return _firestore.collection("mensagens").doc(idMensagem).delete(); 
  }
}
