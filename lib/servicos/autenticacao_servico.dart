import 'package:firebase_auth/firebase_auth.dart';

class AutenticacaoServico {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> verificaEmail({required String email}) async {
    try {
      //Tenta criar o usuario temporariamente apenas para verificar o email
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: "senhaAleatoriaparaVerificarEmail123456@!#",
      );
      //Deleta o usuário temporario para nao fazer o cadastro
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
      }
      // Retorna false informando que o email nao existe
      return "false";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        //Retorna true caso o email já existe
        return "true";
      } else {
        return null;
      }
    }
  }

  Future<String?> cadastrarUsuario({
    required String email,
    required String senha,
    required String nome,
    required String celular,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );

      await userCredential.user!.updateDisplayName(nome);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "O usuário já está cadastrado";
      }
      return "Erro desconhecido";
    }
  }

  Future<String?> logarUsuario(
      {required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> deslogarUsuario() async {
    return _firebaseAuth.signOut();
  }

  Future<String?> recuperarSenha({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future usuarioLogado() async {
    if (_firebaseAuth.currentUser != null) {
      return true;
    }
  }
}
