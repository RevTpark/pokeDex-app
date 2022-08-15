import 'package:flutter/material.dart';
import 'package:pokedex_mobile_app/src/api/pokemon_service.dart';
import 'package:pokedex_mobile_app/src/models/pokemon.dart';
import 'package:pokedex_mobile_app/src/provider/rate_team_provider.dart';
import 'package:pokedex_mobile_app/src/widgets/menu_textbox.dart';
import 'package:pokedex_mobile_app/src/config/enums.dart';
import 'package:provider/provider.dart';

class RatedTeamDisplay extends StatefulWidget {
  const RatedTeamDisplay({Key? key}) : super(key: key);

  @override
  State<RatedTeamDisplay> createState() => _RatedTeamDisplayState();
}

class _RatedTeamDisplayState extends State<RatedTeamDisplay> {

  Future<Map> getPokemonTeamRating() async{
    RateTeamProvider provider = Provider.of<RateTeamProvider>(context, listen: false);
    List<int> idList = provider.teamList.map<int>((Pokemon item) => item.id).toList();
    Map response = await PokemonService().getTeamRank(idList);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<Map>(
            future: getPokemonTeamRating(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Container(
                  child: Text(snapshot.data!['result']),
                );
              }
              else{
                return CircularProgressIndicator();
              }
            }
        ),
        Row(
          children: [
            MenuTextBox(title: "Back", changeTo: ScreenLayout.rateMyTeam, widthFactor: 0.45,),
            MenuTextBox(title: "Home", changeTo: ScreenLayout.home, widthFactor: 0.45,)
          ],
        )
      ],
    );
  }
}
