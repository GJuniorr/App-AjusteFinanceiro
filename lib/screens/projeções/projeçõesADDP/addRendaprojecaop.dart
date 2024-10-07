import 'package:appmusica/screens/proje%C3%A7%C3%B5es/projecaoP.dart';
import 'package:appmusica/screens/rendaPessoal/rendap.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

class Addrendaprojecaop extends StatefulWidget {

  final int? IDU;
  const Addrendaprojecaop({
    super.key, 
    required this.IDU,
    });

  @override
  State<Addrendaprojecaop> createState() => _AddrendaprojecaopState();
}

class _AddrendaprojecaopState extends State<Addrendaprojecaop> {

   int? IDU;
  String usuario = '';
  String origem = '';
  double? valor;
  String categoria = 'Renda';
  String? tipo;

  late MySQLConnection conn;

  @override
  void initState() {
    super.initState();
    getConnection();
    IDU = widget.IDU;
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
      print('Conexão bem sucedida ADD Renda');
      print('ID: $IDU');
    } catch (e) {
      print('Erro ao conectar ao banco de dados: $e');
    }
    await selectRenda();
    setState(() {
      
    });
}

 Future selectRenda()async{
    var resultadoSelect = await conn.execute("Select Usuario from usuarios WHERE ID_Usuario = '$IDU' ");

     for (var element in resultadoSelect.rows) {
        Map data = element.assoc();
        usuario = data['Usuario'];
          }
          print('ID é igual a : $IDU');
          print('Usuario: $usuario');
 }
 

  Future novaRenda()async {

    final Map<String, dynamic> parametros = {'ID_Usuario' :IDU, 'Usuario' :usuario, 'Origem': origem, 'Valor': valor, 'Categoria': categoria, 'Tipo': tipo };


    var resultado =  await conn.execute("Insert into projeçãop(ID_Usuario, Usuario, Origem, Valor, Categoria, Tipo) VALUES (:ID_Usuario, :Usuario, :Origem, :Valor, :Categoria, :Tipo)", parametros);

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Renda'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(onPressed: () {
            
          }, icon: Icon(Icons.help,
          color: Colors.white,))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Tela inicial'),
              onTap: () {
                Navigator.pushNamed(context, 'homepage');
              },
            ),
            ListTile(
              leading: Icon(Icons.badge_sharp),
              title: Text('Compras'),
              onTap: () {
                
              },
            ),
            ListTile(
              leading: Icon(Icons.task_alt),
              title: Text('Tarefas'),
              onTap: () {
                
              },
            ),
          ],
        ),
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
                        onChanged: (valueO) {
                          setState(() {
                            origem = valueO;
                          });
                        },
                        style: const TextStyle(
                          color: Colors.black
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Origem',
                          labelStyle: TextStyle(
                            color: Colors.black
                          ),
                          hintText: 'Ex: Salário',
                          hintStyle: TextStyle(
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
                        onChanged: (valueV) {
                          setState(() {
                            valor = double.tryParse(valueV);
                          });
                        },
                        style: const TextStyle(
                          color: Colors.black
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Valor',
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
                      child: DropdownButton(
                        hint: Text('Tipo',
                        style: TextStyle(
                          color: Colors.white
                        ),),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16
                        ),
                        value: tipo,
                        onChanged: (valueT) {
                          setState(() {
                            tipo = valueT!;
                          });
                          
                        },
                        items: [DropdownMenuItem(
                          value: 'Renda Mensal',
                          child: Text('Renda Mensal')),
                          DropdownMenuItem(child: Text('Renda + do mês'),
                          value: 'Renda + do mês',),
                          ], )
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
                          child: TextButton(
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.white)
                            ),
                            onPressed: () {
                              Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => projecaoP(
                                    IDU: IDU
                                  )));
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
                              novaRenda();
                             Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => projecaoP(
                                    IDU: IDU
                                  )));
                            }, child: const Text('Adicionar',
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
