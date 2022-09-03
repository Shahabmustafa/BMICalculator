import 'package:flutter/material.dart';
import '../util/api_file.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Climate extends StatefulWidget {
  const Climate({Key? key}) : super(key: key);

  @override
  State<Climate> createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {
  void showStuff()async{
    Map data =await getWeather(util.apiId,util.defaultcity);
    print(data.toString());
  }
  String? _cityEntered;
  Future _goToNextScreen(BuildContext context)async{
  Map results = await Navigator
      .of(context)
      .push(MaterialPageRoute (builder: (BuildContext context){
      return ChangeCity();
  }));

  if(results != null && results.containsKey('enter')){
    _cityEntered = results['enter'];
         // debugPrint("From First screen" + results['enter'].toString());
  }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       title: Text('WEATHER APP'),
       backgroundColor: Colors.black,
       actions: <Widget>[
         IconButton(
           icon: Icon(Icons.menu),
           onPressed: (){
             _goToNextScreen(context);
           },
         ),
       ],
     ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage('images/location_background.jpeg'),
              height: 900.0,
              width: 450.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.1, 10.1, 10.1, 0.1),
            child: Text(
              '${_cityEntered == null ? util.defaultcity: _cityEntered}',
              style: CityStyle(),
            ),
            ),
          Container(
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.fromLTRB(30.1, 90.1, 10.1, 0.1),
            child: updateTempWidget(
              '${_cityEntered == null ? util.defaultcity: _cityEntered}',
            ),
          ),
        ],
      ),
    );
  }
  Future<Map> getWeather (String appId,String city)async{
    String apiUrl = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid='
    '${util.apiId}&units=imperial';
    // https://api.openweathermap.org/data/2.5/weather?q=charsadda&appid=04e81d93f548846016f6700799fa99e&units=imperial
    http.Response response = await http.get(Uri.parse(apiUrl));
    return json.decode(response.body);
  }
  Widget updateTempWidget(String city){
    return FutureBuilder(
      future: getWeather(util.apiId, city == null ? util.defaultcity : city),
      builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
        if(snapshot.hasData){
          Map content = snapshot.data!;
          return Container(
            margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ListTile(
                  title: Text(
                    content['main']['temp'].toString() + 'F',
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 49.9,
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  subtitle: ListTile(
                    title: Text(
                        "Humidity:${content['main']['humidity'].toString()}\n"
                            "Min:${content['main']['temp_min'].toString()}F\n"
                            "Max:${content['main']['temp_max'].toString()}F",
                      style: extraData(),
                    ),
                  ),
                )
              ],
            ),
          );
        }else{
          return Container();
        }
      },
    );
  }
}

class ChangeCity extends StatelessWidget {
var _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Change City'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              ListTile(
                title: TextButton(
                  child: Text('Get Weather'),
                  onPressed: (){
                    Navigator.pop(
                        context,{'enter': _cityFieldController.text});
                },
                  style: TextButton.styleFrom(
                  primary: Colors.black,
                  ),
              ),
              ),
            ],
          )
        ],
      ),
    );
  }
}


TextStyle CityStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 23.0,
    fontStyle: FontStyle.italic,
  );
}
TextStyle tempStyle(){
  return TextStyle(
    color: Colors.white,
    fontSize: 35.0,
  );
}
TextStyle extraData(){
  return TextStyle(
    color: Colors.white,fontStyle: FontStyle.normal,fontSize: 17.0,
  );
}