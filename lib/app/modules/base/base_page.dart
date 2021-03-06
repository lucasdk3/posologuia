import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:posologuia/app/modules/home/home_module.dart';
import 'package:posologuia/app/modules/mais/mais_module.dart';
import 'package:posologuia/app/modules/sobre/sobre_module.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import 'base_controller.dart';

class BasePage extends StatefulWidget {
  final String title;
  const BasePage({Key key, this.title = "Base"}) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  //use 'controller' variable to access controller
  List widgetOptions = [SobreModule(), HomeModule(), MaisModule()];

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BaseController>(context);
    return Scaffold(
      body: Observer(builder: (_) {
        return widgetOptions.elementAt(controller.currentIndex);
      }),
      bottomNavigationBar: bottomNav(),
    );
  }

  Widget bottomNav() {
    return Observer(builder: (_) {
      final controller = Provider.of<BaseController>(context);
      return BottomNavigationBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          currentIndex: controller.currentIndex,
          onTap: (value) => controller.updateCurrentIndex(value),
          selectedItemColor: primary,
          items: [
            BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.paste), label: 'Sobre'),
            BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.home), label: 'Prescrição'),
            BottomNavigationBarItem(
                icon: Icon(LineAwesomeIcons.trophy), label: 'Mais pesquisados'),
          ]);
    });
  }
}
