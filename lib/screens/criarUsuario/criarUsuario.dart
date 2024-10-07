// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';


class criarUsuario extends StatefulWidget {
  const criarUsuario({super.key});

  @override
  State<criarUsuario> createState() => _criarUsuarioState();
}

  String usuario = '';
  String senha = '';
  String email = '';
  bool contaP = false;
  bool contaEMP = false;

class _criarUsuarioState extends State<criarUsuario> {
 
  late MySQLConnection conn;

  @override
  void initState() {
    super.initState();
    getConnection();
  }

  Future getConnection() async {
    conn = await MySQLConnection.createConnection(
      host: '',
      port: ,
      userName: '',
      password: '',
      databaseName: 'appmultiuso',
    );
    try {
      await conn.connect();
      print('Conexão bem sucedida');
    } catch (e) {
      print('Erro ao conectar ao banco de dados: $e');
    }
}

 Future cadastrarUsuario() async {
    try {
    
    final Map<String, dynamic> parametros = {'Usuario': usuario, 'Senha': senha, 'Email': email, 'Pessoal': contaP, 'Empresarial': contaEMP};

    
    await conn.execute('INSERT INTO usuarios (Usuario, Senha, Email, Pessoal, Empresarial) VALUES (:Usuario, :Senha, :Email, :Pessoal, :Empresarial)', parametros);
    await conn.execute('COMMIT');
    print('Usuario cadastrado com sucesso');
  } catch (e) {
    print('Erro ao cadastrar usuario: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(
        title: const Text('Tela de Cadastro'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Container(
              height: 440,
              width: 410,
              color: Colors.lightBlue,
              child:  Column(
                children: [
                  SizedBox(
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: TextField(
                        onChanged: (valueU) {
                          setState(() {
                            usuario = valueU;
                          });
                        },
                        style: const TextStyle(
                          color: Colors.black
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Usuario',
                          labelStyle: TextStyle(
                            color: Colors.black
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder()
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: TextField(
                        onChanged: (valueS) {
                          setState(() {
                            senha = valueS;
                          });
                        },
                        style: const TextStyle(
                          color: Colors.black
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(
                            color: Colors.black
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder()
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: TextField(
                        onChanged: (valueE) {
                          setState(() {
                            email = valueE;
                          });
                        },
                        style: const TextStyle(
                          color: Colors.black
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.black
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder()
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(
                          value: contaP, 
                          onChanged: (valueP) {
                            setState(() {
                              contaP = valueP!;
                            });
                            
                          },
                          ),
                          const Text('Conta Pessoal',
                          style: TextStyle(
                            color: Colors.black
                          ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 70.0),
                            child: Checkbox(
                            value: contaEMP, 
                            onChanged: (valueEMP) {
                              setState(() {
                                contaEMP = valueEMP!;
                              });
                              
                            },
                            ),
                          ),
                          const Text('Conta Empresarial',
                          style: TextStyle(
                            color: Colors.black
                          ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0),
                          child: TextButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.white)
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, 'login');
                            }, child: const Text('Voltar',
                            style: TextStyle(
                              color: Colors.black
                            ),),
                            ),
                        ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: TextButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.white)
                            ),
                            onPressed: () {
                              cadastrarUsuario();
                              Navigator.pushNamed(context, 'login');
                            }, child: const Text('Cadastrar',
                            style: TextStyle(
                              color: Colors.black
                            ),
                            ),
                            ),
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
