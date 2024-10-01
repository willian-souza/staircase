import 'package:flutter/material.dart';
import 'package:staircase/model/mensagem.dart';
import 'package:staircase/servicos/autenticacao_servico.dart';
import 'package:staircase/servicos/mensagem_servico.dart';
import 'package:staircase/componentes/modal.dart';

class InicioTela extends StatefulWidget {
  const InicioTela({super.key});

  @override
  State<InicioTela> createState() => _InicioTelaState();
}

class _InicioTelaState extends State<InicioTela> {
  //final _formKey = GlobalKey<FormState>();

  final MensagemServico _mensagemServico = MensagemServico();
  final AutenticacaoServico _autenticacaoServico = AutenticacaoServico();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout), // Ícone de deslogar
            onPressed: () {
              _autenticacaoServico.deslogarUsuario();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModal(context);
        },
        icon: const Icon(Icons.message_rounded),
        label: const Text("Escrever"),
        backgroundColor: const Color.fromARGB(255, 19, 16, 175),
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(30),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Central",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 19, 16, 175),
                    ),
                  ),
                  Text(
                    "Aqui você pode enviar e ler as mensagens",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: StreamBuilder(
                stream: _mensagemServico.conectarStreamMensagens(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Erro ao carregar mensagens'),
                    );
                  } else {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      List<MensagemModelo> listaMensagem = [];

                      for (var doc in snapshot.data!.docs) {
                        listaMensagem.add(MensagemModelo.fromMap(doc.data()));
                      }

                      return ListView(
                          children: List.generate(
                        listaMensagem.length,
                        (index) {
                          MensagemModelo mensagemModelo = listaMensagem[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      mensagemModelo.nome,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showModal(context, formType: "nome", mensagem: mensagemModelo);
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 19, 16, 175),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      mensagemModelo.texto,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showModal(context, formType: "texto", mensagem: mensagemModelo);
                                      },
                                      child: const Icon(
                                        Icons.edit,
                                        color: Color.fromARGB(255, 19, 16, 175),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      mensagemModelo.dataFormatada,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showModal(context, formType: "excluir", mensagem: mensagemModelo);
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text("Deletar"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ));
                    } else {
                      return const Center(
                        child: Text("Nenhum registro foi encontrado"),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
