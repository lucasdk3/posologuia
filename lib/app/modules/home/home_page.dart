import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:posologuia/app/modules/base/base_controller.dart';
import 'package:posologuia/app/utils/theme.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'home_controller.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key key, this.title = "Prescrição"}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ModularState<HomePage, HomeController> {
  //use 'controller' variable to access controller

  @override
  Widget build(BuildContext context) {
    final baseController = Provider.of<BaseController>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title, style: appBarText),
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                icon: Icon(LineAwesomeIcons.eraser, color: primary),
                onPressed: () {
                  baseController.apresentacao = null;
                  baseController.nome = null;
                  baseController.classe = null;
                  controller.idadeController.text = '';
                  controller.pesoController.text = '';
                  setState(() {});
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: 800),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  forms(),
                  SizedBox(height: 24),
                  button()
                ],
              ),
            ),
          ),
        ));
  }

  Widget textForm(
      {BuildContext context,
      TextEditingController controller,
      String validator,
      String hint,
      onChanged}) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: (input) => input.isEmpty ? validator : null,
      style: letraPreta,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hint,
      ),
    );
  }

  List<String> classes = [
    'Anestésico',
    'Profilaxia antibiótica',
    'Medicamentos'
  ];
  Widget forms() {
    final baseController = Provider.of<BaseController>(context);
    GlobalKey key = GlobalKey<FormState>();
    return Center(
        child: Form(
      key: key,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Observer(builder: (_) {
                return Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      items: classes.map((String dropDowmStringItem) {
                        return DropdownMenuItem<String>(
                          value: dropDowmStringItem,
                          child: Text(dropDowmStringItem),
                        );
                      }).toList(),
                      onChanged: (String classeSelecionada) async {
                        baseController.classe = classeSelecionada;
                        await controller.setClasse(classeSelecionada);
                        print(classeSelecionada);
                        print(controller.classeId);
                        await controller.getNomes(controller.classeId);
                        print(controller.listNomes);
                      },
                      hint: Text('Escolha uma classe (obrigatório)'),
                      value: baseController.classe,
                    ),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Observer(builder: (_) {
                return textForm(
                  context: context,
                  controller: controller.idadeController,
                  validator: 'Por favor, informe a idade do Paciente',
                  hint: 'Idade em anos (obrigatório)',
                  onChanged: controller.setIdade,
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Observer(builder: (_) {
                return textForm(
                  context: context,
                  controller: controller.pesoController,
                  validator: 'Por favor, informe o peso do Paciente',
                  hint: 'Peso em Kg (não obrigatório)',
                  onChanged: controller.setPeso,
                );
              }),
            ),
            Observer(builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<String>(
                  label: "Medicamentos",
                  items: controller.listNomes,
                  mode: Mode.MENU,
                  selectedItem: baseController.nome,
                  popupItemBuilder: (context, item, isSelected) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                  onChanged: (String data) async {
                    controller.nomeSelecionado = data;
                    baseController.nome = data;
                    if (controller.idadeString == null) {
                      controller.nomeSelecionado = '';
                      baseController.nome = '';
                      Fluttertoast.showToast(msg: 'Digite a idade do paciente');
                    } else {
                      await controller.getApresentacao(
                          controller.nomeSelecionado,
                          controller.idadeString,
                          controller.classeId);
                    }
                  },
                ),
              );
            }),
            Observer(builder: (_) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<String>(
                  label: "Apresentação",
                  selectedItem: baseController.apresentacao,
                  items: controller.listApresentacoes,
                  mode: Mode.MENU,
                  popupItemBuilder: (context, item, isSelected) {
                    return Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                  onChanged: (String data) async {
                    controller.apresentacaoSelecionada = data;
                    baseController.apresentacao = data;
                  },
                ),
              );
            }),
          ],
        ),
      ),
    ));
  }

  Widget button() {
    return Center(
      child: Stack(
        children: [
          Container(
            decoration: buttonDecoration,
            child: MaterialButton(
              onPressed: () async {
                var resultado = await pesquisar();
                showAlertDialog1(context, resultado);
              },
              highlightColor: Colors.transparent,
              splashColor: Colors.lightBlueAccent,
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 42.0),
                child: Text(
                  "Pesquisar",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String> pesquisar() async {
    double peso2 = await controller.getPeso();
    String resultado = await controller.getMedicamento(
        controller.nomeSelecionado,
        controller.idadeString,
        controller.apresentacaoSelecionada,
        peso2,
        controller.classeId);
    return resultado;
  }

  showAlertDialog1(BuildContext context, String resultado) {
    BaseController baseController =
        Provider.of<BaseController>(context, listen: false);
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        baseController.apresentacao = null;
        baseController.nome = null;
        baseController.classe = null;
        controller.idadeController.text = '';
        controller.pesoController.text = '';
        Modular.to.pop();
      },
    );
    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text("Resultado", style: letraAzul),
      content: Text(
        resultado,
        textAlign: TextAlign.justify,
        style: letraPreta,
      ),
      actions: [
        okButton,
      ],
    );
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }
}
