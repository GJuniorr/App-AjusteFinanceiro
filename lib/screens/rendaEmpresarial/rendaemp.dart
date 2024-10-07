import 'package:appmusica/homepage.dart';
import 'package:appmusica/screens/proje%C3%A7%C3%B5es/projecaoEMP.dart';
import 'package:appmusica/screens/proje%C3%A7%C3%B5es/projecaoP.dart';
import 'package:appmusica/screens/rendaEmpresarial/adicionarEmpresarial/addDespesaemp.dart';
import 'package:appmusica/screens/rendaEmpresarial/adicionarEmpresarial/addRendaemp.dart';
import 'package:appmusica/screens/rendaPessoal/adcionar/addDespesap.dart';
import 'package:appmusica/screens/rendaPessoal/adcionar/addRendap.dart';
import 'package:flutter/material.dart';
import 'package:mysql_client/mysql_client.dart';

class rendaemp extends StatefulWidget {

  final int? IDU;
  const rendaemp({
    super.key, 
    required this.IDU});

  @override
  State<rendaemp> createState() => _rendaempState();
}

class _rendaempState extends State<rendaemp> {

  bool contaPessoal = false;
  bool contaEmpresarial = false;
  String? contaP;
  String? contaEMP;

   List<Map<String, String>> dadosG = [];

  List<Map<String, String>> dadosRendaADD = [];
  List<Map<String, String>> dadosRendaM = [];
  List<Map<String, String>> dadosRendaADDM = [];

  List<Map<String, String>> dadosDespesaADD = [];
  List<Map<String, String>> dadosDespesaM = [];
  List<Map<String, String>> dadosDespesaADDM = [];

  late int somalist;

   int? rendaID;
   int? IDU;
   String? usuario;
   String? origem;
   double? valor;
   String? categoria;
   String? tipo;

   double somaValoresG = 0.0;

   double somaValoresADDRenda = 0.0;
   double somaValoresMRenda = 0.0;

