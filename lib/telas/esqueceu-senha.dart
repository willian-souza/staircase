import 'package:flutter/material.dart';
import 'package:staircase/servicos/autenticacao_servico.dart';
import 'package:staircase/componentes/snackbar.dart';

class EsqueceuSenha extends StatefulWidget {
  const EsqueceuSenha({super.key});

  @override
  State<EsqueceuSenha> createState() => _EsqueceuSenhaState();
}

class _EsqueceuSenhaState extends State<EsqueceuSenha> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final AutenticacaoServico _autenticacaoServico = AutenticacaoServico();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Esqueci a Senha",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 16, 175),
                      ),
                    ),
                    Text(
                      "Digite o seu email e a solicitação para redefinir a senha será enviada em seu email",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "O email não pode ser vazio";
                      } else if (!value.contains("@")) {
                        return "Digite um email válido";
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600, height: 1),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      hintText: "Email",
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("Form válido");
                        String email = _emailController.text;
                        _autenticacaoServico
                            .recuperarSenha(email: email)
                            .then((String? erro) {
                          if (erro != null) {
                            mostrarSnackBAr(context: context, texto: erro);
                          } else {
                            mostrarSnackBAr(
                                context: context,
                                texto:
                                    "O email de recuperação de senha foi enviado com sucesso",
                                isErro: false);
                          }
                        });
                      } else {
                        print("Form inválido");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: const Color.fromARGB(255, 19, 16, 175),
                    ),
                    child: const Text(
                      "Enviar",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      "Fazer Login",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 19, 16, 175),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
