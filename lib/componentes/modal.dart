import 'package:flutter/material.dart';
import 'package:staircase/componentes/snackbar.dart';
import 'package:staircase/model/mensagem.dart';
import 'package:staircase/servicos/mensagem_servico.dart';
import 'package:uuid/uuid.dart';

showModal(BuildContext context, {String? formType, MensagemModelo? mensagem}) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ShowModal(
          formType: formType,
          mensagemModelo: mensagem,
        );
      });
}

class ShowModal extends StatefulWidget {
  final MensagemModelo? mensagemModelo;
  final String? formType;
  const ShowModal({super.key, this.formType, this.mensagemModelo});

  @override
  State<ShowModal> createState() => _ShowModalState();
}

class _ShowModalState extends State<ShowModal> {
  final _formKey = GlobalKey<FormState>();
  var visibilityFieldNome = true;
  var visibilityFieldTexto = true;
  String titulo = "Solicitação";
  String subtitulo = "Escreva o que precisa para o profissional";

  final MensagemServico _mensagemServico = MensagemServico();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _textoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.mensagemModelo != null) {
      _nomeController.text = widget.mensagemModelo!.nome;
      _textoController.text = widget.mensagemModelo!.texto;
    }

    if (widget.formType == "nome") {
      titulo = "Nome";
      subtitulo = "Digite o seu nome";
      visibilityFieldTexto = false;
    } else if (widget.formType == "texto") {
      titulo = "Mensagem";
      subtitulo = "Digite a sua mensagem";
      visibilityFieldNome = false;
    } else if (widget.formType == "excluir") {
      titulo = "Deletar";
      subtitulo = "Você realmente deseja deletar essa mensagem?";
      visibilityFieldNome = false;
      visibilityFieldTexto = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 19, 16, 175),
            ),
          ),
          Text(
            subtitulo,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              Visibility(
                visible: visibilityFieldNome,
                child: TextFormField(
                  controller: _nomeController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "O nome não pode ser vazio";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: "Nome",
                    suffixIcon: IconButton(
                      onPressed: () {
                        _nomeController.text = "";
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color.fromARGB(255, 19, 16, 175),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Visibility(
                visible: visibilityFieldTexto,
                child: TextFormField(
                  controller: _textoController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "A mensagem não pode ser vazia";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    hintText: "Mensagem",
                    suffixIcon: IconButton(
                      onPressed: () {
                        _textoController.text = "";
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Color.fromARGB(255, 19, 16, 175),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  enviarDados();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: const Color.fromARGB(255, 19, 16, 175)),
                child: const Text(
                  "Confirmar",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  side: const BorderSide(
                    color: Color.fromARGB(255, 19, 16, 175),
                    width: 2,
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                child: const Text(
                  "Voltar",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 19, 16, 175),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  enviarDados() async {
    String nome = _nomeController.text;
    String texto = _textoController.text;

    if (widget.formType == "excluir") {
      try {
        await _mensagemServico.removerMensagem(
            idMensagem: widget.mensagemModelo!.id);
        mostrarSnackBAr(
          context: context,
          texto: "Mensagem excluída com sucesso",
          isErro: false,
        );
        Navigator.pop(context);
      } on Exception catch (e) {
        mostrarSnackBAr(context: context, texto: e.toString());
      }
    } else {
      if (_formKey.currentState!.validate()) {
        MensagemModelo mensagemModelo = MensagemModelo(
          id: const Uuid().v1(),
          nome: nome,
          texto: texto,
          data: DateTime.now(),
        );

        if (widget.mensagemModelo != null) {
          mensagemModelo.id = widget.mensagemModelo!.id;
        }

        try {
          await _mensagemServico.adicionarMensagem(mensagemModelo);
          mostrarSnackBAr(
            context: context,
            texto: "Mensagem enviada com sucesso",
            isErro: false,
          );
          Navigator.pop(context);
        } on Exception catch (e) {
          mostrarSnackBAr(context: context, texto: e.toString());
        }
      }
    }
  }
}
