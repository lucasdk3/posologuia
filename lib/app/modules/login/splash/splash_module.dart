import 'package:flutter_modular/flutter_modular.dart';
import 'package:posologuia/app/modules/base/base_module.dart';
import 'package:posologuia/app/modules/login/login_module.dart';
import 'package:posologuia/app/modules/login/register/register_module.dart';
import 'package:posologuia/app/modules/login/reset/reset_module.dart';
import 'package:posologuia/app/modules/login/splash/splash_page.dart';
import 'package:posologuia/app/modules/termos/termos_module.dart';
import 'package:posologuia/app/utils/user_controller.dart';

class SplashModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => UserController()),
      ];

  @override
  List<ModularRouter> get routers => [
        ModularRouter('/', child: (_, args) => SplashPage()),
        ModularRouter('/base', module: BaseModule()),
        ModularRouter('/login', module: LoginModule()),
        ModularRouter('/register', module: RegisterModule()),
        ModularRouter('/reset', module: ResetModule()),
        ModularRouter('/termos', module: TermosModule()),
      ];

  static Inject get to => Inject<SplashModule>.of();
}
