import 'package:appmusica/screens/proje%C3%A7%C3%B5es/proje%C3%A7%C3%B5esADDEMP/addDespesaprojecaoemp.dart';
import 'package:appmusica/screens/proje%C3%A7%C3%B5es/proje%C3%A7%C3%B5esADDEMP/addRendaprojecaoemp.dart';
import 'package:appmusica/screens/proje%C3%A7%C3%B5es/proje%C3%A7%C3%B5esADDP/addDespesaprojecaop.dart';
import 'package:appmusica/screens/proje%C3%A7%C3%B5es/proje%C3%A7%C3%B5esADDP/addRendaprojecaop.dart';
import 'package:appmusica/screens/proje%C3%A7%C3%B5es/projecaoEMP.dart';
import 'package:appmusica/screens/proje%C3%A7%C3%B5es/projecaoP.dart';
import 'package:appmusica/screens/rendaEmpresarial/adicionarEmpresarial/addDespesaemp.dart';
import 'package:appmusica/screens/rendaEmpresarial/adicionarEmpresarial/addRendaemp.dart';
import 'package:appmusica/screens/rendaEmpresarial/rendaemp.dart';
import 'package:appmusica/screens/rendaPessoal/adcionar/addDespesap.dart';
import 'package:appmusica/screens/rendaPessoal/adcionar/addRendap.dart';
import 'package:appmusica/screens/criarUsuario/criarUsuario.dart';
import 'package:appmusica/homepage.dart';
import 'package:appmusica/login.dart';
import 'package:appmusica/screens/rendaPessoal/rendap.dart';
import 'package:flutter/material.dart';

class app_widget extends StatefulWidget {
  const app_widget({super.key});

  @override
  State<app_widget> createState() => _app_widgetState();
}

class _app_widgetState extends State<app_widget> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: 'login',
      routes: {
        'criarUsuario': (context) => criarUsuario(),
        'login': (context) => login(),
        'homepage':(context) => homepage(
          IDU: 0,
        ),
        'renda': (context) => renda(
          IDU: 0,
        ),
        'addRenda': (context) => addRenda(
          IDU: 0,
        ),
        'addDespesa': (context) => addDespesa(
          IDU: 0
          ),
          'rendaemp': (context) => rendaemp(
            IDU: 0
          ),
          'addDespesaemp': (context) => addDespesaemp(
            IDU: 0
          ),
          'addRendaemp': (context) => addrendaemp(
            IDU: 0
          ),
          'projecaoP': (context) => projecaoP(
            IDU: 0
          ),
          'addDespesaprojecaop': (context) => Adddespesaprojecaop(
            IDU: 0
          ),
          'addRendaprojecaop': (context) => Addrendaprojecaop(
            IDU: 0
          ),
          'projecaoEMP': (context) => projecaoEMP(
            IDU: 0
          ),
          'addDespesaprojecaoemp': (context) => Adddespesaprojecaoemp(
            IDU: 0
          ),
          'addRendaprojecaoemp': (context) => Addrendaprojecaoemp(
            IDU: 0
          ),
      },
    );
  }
}