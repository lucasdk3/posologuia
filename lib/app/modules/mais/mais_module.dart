import 'package:flutter/material.dart';
import 'package:posologuia/app/modules/mais/mais_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MaisModule extends WidgetModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => MaisPage()),
        ModularRouter('/', child: (_, args) => MaisPage()),
      ];

  static Inject get to => Inject<MaisModule>.of();

  @override
  Widget get view => MaisPage();
}
