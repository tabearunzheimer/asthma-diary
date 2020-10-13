import 'package:flutter/material.dart';

class CustomStatisticPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;
  final double posX;
  final List<int> werteY;
  final List<String> werteX;
  final int anzahlWerteX;
  final int anzahlWerteY;

  CustomStatisticPainter({
    this.animation,
    this.backgroundColor,
    this.color,
    this.posX,
    this.werteY,
    this.anzahlWerteX,
    this.anzahlWerteY,
    this.werteX,
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


    ///vertical line, y axis
    Offset oS = Offset(abstandVomRand, size.height - abstandVomRand);
    Offset oE = Offset(abstandVomRand, abstandVomRand*2 );
    canvas.drawLine(oS, oE, paint);


    ///horizontal line, x axis
    oS = Offset(abstandVomRand, size.height - abstandVomRand);
    oE = Offset(size.width - abstandVomRand, size.height - abstandVomRand);
    canvas.drawLine(oS, oE, paint);

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
    paint.color = this.color;
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
    paint.color = Colors.black12;
    ///dashed line showing where the pointer is pointing to
    for (double i = abstandVomRand+30; i < size.height - 30; i += 20) {
      oS = Offset(posXNew, i);
      oE = Offset(posXNew, i + 10);
      canvas.drawLine(oS, oE, paint);
    }


    ///gets the highest possible value of the y axis to draw and set the other values depending on the highest
    int hoechsterWert = 0;
    for (int i = 0; i < this.werteY.length; i++) {
      hoechsterWert = (hoechsterWert >= werteY[i]) ? hoechsterWert : werteY[i];
    }

    ///draws the function as line
    paint.color = Colors.black;
    double abstandX = (size.width-2*abstandVomRand)/anzahlWerteX;
    double abstandY = (size.height-3*abstandVomRand)/hoechsterWert;
    print("x: $abstandX y: $abstandY");
    print("width: ${size.width}");

    int index = 0;
    for (double x = abstandVomRand; x < size.width-abstandVomRand; x += abstandX){
        if (index == 0){
          double y =  (size.height-abstandVomRand);

          y -= werteY[index] * abstandY;
          print("y: ${werteY[index]}\n\n");
          oS = new Offset(x, (size.height-abstandVomRand) - werteY[index] * abstandY);
        } else {
          oE = new Offset(x, (size.height-abstandVomRand) - werteY[index] * abstandY);
          canvas.drawLine(oS, oE, paint);
          print("oS-X: ${oS.dx} y: ${oS.dy}\noE-x: ${oE.dx} y: ${oE.dy} + index $index\n\n");
          oS = oE;
        }

        index++;
    }



  }

  @override
  bool shouldRepaint(CustomStatisticPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}