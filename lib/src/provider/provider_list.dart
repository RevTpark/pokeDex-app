import 'package:pokedex_mobile_app/src/provider/nav_provider.dart';
import 'package:pokedex_mobile_app/src/provider/rate_team_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderList{

  static List<SingleChildWidget> getProviders(){
    return <SingleChildWidget>[
      ChangeNotifierProvider(create: (_) => NavProvider()),
      ChangeNotifierProvider(create: (_) => RateTeamProvider())
    ];
  }
}