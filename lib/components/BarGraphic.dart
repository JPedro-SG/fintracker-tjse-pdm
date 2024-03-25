import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
// import 'package:postgres/postgres.dart';
import 'package:FinTracker/provider.dart';
import 'package:provider/provider.dart';

// Gráfico de barras
class BarGraphic extends StatefulWidget {
  const BarGraphic({super.key});

  @override
  State<BarGraphic> createState() => _BarGraphicState();
}

class _BarGraphicState extends State<BarGraphic> {
  List<BarChartGroupData> _chartGroups() {
    final filesTJ = Provider.of<FilesTJ>(context);
    List<double> values = [];

    if (!filesTJ.isMonthView) {
      List<String> years = <String>[
        '2018',
        '2019',
        '2020',
        '2021',
        '2022',
        '2023'
      ];
      List<double> temp = [];
      years.forEach((element) {
        List<Map<String, dynamic>> documentsByYear = filesTJ
            .documents // retorna os documentos de determinado ano (element)
            .where((doc) => doc['data'].year.toString() == element)
            .toList();

        List<String> incisos = context.watch<FilesTJ>().incs;
        List<double> sumByMonth = documentsByYear.map((element) {
          double finalValue = 0;

          for (String inc in incisos) {
            finalValue += element[inc];
          }

          return finalValue;
        }).toList(); // retorna 12 incisos somados, um por mês

        double sumByYear = sumByMonth.reduce((value, element) =>
            value + element); //soma o valor gasto de cada mês do ano
        temp.add(sumByYear);
      });

      List<FlSpot> points = [];
      values = temp;
      if (values.isNotEmpty) {
        points = List<FlSpot>.generate(years.length,
            (int index) => FlSpot(double.parse(years[index]), values[index]));
      }

      return points
          .map((point) =>
              BarChartGroupData(barsSpace: 2, x: point.x.toInt(), barRods: [
                BarChartRodData(toY: point.y, color: Colors.blue[400]),
              ]))
          .toList();
    } else {
      List<List<FlSpot>> linegraphics = getMonthlyDocs();
      List<BarChartGroupData> data = [];
      if (linegraphics.isNotEmpty) {
        data = List<BarChartGroupData>.generate(12, (index) {
          if (linegraphics.length == 2) {
            return BarChartGroupData(x: index.toInt(), barRods: [
              BarChartRodData(toY: linegraphics[0][index].y),
              BarChartRodData(toY: linegraphics[1][index].y)
            ]);
          }

          return BarChartGroupData(
              x: index + 1,
              barRods: [BarChartRodData(toY: linegraphics[0][index].y)]);
        });
      }

      return data;
    }
  }

  List<List<FlSpot>> getMonthlyDocs() {
    List<List<FlSpot>> result = [];
    List<Year?> yList = Provider.of<FilesTJ>(context).yearsList;
    // print(yList);
    if (yList.length > 2) {
      while (yList.length > 2) {
        yList.removeAt(0);
      }
    }

    
    yList.forEach((year) {
      List<Map<String, dynamic>> docsByYear = Provider.of<FilesTJ>(context)
          .documents
          .where((doc) => doc['data'].year == int.parse(year!.year))
          .toList();

      docsByYear.sort((a, b) => a['data'].compareTo(b['data']));
      List<String> incisos = context.watch<FilesTJ>().incs;

      List<double> valueList = docsByYear.map((element) {
        double finalValue = 0;

        for (String inc in incisos) {
          finalValue += element[inc];
        }

        return finalValue;
      }).toList();

      if (valueList.isNotEmpty) {
        List<FlSpot> temp = List<FlSpot>.generate(valueList.length,
            (int index) => FlSpot(index.toDouble(), valueList[index]));

        result.add(temp);
      }
    });

    return result;
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 0:
              text = 'Jan';
              break;
            case 2:
              text = 'Mar';
              break;
            case 4:
              text = 'May';
              break;
            case 6:
              text = 'Jul';
              break;
            case 8:
              text = 'Sep';
              break;
            case 10:
              text = 'Nov';
              break;
          }

          return Text(text);
        },
      );

  SideTitles get _bottomTitlesYear => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          return Text(value.toInt().toString());
        },
      );

  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<FilesTJ>(context, listen: false).fetchDocuments();
  // }

  @override
  Widget build(BuildContext build) {
    return AspectRatio(
        aspectRatio: 3 / 4,
        child: BarChart(BarChartData(
          barGroups: _chartGroups(),
          borderData: FlBorderData(
              border: const Border(bottom: BorderSide(), left: BorderSide())),
          gridData: const FlGridData(
              show: false, drawVerticalLine: false, drawHorizontalLine: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
                sideTitles: context.watch<FilesTJ>().isMonthView
                    ? _bottomTitles
                    : _bottomTitlesYear),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        )));
  }
}
