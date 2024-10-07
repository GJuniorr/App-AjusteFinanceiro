import 'package:appmusica/homepage.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {

  int? IDU;
  String usuario = '';
  String senha = '';

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

 Future validarUsuario() async {
    
    var resultado = await conn.execute("Select * from usuarios WHERE Usuario = '$usuario' and Senha = '$senha' ");
    
    var count = resultado.numOfRows;

    if (count > 0) {
       for (var element in resultado.rows) {
        Map data = element.assoc();
        IDU = int.tryParse(data['ID_Usuario']);
          }
      print("O usuário é $usuario e a senha é $senha ");
      Navigator.push(context, 
    MaterialPageRoute(builder: (context) => homepage(
      IDU: IDU
    )));
    }else{
      print("O usuário é $usuario e a senha é $senha ");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro de Login'),
          content: const Text('Usuário ou senha incorretos.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
        );
    }
    
}
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Tela de Login'),
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
              height: 300,
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
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 28.0),
                          child: Column(
                            children: [
                              Text('Não tem uma conta?',
                              style: TextStyle(
                                color: Colors.black
                              ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(Colors.white)
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, 'criarUsuario');
                                }, child: const Text('Cadastrar',
                                style: TextStyle(
                                  color: Colors.black
                                ),),
                                ),
                            ],
                          ),
                        ),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0, top: 25),
                            child: TextButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.white)
                            ),
                            onPressed: () {
                              validarUsuario();
                            }, child: const Text('Entrar',
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
