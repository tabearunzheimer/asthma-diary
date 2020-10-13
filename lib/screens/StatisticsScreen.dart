import 'package:asthma_tagebuch/helper/CustomStatisticsPainter.dart';
import 'package:asthma_tagebuch/helper/Reusable_Widgets.dart';
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

  List<int> _yValues = [1, 0, 5, 15, 10, 7];
  List<String> _months = ["5", "10", "15", "20", "25", "30"];

  @override
  void initState() {
    super.initState();
    this._controller = AnimationController(
      vsync: this,
    );
    this._tapInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    _reusableWidgets = new ReusableWidgets(context, _selectedIndex);

    return Scaffold(
      appBar: _reusableWidgets.getNormalAppBar(),
      body: Container(

        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getHeadline("Statistik"),
              getDivider(),
              Container(
                child: Container(
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
                            color: Theme.of(context).accentColor,
                            posX: this._posx,
                            anzahlWerteX: this._months.length,
                            anzahlWerteY: this._yValues.length,
                            werteY: this._yValues,
                            werteX: this._months,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _reusableWidgets.getBottomNavigationBar(),
    );
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
