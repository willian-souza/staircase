import 'package:flutter/material.dart';
import 'package:staircase/main.dart';
import 'package:staircase/servicos/autenticacao_servico.dart';
import 'package:staircase/componentes/snackbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _hidePassword;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final AutenticacaoServico _autenticacaoServico = AutenticacaoServico();

  @override
  void initState() {
    super.initState();
    _hidePassword = true;
  }

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
                      "Login",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 16, 175),
                      ),
                    ),
                    Text(
                      "Entre no app para conhecer os profissionais",
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TextFormField(
                        controller: _senhaController,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return "A senha não pode ser vazio";
                          } else if (value.length <= 6) {
                            return "A senha é muito curta";
                          }
                          return null;
                        },
                        obscureText: _hidePassword,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600, height: 1),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50)),
                          hintText: "Senha",
                          suffixIcon: IconButton(
                            padding: const EdgeInsetsDirectional.only(end: 12.0),
                            icon: Icon(
                              _hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: const Color.fromARGB(255, 19, 16, 175),
                            ),
                            onPressed: () {
                              setState(() {
                                _hidePassword = !_hidePassword;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context)
                          .pushReplacementNamed('/esqueceu-senha'),
                      child: const Text(
                        "Esqueceu a senha",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 19, 16, 175),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      botaoEntrar();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      backgroundColor: const Color.fromARGB(255, 19, 16, 175),
                    ),
                    child: const Text(
                      "Entrar",
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
                      Navigator.of(context).pushReplacementNamed('/cadastro');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(10),
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      "Criar conta",
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

  botaoEntrar() {
    String email = _emailController.text;
    String senha = _senhaController.text;
    if (_formKey.currentState!.validate()) {
      _autenticacaoServico
          .logarUsuario(email: email, senha: senha)
          .then((String? erro) {
        if (erro != null) {
          mostrarSnackBAr(context: context, texto: erro);
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const RoteadorTela(),
            ),
          );
        }
      });
    } else {
      print("Form inválido");
    }
  }
}
