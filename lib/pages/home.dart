import 'dart:async';

import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  Map data = {};

  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty? data : ModalRoute.of(context)?.settings.arguments as Map;

    String bgImage = data['isDayTime'] ? 'day.png':'night.png';
    Color? bgColor = data['isDayTime'] ? Colors.blue : Colors.indigo[700];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover
            )
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: Column(
              children: [
                TextButton.icon(
                    onPressed: () async{
                      dynamic result = await Navigator.pushNamed(context, '/location');
                      result == null ? data : setState(() {
                        data = {
                          'time' : result['time'],
                          'location': result['location'],
                          'isDayTime' : result['isDayTime'],
                          'flag':result['flag'],
                          'object': result['object']
                        };
                      });
                    },
              style: TextButton.styleFrom(
                primary: Colors.grey[300]
              ),
                    icon: Icon(Icons.edit_location),
                    label: Text("Edit Location")),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data['location'],
                      style: TextStyle(
                        fontSize: 28,
                        letterSpacing: 2,
                        color: Colors.white
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Text(
                  data['time'],
                  style: TextStyle(
                    fontSize: 66,
                    color: Colors.white
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }

  void _getTime(){
    Map data1 = {
      'time' : data['object'],
      'location': data['location'],
      'isDayTime' : data['isDayTime'],
      'flag':data['flag'],
      'object':data['object']
    };
    WorldTime instance = data1['object'];
    instance.getTime();
    setState(() {
      data['time'] = instance.time;
      data['isDayTime'] = instance.isDayTime;
    });
  }
}
