import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'dart:async';
import 'dart:math';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Puzzle(),
    );
  }
}

class Puzzle extends StatefulWidget {
  @override
  _PuzzleState createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  Color _colorRandom;
  Color _color;
  double _opacity;
  bool _play;
  int _random;
  int _count;
  int _best;
  int _time;

  @override
  initState(){
    super.initState();
    _init();
  }

  _init(){
    _colorRandom = Colors.grey.withOpacity(0.4);
    _color = Colors.grey;
    _opacity = 1.0;
    _play = false;
    _random = 12;
    _count = 0;
    _time = 60;
    _best = 0;
    _getBest();
  }

  _getBest() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    _best = pref.getInt('best') ?? 0;
    setState(() {});
  }

  _saveBest() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt('best', _best);
  }

  @override
  Widget build(BuildContext context) {
    double side = (MediaQuery.of(context).size.width-12)/5;
    return Material(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "time: $_time",
                    style: TextStyle(color: Colors.black54, fontSize: 20.0, fontFamily: 'Comfortaa'),
                  ),
                  Spacer(),
                  Text(
                    'score: $_count   best: $_best',
                    style: TextStyle(color: Colors.black54, fontSize: 20.0, fontFamily: 'Comfortaa'),
                  )
                ],
              ),
            ),
            Expanded(
              child: _play ? Container() : Center(
                child: GestureDetector(
                  onTap: (){
                    _play = true;
                    Timer.periodic(Duration(seconds: 1), (timer){
                      _time--;
                      if(_time == 0){
                        timer.cancel();
                        _init();
                      }
                      setState(() {});
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(color: Colors.black54, width: 3.0)
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
                      child: Text(
                        'play',
                        style: TextStyle(color: Colors.black54, fontSize: 30.0, fontFamily: 'Comfortaa', fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Wrap(
                children: List.generate(30, (index){
                  return Padding(
                    padding: EdgeInsets.all(1.0),
                    child: GestureDetector(
                      onTap: (){
                        if(!_play || _random != index) return;
                        _count++;
                        if(_count > _best) {
                          _best = _count;
                          _saveBest();
                        }
                        _random = Random().nextInt(30);
                        _opacity = _opacity <= 0.5 ? 0.55-0.01*(_count~/5) : 1-0.1*(_count~/5);
                        if(_opacity <= 0.41) _opacity = 0.41;
                        _color = AppColors().get().withOpacity(_opacity);
                        _colorRandom = _color.withOpacity(0.4);
                        setState(() {});
                      },
                      child: SizedBox.fromSize(
                        size: Size.square(side),
                        child: Material(
                          color: index == _random ? _colorRandom : _color,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
