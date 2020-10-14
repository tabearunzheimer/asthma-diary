import 'package:asthma_tagebuch/helper/CustomStatisticsPainter.dart';
import 'package:asthma_tagebuch/helper/Reusable_Widgets.dart';
import 'package:asthma_tagebuch/helper/StatisticsHelper.dart';
import 'package:asthma_tagebuch/helper/date_helper.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 2;
  ReusableWidgets _reusableWidgets;
  double _posx = 100.0;
  AnimationController _controller;
  bool _tapInProgress;
  StatisticsHelper statHelper;

  bool buttonLoaded = false;

  List<dynamic> _yValues1;
  List<dynamic> _yValues2;
  List<dynamic> _yValues3;
  List<dynamic> _yValues4;
  List<dynamic> _xValues;
  List<Color> colors = [
    Color.fromRGBO(200, 0, 0, 1),
    Color.fromRGBO(0, 200, 0, 1),
    Color.fromRGBO(0, 0, 200, 1),
    Color.fromRGBO(200, 250, 0, 1),
  ];

  List<Widget> buttons;
  List<int> activatedButtonsOrder;
  DateTime _visibleMonth;

  List<bool> buttonsActivated;
  List<bool> _canvasActivated;
  int activated;

  @override
  void initState() {
    super.initState();
    this._controller = AnimationController(
      vsync: this,
    );
    this._tapInProgress = false;
    statHelper = new StatisticsHelper();
    buttonsActivated = new List();
    _canvasActivated = [false, false, false, false];

    activated = 0;
    activatedButtonsOrder = new List();
    _yValues1 = new List();
    _yValues2 = new List();
    _yValues3 = new List();
    _yValues4 = new List();

    _visibleMonth = new DateTime.now();

    buttons = new List();

    getInhalationSpraysAsWidget();
  }

  @override
  Widget build(BuildContext context) {
    _reusableWidgets = new ReusableWidgets(context, _selectedIndex);

    return Scaffold(
      appBar: _reusableWidgets.getNormalAppBar(),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        setState(() {
                          _visibleMonth = new DateTime(
                              _visibleMonth.year, _visibleMonth.month - 1);
                          getInhalationSpraysAsWidget();
                          buttons = new List();
                          buttonLoaded = false;
                          activatedButtonsOrder = new List();
                          buttonsActivated = new List();
                          _yValues1 = new List();
                          _yValues2 = new List();
                          _yValues3 = new List();
                          _yValues4 = new List();
                          getInhalationSpraysAsWidget();
                        });
                      },
                    ),
                    Text(new DateHelper().getMonthName(_visibleMonth.month) +
                        " " +
                        _visibleMonth.year.toString()),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: () {
                        setState(() {
                          _visibleMonth = new DateTime(_visibleMonth.year, _visibleMonth.month + 1);
                          buttons = new List();
                          buttonLoaded = false;
                          activatedButtonsOrder = new List();
                          buttonsActivated = new List();
                          _yValues1 = new List();
                          _yValues2 = new List();
                          _yValues3 = new List();
                          _yValues4 = new List();
                          getInhalationSpraysAsWidget();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Card(
                shape: new RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getHeadline("Statistik"),
                    getDivider(),
                    Container(
                      child: Stack(
                        children: [
                          buildStatisticsAnimation(0, _yValues1),
                          buildStatisticsAnimation(1, _yValues2),
                          buildStatisticsAnimation(2, _yValues3),
                          buildStatisticsAnimation(3, _yValues4),
                        ],
                      ),
                    ),
                    Container(
                      //color: Colors.green,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      padding: EdgeInsets.all(5),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runSpacing: 10,
                        spacing: 10,
                        children: buttonLoaded
                            ? buttons
                            : [
                          Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
                          Container(
                            child: Text("Bitte warte kurz"),
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(bottom: 50),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
      bottomNavigationBar: _reusableWidgets.getBottomNavigationBar(),
    );
  }

  Widget buildButton(String text, int index, Color c) {
    buttonsActivated.add(false);
    return Container(
      width: (text.length * 15) / 1,
      height: 50.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: new BorderSide(
            color: buttonsActivated[index] ? c : Color.fromRGBO(0, 0, 200, 1),
          ),
        ),
        color: buttonsActivated[index] ? c.withOpacity(0.2) : Colors.white,
        child: Text(text),
        onPressed: () {
          if (activated < 4 && !buttonsActivated[index]) {
            setState(() {
              activated++;
              buttonsActivated[index] = true;
              showStatistic(text, index);
            });
          } else if (activated == 4 && !buttonsActivated[index]) {
            Flushbar(
              title: "Hinweis",
              message: "Es können nicht mehr als 4 Objekte gewählt werden.",
              backgroundColor: Colors.black54,
              margin: EdgeInsets.all(10),
              borderRadius: 10,
              duration: Duration(seconds: 3),
            )..show(context);
          } else {
            setState(() {
              activated--;
              buttonsActivated[index] = false;
              buttons[index] = buildButton(text, index, Colors.white);
              hideStatistic(text, index);
            });
          }
        },
      ),
    );
  }

  void showStatistic(String s, int index) {
    List<dynamic> l = new List();
    if (s == "Symptome") {
      l = statHelper.getAmountOfSymptomsForAMonth(_visibleMonth.month);
    } else if (s.contains("Morgens") ||
        s.contains("Mittags") ||
        s.contains("Abends") ||
        s.contains("Nachts")) {
      //Medikament
      l = statHelper.getTakenSprayForAMonth(s, _visibleMonth.month);
    } else {
      //Umstaende
      l = statHelper.getSurroundingsTakenForAMonth(_visibleMonth.month, s);
    }


    if (l.length != 0) {
      int pos;
      bool posFound = false;
      for (int i = 0; i < activatedButtonsOrder.length; i++){
        if (activatedButtonsOrder[i] == -1){
          pos = i;
          posFound = true;
        }
      }
      if (activatedButtonsOrder.length == 0 || !posFound){
        activatedButtonsOrder.add(index);
        pos = activatedButtonsOrder.length-1;
      }

      setState(() {
        switch (pos) {
          case 0:
            _yValues1 = l;
            break;
          case 1:
            _yValues2 = l;
            break;
          case 2:
            _yValues3 = l;
            break;
          case 3:
            _yValues4 = l;
            break;
        }
        activatedButtonsOrder[pos] = index;
        _canvasActivated[pos] = true;
        _xValues = statHelper.getDaysForAMonth(_visibleMonth.month);
        //print(_xValues.length);
        buttons[index] = buildButton(s, index, colors[pos]);
      });
    } else {
      print("kein eintrag");
      setState(() {
        activated--;
        buttonsActivated[index] = false;
      });
      Flushbar(
        title: "Hinweis",
        message: "Es sind entweder keine oder nicht genug Einträge vorhanden.",
        backgroundColor: Colors.black54,
        margin: EdgeInsets.all(10),
        borderRadius: 10,
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  void hideStatistic(String s, int index) {
    int pos;
    for (int i = 0; i < activatedButtonsOrder.length; i++){
      if (activatedButtonsOrder[i] == index){
        pos = i;
      }
    }
    print("pos $pos");
    setState(() {
      switch (pos) {
        case 0:
          _yValues1 = new List();
          break;
        case 1:
          _yValues2 = new List();
          break;
        case 2:
          _yValues3 = new List();
          break;
        case 3:
          _yValues4 = new List();
          break;
      }
      activatedButtonsOrder[pos] = -1;
      _xValues = statHelper.getDaysForAMonth(_visibleMonth.month);
      _canvasActivated[pos] = false;
      print(_xValues.length);
      buttons[index] = buildButton(s, index, Colors.white);
    });
  }

  Widget buildStatisticsAnimation(int index, List<dynamic> yWerte) {
    return Container(
      //color: Colors.red,
      height: 320,
      //margin: EdgeInsets.only(top: 500, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onHorizontalDragStart: (DragStartDetails details) =>
            dragStart(context, details),
        onHorizontalDragUpdate: (DragUpdateDetails details) =>
            dragUpdate(context, details),
        onHorizontalDragDown: (DragDownDetails details) =>
            dragDown(context, details),
        child: AnimatedBuilder(
          animation: this._controller,
          builder: (BuildContext context, Widget child) {
            return CustomPaint(
              painter: CustomStatisticPainter(
                animation: this._controller,
                backgroundColor: Colors.white,
                color: colors[index],
                posX: this._posx,
                werteY: yWerte,
                werteX: this._xValues,
                active: _canvasActivated[index],
              ),
            );
          },
        ),
      ),
    );
  }

  Future getInhalationSpraysAsWidget() async {
    await statHelper.getDatabaseEntries();
    List<String> data = await statHelper.getAllUsedSpraysWithDayTimeByMonth(_visibleMonth.month);

    for (int i = 0; i < data.length; i++) {
      print("buttons");
      buttons.add(buildButton(data[i], buttons.length, Colors.white));
      if (i + 1 == data.length) {
        buttons.add(buildButton("Symptome", buttons.length, Colors.white));
        buttons.add(buildButton("Angst/ Panik", buttons.length, Colors.white));
        buttons.add(buildButton(
            "Bedarfsmedikation genommen", buttons.length, Colors.white));
        buttons
            .add(buildButton("Bettzeug waschen", buttons.length, Colors.white));
        buttons.add(buildButton("Krank", buttons.length, Colors.white));
        buttons.add(buildButton("Putzen", buttons.length, Colors.white));
        buttons.add(buildButton("Sport", buttons.length, Colors.white));
      }
    }
    setState(() {
      buttonLoaded = true;
    });
  }

  Widget getHeadline(String t) {
    return new Container(
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: Text(
        t,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget getDivider() {
    return new Divider(
      color: Colors.black54,
      indent: 10,
      endIndent: 10,
    );
  }

  ///saves the position of a tap
  void dragStart(BuildContext context, DragStartDetails details) {
    //print('Start: ${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);

    setState(() {
      _posx = localOffset.dx;
      this._tapInProgress = true;
    });
  }

  ///saves the position when the tap ends
  dragDown(BuildContext context, DragDownDetails details) {
    //print('Ende: ${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);

    setState(() {
      _posx = localOffset.dx;
      this._tapInProgress = true;
    });
  }

  ///saves the position during a tap
  void dragUpdate(BuildContext context, DragUpdateDetails details) {
    //print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);

    setState(() {
      _posx = localOffset.dx;
      this._controller.value = localOffset.dx;
      this._tapInProgress = true;
    });
  }
}