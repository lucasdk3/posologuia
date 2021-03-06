import 'package:flutter_modular/flutter_modular.dart';
import 'package:posologuia/app/modules/login/reset/reset_page.dart';

class ResetModule extends ChildModule {
  @override
  List<Bind> get binds => [];

  @override
  List<ModularRouter> get routers => [
        ModularRouter(Modular.initialRoute, child: (_, args) => ResetPage()),
        ModularRouter('/', child: (_, args) => ResetPage()),
      ];

  static Inject get to => Inject<ResetModule>.of();
}
