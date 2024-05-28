import 'package:appmusica/homepage.dart';
import 'package:appmusica/screens/proje%C3%A7%C3%B5es/projecaoP.dart';
import 'package:appmusica/screens/rendaPessoal/rendap.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

class Adddespesaprojecaop extends StatefulWidget {

  final int? IDU;
  const Adddespesaprojecaop({
    super.key,
    required this.IDU,});

  @override
  State<Adddespesaprojecaop> createState() => _AdddespesaprojecaopState();
}

class _AdddespesaprojecaopState extends State<Adddespesaprojecaop> {

  int? IDU;
  String usuario = '';
  String origem = '';
  double? valor;
  String categoria = 'Despesa';
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
      host: '10.0.2.2',
      port: 3306,
      userName: 'root',
      password: '@Kinafox223',
      databaseName: 'appmultiuso',
    );
    try {
      await conn.connect();
      print('Conexão bem sucedida ADD Despesa');
      print('ID: $IDU');
    } catch (e) {
      print('Erro ao conectar ao banco de dados: $e');
    }
    await selectDespesa();
    setState(() {
      
    });
}

 Future selectDespesa()async{
    var resultadoSelect = await conn.execute("Select Usuario from usuarios WHERE ID_Usuario = '$IDU' ");

     for (var element in resultadoSelect.rows) {
        Map data = element.assoc();
        usuario = data['Usuario'];
          }
          print('ID é igual a : $IDU');
          print('Usuario: $usuario');
 }
 

  Future novaDespesa()async {

    final Map<String, dynamic> parametros = {'ID_Usuario' :IDU, 'Usuario' :usuario, 'Origem': origem, 'Valor': valor, 'Categoria': categoria, 'Tipo': tipo };


    var resultado =  await conn.execute("Insert into projeçãop(ID_Usuario, Usuario, Origem, Valor, Categoria, Tipo) VALUES (:ID_Usuario, :Usuario, :Origem, :Valor, :Categoria, :Tipo)", parametros);
  }
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Projeção Despesa'),
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
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => homepage(
                IDU: IDU
              )));
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
                          hintText: 'Ex: Conta de Luz',
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
                          value: 'Despesa Mensal',
                          child: Text('Despesa Mensal')),
                          DropdownMenuItem(child: Text('Despesa + do mês'),
                          value: 'Despesa + do mês',),
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
                              novaDespesa();
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