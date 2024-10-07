import 'package:appmusica/screens/criarUsuario/criarUsuario.dart';
import 'package:appmusica/screens/proje%C3%A7%C3%B5es/projecaoEMP.dart';
import 'package:appmusica/screens/proje%C3%A7%C3%B5es/projecaoP.dart';
import 'package:appmusica/screens/rendaEmpresarial/rendaemp.dart';
import 'package:appmusica/screens/rendaPessoal/rendap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mysql_client/mysql_client.dart';

class homepage extends StatefulWidget {

  final int? IDU;
  const homepage({
    super.key, 
    required this.IDU,
    });

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {


  bool contaPessoal = false;
  bool contaEmpresarial = false;
  int? IDU;
  String? contaP;
  String? contaEMP;

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
      print('Conexão bem sucedida. O ID do Usuario é: $IDU');
    } catch (e) {
      print('Erro ao conectar ao banco de dados: $e');
    }
    

    var resultadoTU = await conn.execute("Select Pessoal, Empresarial from usuarios where ID_Usuario = '$IDU' ");

     for (var element in resultadoTU.rows) {
        Map data = element.assoc();
        contaP = data['Pessoal'];
        contaEMP = data['Empresarial'];
          }
          print('Conta pessoal $contaP. Conta Empresarial $contaEMP');

          setState(() {
             if (contaP == '1') {
            contaPessoal = true;
            print('Conta Pessoal nova = $contaPessoal');
          }else{
            contaPessoal = false;
            print('Conta Pessoal nova = $contaPessoal');
          }

          if (contaEMP == '1') {
            contaEmpresarial = true;
            print('Conta Empresarial nova = $contaEmpresarial');
          }else{
            contaEmpresarial = false;
            print('Conta Empresarial nova = $contaEmpresarial');

          }
          });
         
}

  Future criarcontaEMP()async {
    try {
    var update = await conn.execute(
      'UPDATE usuarios SET Empresarial = :Empresarial WHERE ID_Usuario = :IDU', 
      {
        'IDU': IDU,
        'Empresarial': 1,
      } );
    print(update.affectedRows);
    await conn.execute('COMMIT');
    print('Dados atualizados com sucesso');

    setState(() {
      contaEmpresarial = true;
    });
     } catch (e) {
      print('Erro ao atualizar dados da Conta Empresarial do usuario: $usuario');
    }

    
  }

   Future criarcontaPessoal()async {

    var update = await conn.execute(
      'UPDATE usuarios SET Pessoal = :Pessoal WHERE ID_Usuario = :IDU', 
      {
        'IDU': IDU,
        'Pessoal': 1,
      } );
    print(update.affectedRows);
    await conn.execute('COMMIT');
    print('Dados salvos com sucesso');

    setState(() {
      contaPessoal = true;
    });
  }

  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Tela inicial'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
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
            if(contaPessoal == true && contaEmpresarial == false)
             ListTile(
              leading: Icon(Icons.timeline),
              title: Text('Projeção conta Pessoal'),
              onTap: () {
                 Navigator.push(context, 
              MaterialPageRoute(builder: (context) => projecaoP(
                IDU: IDU
              )));
              },
            ),
            if(contaEmpresarial == true && contaPessoal == false)
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Projeção conta Empresarial'),
              onTap: () {
                 Navigator.push(context, 
              MaterialPageRoute(builder: (context) => projecaoEMP(
                IDU: IDU
              )));
              },
            ),
            if(contaPessoal == true && contaEmpresarial == true)
            ListTile(
              leading: Icon(Icons.timeline),
              title: Text('Projeção conta Pessoal'),
              onTap: () {
                 Navigator.push(context, 
              MaterialPageRoute(builder: (context) => projecaoP(
                IDU: IDU
              ),
              ),
              );
              },
            ),
             if(contaPessoal == true && contaEmpresarial == true)
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Projeção conta Empresarial'),
              onTap: () {
                 Navigator.push(context, 
              MaterialPageRoute(builder: (context) => projecaoEMP(
                IDU: IDU
              ),
              ),
              );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 80.0,
                bottom: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (contaPessoal == true) {
                         Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => renda(
                            IDU: IDU
                          )));
                      }else{
                        criarcontaPessoal();
                      }
                    }, icon: Icon(
                      contaPessoal ? Icons.home : Icons.add,
                    size: 50,),
                    ),
                    Text('Conta Pessoal')
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (contaEmpresarial == true) {
                         Navigator.push(context, 
                          MaterialPageRoute(builder: (context) => rendaemp(
                            IDU: IDU
                          )));
                      }else{
                        criarcontaEMP();
                      }
                  }, icon: Icon(
                    contaEmpresarial ? Icons.business : Icons.add,
                  size: 50,),
                  ),
                  Text('Conta Empresarial')
              ],
            ),
          ],
        ),
      ),
    );
  }
}