   double somaValoresADDDespesa = 0.0;
   double somaValoresMDespesa = 0.0;

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
      print('Conexão bem sucedida');
      print('ID: $IDU');
    } catch (e) {
      print('Erro ao conectar ao banco de dados: $e');
    }
    List<Future> futures = [
    selectRenda(),
    carregarDadosG(),
  ];

  // Aguarda a conclusão de todas as futuras
  //await Future.wait(futures);


    setState(() {
      
    }); 
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

  Future selectRenda() async {
       var resultadoSR = await conn.execute("Select * from rendaemp WHERE ID_Usuario = '$IDU' ");

       var count = resultadoSR.numOfRows;
       print('$count');

      if (count > 0) {
        for (var element in resultadoSR.rows) {
        Map data = element.assoc();
        rendaID = int.tryParse(data['ID_RendaEMP']);
        usuario = data['Usuario'];
        origem = data['Origem'];
        valor = double.tryParse(data['Valor']);
        categoria = data['Categoria'];
        tipo = data['Tipo'];
        //somaValoresG += valor!; 
          }
  
        print('O usuario é $usuario');
        //print('A soma dos valores é $somaValores'); // Imprime a soma dos valores

      }else{
        var resultadoSRElse = await conn.execute("Select * from usuarios WHERE ID_Usuario = '$IDU' ");
        for (var element in resultadoSRElse.rows) {
        Map data = element.assoc();
        usuario = data['Usuario'];
        print('O usuario é o  $usuario');
          }
      }
    }

    Future carregarDadosG() async {
    var resultadoDadosG = await conn.execute("SELECT * FROM rendaemp WHERE ID_Usuario = '$IDU' ORDER BY Categoria DESC");
    List<Map<String, String>> listG = [];

    for (final row in resultadoDadosG.rows) {
      final dataG = {
        'ID_RendaEMP': row.colAt(0)!,
        'ID_Usuario': row.colAt(1)!,
        'Usuario': row.colAt(2)!,
        'Origem': row.colAt(3)!,
        'Valor': row.colAt(4)!,
        'Categoria': row.colAt(5)!,
        'Tipo': row.colAt(6)!,
      };
      listG.add(dataG);
    }

    var resultadoDadosADDRenda = await conn.execute("SELECT * FROM rendaemp WHERE ID_Usuario = '$IDU' AND Tipo = 'Renda+do mês'  ORDER BY Valor DESC"); 
    List<Map<String, String>> listADDRenda = [];

    for (final row in resultadoDadosADDRenda.rows) {
      final dataADDRenda = {
        'ID_RendaEMP': row.colAt(0)!,
        'ID_Usuario': row.colAt(1)!,
        'Usuario': row.colAt(2)!,
        'Origem': row.colAt(3)!,
        'Valor': row.colAt(4)!,
        'Categoria': row.colAt(5)!,
        'Tipo': row.colAt(6)!,
      };
      listADDRenda.add(dataADDRenda);
    }

    for (var element in resultadoDadosADDRenda.rows) {
        Map data = element.assoc();
        rendaID = int.tryParse(data['ID_RendaEMP']);
        usuario = data['Usuario'];
        origem = data['Origem'];
        valor = double.tryParse(data['Valor']);
        categoria = data['Categoria'];
        tipo = data['Tipo'];
        somaValoresADDRenda += valor!;
          }

    var resultadoDadosRendaMensal = await conn.execute("SELECT * FROM rendaemp WHERE ID_Usuario = '$IDU' AND Tipo = 'Renda Mensal'  ORDER BY Valor DESC");

    List<Map<String, String>> listRendaMensal = [];

    for (final row in resultadoDadosRendaMensal.rows) {
      final dataRendaM = {
        'ID_RendaEMP': row.colAt(0)!,
        'ID_Usuario': row.colAt(1)!,
        'Usuario': row.colAt(2)!,
        'Origem': row.colAt(3)!,
        'Valor': row.colAt(4)!,
        'Categoria': row.colAt(5)!,
        'Tipo': row.colAt(6)!,
      };
      listRendaMensal.add(dataRendaM);
    }

    for (var element in resultadoDadosRendaMensal.rows) {
        Map data = element.assoc();
        rendaID = int.tryParse(data['ID_RendaEMP']);
        usuario = data['Usuario'];
        origem = data['Origem'];
        valor = double.tryParse(data['Valor']);
        categoria = data['Categoria'];
        tipo = data['Tipo'];
        somaValoresMRenda += valor!;
          }

    var resultadoDadosADDRendaM = await conn.execute("SELECT * FROM rendaemp WHERE ID_Usuario = '$IDU' AND Categoria = 'Renda'  ORDER BY Valor DESC");

    List<Map<String, String>> listADDRendaM = [];

    for (final row in resultadoDadosADDRendaM.rows) {
      final dataADDRendaM = {
        'ID_RendaEMP': row.colAt(0)!,
        'ID_Usuario': row.colAt(1)!,
        'Usuario': row.colAt(2)!,
        'Origem': row.colAt(3)!,
        'Valor': row.colAt(4)!,
        'Categoria': row.colAt(5)!,
        'Tipo': row.colAt(6)!,
      };
      listADDRendaM.add(dataADDRendaM);
    }

    var resultadoDadosADDDespesa = await conn.execute("SELECT * FROM rendaemp WHERE ID_Usuario = '$IDU' AND Tipo = 'Despesa+do mês'  ORDER BY Valor DESC");

    List<Map<String, String>> listADDDespesa = [];

    for (final row in resultadoDadosADDDespesa.rows) {
      final dataADDDespesa = {
        'ID_RendaEMP': row.colAt(0)!,
        'ID_Usuario': row.colAt(1)!,
        'Usuario': row.colAt(2)!,
        'Origem': row.colAt(3)!,
        'Valor': row.colAt(4)!,
        'Categoria': row.colAt(5)!,
        'Tipo': row.colAt(6)!,
      };
      listADDDespesa.add(dataADDDespesa);
    }

     for (var element in resultadoDadosADDDespesa.rows) {
        Map data = element.assoc();
        rendaID = int.tryParse(data['ID_RendaEMP']);
        usuario = data['Usuario'];
        origem = data['Origem'];
        valor = double.tryParse(data['Valor']);
        categoria = data['Categoria'];
        tipo = data['Tipo'];
        somaValoresADDDespesa += valor!;
          }

    var resultadoDadosDespesaM = await conn.execute("SELECT * FROM rendaemp WHERE ID_Usuario = '$IDU' AND Tipo = 'Despesa Mensal'  ORDER BY Valor DESC");

    List<Map<String, String>> listDespesaM = [];

    for (final row in resultadoDadosDespesaM.rows) {
      final dataDespesaM = {
        'ID_RendaEMP': row.colAt(0)!,
        'ID_Usuario': row.colAt(1)!,
        'Usuario': row.colAt(2)!,
        'Origem': row.colAt(3)!,
        'Valor': row.colAt(4)!,
        'Categoria': row.colAt(5)!,
        'Tipo': row.colAt(6)!,
      };
      listDespesaM.add(dataDespesaM);
    }

     for (var element in resultadoDadosDespesaM.rows) {
        Map data = element.assoc();
        rendaID = int.tryParse(data['ID_RendaEMP']);
        usuario = data['Usuario'];
        origem = data['Origem'];
        valor = double.tryParse(data['Valor']);
        categoria = data['Categoria'];
        tipo = data['Tipo'];
        somaValoresMDespesa += valor!;
          }

    var resultadoDadosADDDespesaM = await conn.execute("SELECT * FROM rendaemp WHERE ID_Usuario = '$IDU' AND Categoria = 'Despesa'  ORDER BY Valor DESC");

    List<Map<String, String>> listADDDespesaM = [];

    for (final row in resultadoDadosADDDespesaM.rows) {
      final dataADDDespesaM = {
        'ID_RendaEMP': row.colAt(0)!,
        'ID_Usuario': row.colAt(1)!,
        'Usuario': row.colAt(2)!,
        'Origem': row.colAt(3)!,
        'Valor': row.colAt(4)!,
        'Categoria': row.colAt(5)!,
        'Tipo': row.colAt(6)!,
      };
      listADDDespesaM.add(dataADDDespesaM);
    }

    setState(() {
      dadosDespesaADDM = listADDDespesaM;
    });

    setState(() {
      dadosG = listG;
      dadosRendaADD = listADDRenda;
      dadosRendaM = listRendaMensal;
      dadosRendaADDM = listADDRendaM;
      dadosDespesaADD = listADDDespesa;
      dadosDespesaM = listDespesaM;
      dadosDespesaADDM = listADDDespesaM;
    });
  }

  Future removerItem(int rendaID)async {

      var res = await conn.execute(
      "DELETE FROM rendaemp WHERE ID_RendaEMP = :ID_RendaEMP ",
      {
        'ID_RendaEMP': rendaID,
      },
    );

    for (var element in res.rows) {
        Map data = element.assoc();
        rendaID = int.tryParse(data['ID_RendaEMP'])!;
          }
    print(res.affectedRows);
    await carregarDadosG();
    await selectRenda();
    setState(() {
      
    });
    

  }


    bool rendaDMes = false;
    bool rendaPMes = false;

    bool despesaDMes = false;
    bool despesaPMes = false;

    bool geral = true; // Botão "Geral"
    bool rendaMensal = false; // Botão "Renda Mensal"
    bool rendaAdicional = false; // "Botão Renda +do mês"

    bool despesaAdicional = false; // Botão "Despesa +do mês"
    bool despesaMensal = false; // Botão "Despesa mensal"
  @override
  Widget build(BuildContext context) {
     Widget listViewWidget = ListView.builder(
      itemCount: dadosG.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            color: dadosG[index]['Categoria'] == 'Renda' ? Colors.green : Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${dadosG[index]['Origem'] ?? ''} /',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${dadosG[index]['Tipo'] ?? ''} /',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    'R\$ ${dadosG[index]['Valor'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
     if (geral == true) {
    listViewWidget = ListView.builder(
      itemCount: dadosG.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            color: dadosG[index]['Categoria'] == 'Renda' ? Colors.green : Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${dadosG[index]['Origem'] ?? ''} /',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${dadosG[index]['Tipo'] ?? ''} /',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    'R\$ ${dadosG[index]['Valor'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  } else if (rendaDMes == true && rendaPMes == false) {
    listViewWidget = ListView.builder(
      itemCount: dadosRendaADD.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${dadosRendaADD[index]['Origem'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${dadosRendaADD[index]['Tipo'] ?? ''}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Text(
                    'R\$ ${dadosRendaADD[index]['Valor'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                   showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Apagar Renda',
                        textAlign: TextAlign.center,),
                        actions: [
                          Text('Tem certeza que deseja apagar esta Renda?'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, child: Text('Voltar'),
                                ),
                                TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                    await removerItem(int.parse(dadosRendaADD[index]['ID_RendaEMP']!));
                                }, child: Text('Apagar'),
                                ),
                            ],
                          )
                        ],
                      );
                    }
                   );
                  
                  }, icon: Icon(Icons.remove,
                  color: Colors.black,))
              ],
            ),
          ),
        );
      },
    );
  } else if (rendaPMes == true && rendaDMes == false) {
    listViewWidget = ListView.builder(
      itemCount: dadosRendaM.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${dadosRendaM[index]['Origem'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${dadosRendaM[index]['Tipo'] ?? ''}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Text(
                    'R\$ ${dadosRendaM[index]['Valor'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                   showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Apagar Renda',
                        textAlign: TextAlign.center,),
                        actions: [
                          Text('Tem certeza que deseja apagar esta Renda?'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, child: Text('Voltar'),
                                ),
                                TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                   await removerItem(int.parse(dadosRendaM[index]['ID_RendaEMP']!));
                                }, child: Text('Apagar'),
                                ),
                            ],
                          )
                        ],
                      );
                    }
                   );
                  
                  }, icon: Icon(Icons.remove,
                  color: Colors.black,))
              ],
            ),
          ),
        );
      },
    );
  } else if (rendaPMes == true && rendaDMes == true) {
    listViewWidget = ListView.builder(
      itemCount: dadosRendaADDM.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${dadosRendaADDM[index]['Origem'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${dadosRendaADDM[index]['Tipo'] ?? ''}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Text(
                    'R\$ ${dadosRendaADDM[index]['Valor'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                   showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Apagar Renda',
                        textAlign: TextAlign.center,),
                        actions: [
                          Text('Tem certeza que deseja apagar esta Renda?'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, child: Text('Voltar'),
                                ),
                                TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                   await removerItem(int.parse(dadosRendaADDM[index]['ID_RendaEMP']!));
                                }, child: Text('Apagar'),
                                ),
                            ],
                          )
                        ],
                      );
                    }
                   );
                  
                  }, icon: Icon(Icons.remove,
                  color: Colors.black,))
              ],
            ),
          ),
        );
      },
    );
  } else if(despesaDMes == true && despesaPMes == false){
    listViewWidget = ListView.builder(
      itemCount: dadosDespesaADD.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${dadosDespesaADD[index]['Origem'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${dadosDespesaADD[index]['Tipo'] ?? ''}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Text(
                    'R\$ ${dadosDespesaADD[index]['Valor'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                   showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Apagar Despesa',
                        textAlign: TextAlign.center,),
                        actions: [
                          Text('Tem certeza que deseja apagar esta Despesa?'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, child: Text('Voltar'),
                                ),
                                TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                   await removerItem(int.parse(dadosDespesaADD[index]['ID_RendaEMP']!));
                                }, child: Text('Apagar'),
                                ),
                            ],
                          )
                        ],
                      );
                    }
                   );
                  
                  }, icon: Icon(Icons.remove,
                  color: Colors.black,))
              ],
            ),
          ),
        );
      },
    );
  } else if(despesaPMes == true && despesaDMes == false){
    listViewWidget = ListView.builder(
      itemCount: dadosDespesaM.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${dadosDespesaM[index]['Origem'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${dadosDespesaM[index]['Tipo'] ?? ''}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Text(
                    'R\$ ${dadosDespesaM[index]['Valor'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                   showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Apagar Despesa',
                        textAlign: TextAlign.center,),
                        actions: [
                          Text('Tem certeza que deseja apagar esta Despesa?'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, child: Text('Voltar'),
                                ),
                                TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await removerItem(int.parse(dadosDespesaM[index]['ID_RendaEMP']!));
                                }, child: Text('Apagar'),
                                ),
                            ],
                          )
                        ],
                      );
                    }
                   );
                  
                  }, icon: Icon(Icons.remove,
                  color: Colors.black,))
              ],
            ),
          ),
        );
      },
    );
  } else if(despesaPMes == true && despesaDMes == true){
    listViewWidget = ListView.builder(
      itemCount: dadosDespesaADDM.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Container(
            color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    '${dadosDespesaADDM[index]['Origem'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${dadosDespesaADDM[index]['Tipo'] ?? ''}',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text(
                    'R\$ ${dadosDespesaADDM[index]['Valor'] ?? ''}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                   showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        title: Text('Apagar Despesa',
                        textAlign: TextAlign.center,),
                        actions: [
                          Text('Tem certeza que deseja apagar esta Despesa?'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                }, child: Text('Voltar'),
                                ),
                                TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await removerItem(int.parse(dadosDespesaADDM[index]['ID_RendaEMP']!));
                                }, child: Text('Apagar'),
                                ),
                            ],
                          )
                        ],
                      );
                    }
                   );
                  
                  }, icon: Icon(Icons.remove,
                  color: Colors.black,))
              ],
            ),
          ),
        );
      },
    );
  } 

    somaValoresG = somaValoresMRenda - somaValoresMDespesa;
    return Scaffold(
      appBar: AppBar(
        title: Text('Financeiro'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(onPressed: () {
            showDialog(
              context: context, 
              builder: (context) {
                return AlertDialog(
                  title: Column(
                    children: [
                      Text('"+do mês"',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('É a Renda ou Despesa adicional desse mês',
                      style: TextStyle(
                        fontSize: 16
                      ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            }, child: Text('Voltar',
                            style: TextStyle(
                              color: Colors.white
                            ),),
                            ),
                             TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context, 
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Saldo do mês',
                                    textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      Text('É o calculo feito SOMENTE com a Renda e Despesa fixa mensalmente'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                       Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          }, child: Text('Fechar',
                                          style: TextStyle(
                                            color: Colors.white
                                          ),),
                                          ),
                                    ],
                                       )
                                    ]
                                  );
                                },
                                );
                            }, child: Text('Próximo',
                            style: TextStyle(
                              color: Colors.white
                            ),),
                            ),
                        ],
                      )
                    ],
                  ),
                  
                );
              },);
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
                height: 212,
                width: 412,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person,
                        color: Colors.black,
                        size: 40,),
                        SizedBox(
                          width: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text('$usuario',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15
                          ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                               IconButton(
                                onPressed: () {
                                  Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => addrendaemp(
                                    IDU: IDU
                                  )));
                                }, icon: Icon(Icons.add,
                                color: Colors.black,)),
                              Container(
                                width: 140,
                                height: 42,
                                color: Colors.green,
                                child: Column(
                                  children: [
                                    Text('Renda +do mês',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                    ),
                                    ),
                                    Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text('R\$ $somaValoresADDRenda',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              ),
                              ),
                                ],
                              ),
                              ),
                            ],
                          ),
                              Padding(
                                padding: const EdgeInsets.only(right: 0.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 42,
                                      color: Colors.redAccent[400],
                                      child: Column(
                                        children: [
                                          Text('Despesa +do mês',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15
                                          ),
                                          ),
                                          Text('R\$ $somaValoresADDDespesa',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15
                                          ),
                                          ),
                                        ],
                                      ),
                                    ),
                                     IconButton(
                                onPressed: () {
                                   Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => addDespesaemp(
                                    IDU: IDU
                                  )));
                                }, icon: Icon(Icons.add,
                                color: Colors.black,))
                                  ],
                                ),
                              ),
                        ],
                      ),
                  ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                               IconButton(
                                onPressed: () {
                                  Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => addrendaemp(
                                    IDU: IDU
                                  )));
                                }, icon: Icon(Icons.add,
                                color: Colors.black,)),
                              Container(
                                width: 140,
                                height: 42,
                                color: Colors.green,
                                child: Column(
                                  children: [
                                    Text('Renda por mês',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15
                                    ),
                                    ),
                                    Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text('R\$ $somaValoresMRenda',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              ),
                                ),
                                  ],
                                ),
                              ),
                              
                            ],
                          ),
                          Padding(
                                padding: const EdgeInsets.only(right: 0.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 140,
                                      height: 42,
                                      color: Colors.redAccent[400],
                                      child: Column(
                                        children: [
                                          Text('Despesa por mês',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15
                                          ),
                                          ),
                                          Text('R\$ $somaValoresMDespesa',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15
                                          ),
                                          ),
                                        ],
                                      ),
                                    ),
                                     IconButton(
                                onPressed: () {
                                   Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => addDespesaemp(
                                    IDU: IDU
                                  )));
                                }, icon: Icon(Icons.add,
                                color: Colors.black,))
                                  ],
                                ),
                              ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 130.0),
                      child: Row(
                        children: [
                          Container(
                            width: 140,
                            height: 42,
                            alignment: Alignment.topCenter,
                            color: Colors.green,
                            child: Column(
                              children: [
                                Text('Saldo do mês',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                                ),
                                ),
                                Text('R\$ $somaValoresG',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15
                                ),)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 403,
                width: 412,
                color: Colors.grey,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          geral = true;
                          rendaDMes = false;
                          rendaPMes = false;
                          despesaPMes = false;
                          despesaDMes = false;
                        });
                      }, child: Text('Geral',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                      ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Container(
                            height: 100,
                            width: 205,
                            color: Colors.green,
                            child: Column(
                              children: [
                                TextButton(
                              onPressed: () {
                                setState(() {
                                  rendaDMes = !rendaDMes;
                                  despesaPMes = false;
                                  despesaDMes = false;
                                  geral = false;
                                });
                                print('Renda+do mês $rendaDMes. Renda Mensal $rendaPMes');
                              }, child: Text('Renda +do mês',
                               style: TextStyle(
                              color: rendaDMes ? Colors.lightGreenAccent : Colors.white,
                              fontSize: 20
                              ),
                              ),
                              ),
                              TextButton(
                              onPressed: () {
                                setState(() {
                                  rendaPMes = !rendaPMes;
                                  despesaPMes = false;
                                  despesaDMes = false;
                                  geral = false;
                                });
                              }, child: Text('Renda por mês',
                               style: TextStyle(
                              color: rendaPMes ? Colors.lightGreenAccent : Colors.white,
                              fontSize: 20
                              ),
                              ),
                              ),
                              ],
                            )
                          ),
                        ),
                         Padding(
                           padding: const EdgeInsets.only(right: 0.0),
                           child: Container(
                            height: 100,
                            width: 205,
                            color: Colors.redAccent[400],
                            child: Column(
                              children: [
                            TextButton(
                            onPressed: () {
                              setState(() {
                                despesaDMes = !despesaDMes;
                                rendaPMes = false;
                                rendaDMes = false;
                                geral = false;
                              });
                            }, child: Text('Despesa +do mês',
                            style: TextStyle(
                            color: despesaDMes ? Colors.red[100] : Colors.white,
                            fontSize: 20
                            ),
                            ),
                            ),
                             TextButton(
                            onPressed: () {
                              setState(() {
                                despesaPMes = !despesaPMes;
                                rendaPMes = false;
                                rendaDMes = false;
                                geral = false;
                              });
                            }, child: Text('Despesa por mês',
                            style: TextStyle(
                            color: despesaPMes ? Colors.red[100] : Colors.white,
                            fontSize: 20
                            ),
                            ),
                            ),
                              ],
                            ),
                           ),
                         )
                      ],
                    ),
                   Expanded(
                     child: Container(
                      width: 410,
                      height: 255,
                      color: Colors.white,
                      child: listViewWidget
                     ),
                   ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
