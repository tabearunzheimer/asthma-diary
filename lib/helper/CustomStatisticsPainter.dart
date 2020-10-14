import 'package:flutter/material.dart';

class CustomStatisticPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;
  final double posX;
  final List<dynamic> werteY;
  final List<dynamic> werteX;
  final int anzahlWerteX;
  final int anzahlWerteY;
  final bool active;

  CustomStatisticPainter({
    this.animation,
    this.backgroundColor,
    this.color,
    this.posX,
    this.werteY,
    this.anzahlWerteX,
    this.anzahlWerteY,
    this.werteX,
    this.active,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;


    paint.style = PaintingStyle.stroke;
    paint.color = Colors.black;
    paint.strokeWidth = 1;

    double abstandVomRand = 30;

    Offset oS = new Offset(0, 0);
    Offset oE = new Offset(0, 0);

    //print(" active: " +active.toString());

    if (werteY.length != 0 && active){
      //print("draw");

      ///checks if the given position runs over the width
      double posXNew;
      if(posX > size.width-abstandVomRand){
        posXNew = size.width-abstandVomRand;
      } else if (posX < abstandVomRand){
        posXNew = abstandVomRand;
      } else {
        posXNew = posX;
      }

      ///Pointer
      paint.color = Colors.black;
      paint.strokeWidth = 2;
      oS = Offset(posXNew, abstandVomRand);
      oE = Offset(posXNew, abstandVomRand+20);
      ///arrow for the pointer
      canvas.drawLine(oS, oE, paint);
      oS = Offset(posXNew, abstandVomRand+20);
      oE = Offset(posXNew - 5, abstandVomRand+10);
      canvas.drawLine(oS, oE, paint);
      oS = Offset(posXNew, abstandVomRand+20);
      oE = Offset(posXNew + 5, abstandVomRand+10);
      canvas.drawLine(oS, oE, paint);
      paint.color = Colors.black26;
      ///dashed line showing where the pointer is pointing to
      for (double i = abstandVomRand*2; i < size.height - abstandVomRand*2; i += 20) {
        oS = Offset(posXNew, i);
        oE = Offset(posXNew, i + 10);
        canvas.drawLine(oS, oE, paint);
      }


      ///gets the highest possible value of the y axis to draw and set the other values depending on the highest
      int hoechsterWert = 0;
      if (werteY.runtimeType.toString() == "List<bool>"){
        hoechsterWert = 1;
      } else if (werteY.runtimeType.toString() == "List<int>"){
        for (int i = 0; i < this.werteY.length; i++) {
          hoechsterWert = (hoechsterWert >= werteY[i]) ? hoechsterWert : werteY[i];
        }
      }


      ///draws the function as line
      paint.color = Colors.black;
      paint.strokeWidth = 1.5;
      double abstandX = (size.width-2*abstandVomRand)/werteX.length;
      double abstandY = (size.height-4*abstandVomRand)/hoechsterWert;
      //print("y: " + abstandY.toString());

      //zeichnet den Graphen und fuellt ihn
      int index = 0;
      var path = Path();
      for (double x = abstandVomRand; x < size.width-abstandVomRand && index < werteY.length; x += abstandX){
        double y = 0;
        if (werteY.runtimeType.toString() == "List<bool>"){
          y = werteY[index] ? (abstandVomRand*2) : (size.height-abstandVomRand*2);
        } else if (werteY.runtimeType.toString() == "List<int>"){
          for (int i = 0; i < this.werteY.length; i++) {
            y = (size.height-abstandVomRand*2) - werteY[index] * abstandY;
          }
        }
        if (index == 0){
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
          oE = new Offset(x, y);
        }
        index++;
      }
      paint.strokeWidth = 0.1;
      oE = new Offset(oE.dx, size.height-2*abstandVomRand);
      path.lineTo(oE.dx, oE.dy);
      oS = oE;
      oE = new  Offset(abstandVomRand, size.height-2*abstandVomRand);
      path.lineTo(oE.dx, oE.dy);
      oS = oE;
      double y = 0;
      if (werteY.runtimeType.toString() == "List<bool>"){
        y = werteY[0] ? (abstandVomRand*2) : (size.height-abstandVomRand*2);
      } else if (werteY.runtimeType.toString() == "List<int>"){
        for (int i = 0; i < this.werteY.length; i++) {
          y = (size.height-abstandVomRand*2) - werteY[0] * abstandY;
        }
      }
      oE = new  Offset(abstandVomRand, y);
      path.lineTo(oE.dx, oE.dy);
      path.close();
      paint.style = PaintingStyle.fill;
      paint.color = color.withOpacity(0.2);
      canvas.drawPath(path, paint);

      //zeichnet den Graphen erneut, aber diesmal nur die Linie ohne Fuellung
      index = 0;
      paint.strokeWidth = 1.5;
      paint.color = color;
      for (double x = abstandVomRand; x < size.width-abstandVomRand && index < werteY.length; x += abstandX){
        y = 0;
        if (werteY.runtimeType.toString() == "List<bool>"){
          y = werteY[index] ? (abstandVomRand*2) : (size.height-abstandVomRand*2);
        } else if (werteY.runtimeType.toString() == "List<int>"){
          for (int i = 0; i < this.werteY.length; i++) {
            y = (size.height-abstandVomRand*2) - werteY[index] * abstandY;
          }
        }
        if (index == 0){
          oS = new Offset(x, y);
        } else {
          oE = new Offset(x, y);
          canvas.drawLine(oS, oE, paint);
          //print("os-x: ${oS.dx}\noe-x: ${oE.dx} index + ${werteY[index]}\n\n");
          oS = oE;
        }
        index++;
      }

        TextSpan span = new TextSpan(style: new TextStyle(color: Colors.black), text: this.werteX[0]);
        TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, new Offset(abstandVomRand, size.height-abstandVomRand*2+5));
        span = new TextSpan(style: new TextStyle(color: Colors.black), text: this.werteX[this.werteX.length-1]);
        tp = new TextPainter(text: span, textAlign: TextAlign.right, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, new Offset(oE.dx-(this.werteX.length*10), size.height-abstandVomRand*2+5));


    }

    paint.color = Colors.black;
    paint.style = PaintingStyle.stroke;

    ///vertical line, y axis
    oS = Offset(abstandVomRand, size.height - abstandVomRand*2);
    oE = Offset(abstandVomRand, abstandVomRand*2 );
    canvas.drawLine(oS, oE, paint);


    ///horizontal line, x axis
    oS = Offset(abstandVomRand, size.height - abstandVomRand*2);
    oE = Offset(size.width - abstandVomRand, size.height - abstandVomRand*2);
    canvas.drawLine(oS, oE, paint);

    paint.style = PaintingStyle.stroke;
    ///draw y-index-lines
    int index = 0;
    for (double y = abstandVomRand*2; y < size.height-abstandVomRand*2; y+=(size.height-4*abstandVomRand)/5){
      paint.color = Colors.black12;
      paint.strokeWidth = 1;
      ///dashed line showing where the pointer is pointing to
      for (double x = abstandVomRand; x < size.width - abstandVomRand; x += 20) {
        oS = Offset(x, y);
        oE = Offset(x+10, y);
        canvas.drawLine(oS, oE, paint);
      }
    }

  }



  @override
  bool shouldRepaint(CustomStatisticPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}