import 'package:flutter/material.dart';
import 'package:staircase/main.dart';
import 'package:staircase/servicos/autenticacao_servico.dart';
import 'package:staircase/componentes/snackbar.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _Cadastro1State();
}

class _Cadastro1State extends State<Cadastro> {
  var _hidepassword;
  final _formKey = GlobalKey<FormState>();
  bool _continuarCadastro = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();

  final AutenticacaoServico _autenticacaoServico = AutenticacaoServico();

  @override
  void initState() {
    super.initState();
    _hidepassword = true;
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
              Padding(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cadastro",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 19, 16, 175),
                      ),
                    ),
                    Text(
                      (_continuarCadastro)
                          ? "Digite seu nome completo e o número do seu Whatsapp"
                          : "Crie sua conta para acessar o app",
                      style: const TextStyle(
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
                  children: [
                    Visibility(
                      visible: !_continuarCadastro,
                      child: Column(
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
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  height: 1),
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
                                  return "A senha não pode ser vazia";
                                } else if (value.length <= 6) {
                                  return "A senha é muito curta";
                                }
                                return null;
                              },
                              obscureText: _hidepassword,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  height: 1),
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  hintText: "Senha",
                                  suffixIcon: IconButton(
                                    padding: const EdgeInsetsDirectional.only(
                                        end: 12.0),
                                    icon: Icon(
                                      _hidepassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: const Color.fromARGB(
                                          255, 19, 16, 175),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _hidepassword = !_hidepassword;
                                      });
                                    },
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _continuarCadastro,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: TextFormField(
                              controller: _nomeController,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "O nome não pode ser vazio";
                                }
                                return null;
                              },
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  height: 1),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                hintText: "Nome",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: TextFormField(
                              controller: _celularController,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return "O whatsapp não pode ser vazio";
                                } else if (value.length < 11) {
                                  return "Númeo de whatsapp muito curto";
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  height: 1),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                hintText: "Whatsapp",
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: !_continuarCadastro,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        botaoContinuar();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: const Color.fromARGB(255, 19, 16, 175),
                      ),
                      child: const Text(
                        "Continuar",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _continuarCadastro,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        botaoFinalizar();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: const Color.fromARGB(255, 19, 16, 175),
                      ),
                      child: const Text(
                        "Finalizar",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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
                    child: Visibility(
                      visible: !_continuarCadastro,
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  botaoContinuar() async{
    String email = _emailController.text;
    String? emailExiste = await
        _autenticacaoServico.verificaEmail(email: email);
    if (emailExiste == "true") {
      mostrarSnackBAr(context: context, texto: "Email já cadastrado");
    }else {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _continuarCadastro = !_continuarCadastro;
        });
      }
    }
  }

  botaoFinalizar() {
    String email = _emailController.text;
    String senha = _senhaController.text;
    String nome = _nomeController.text;
    String celular = _celularController.text;

    if (_formKey.currentState!.validate()) {
      _autenticacaoServico
          .cadastrarUsuario(
        email: email,
        senha: senha,
        nome: nome,
        celular: celular,
      )
          .then(
        (String? erro) {
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
        },
      );
    } else {
      print("Form inválido");
    }
  }
}
