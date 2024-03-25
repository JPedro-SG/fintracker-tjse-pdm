import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:FinTracker/provider.dart';

// Grafico de linha
class LineGraphic extends StatefulWidget {
  const LineGraphic({super.key});

  @override
  State<LineGraphic> createState() => _LineGraphicState();
}

class _LineGraphicState extends State<LineGraphic> {
  List<FlSpot> points = List<FlSpot>.generate(
      12, (int index) => FlSpot(index.toDouble(), (index + 1).toDouble()));

  SideTitles get _monthsTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';

        if (value - value.toInt() != 0) {
          return (Text(
              text)); // evita situações em que o gráfico passa valores arredondados e desnecessários para minha proposta
        }

        switch (value.toInt()) {
          // case 0:
          //   text = 'Jan';
          //   break;
          case 1:
            text = 'Fev';
            break;
          // case 2:
          //   text = 'Mar';
          //   break;
          case 3:
            text = 'Abr';
            break;
          // case 4:
          //   text = 'Mai';
          //   break;
          case 5:
            text = 'Jun';
            break;
          // case 6:
          //   text = 'Jul';
          //   break;
          case 7:
            text = 'Ago';
            break;
          // case 8:
          //   text = 'Set';
          //   break;
          case 9:
            text = 'Out';
            break;
          // case 10:
          //   text = 'Nov';
          //   break;
          case 11:
            text = 'Dez';
            break;

          case 2018:
            text = '2018';
            break;

          case 2019:
            text = '2019';
            break;

          case 2020:
            text = '2020';
            break;

          case 2021:
            text = '2021';
            break;

          case 2022:
            text = '2022';
            break;

          case 2023:
            text = '2023';
            break;
        }
        return Text(text);
      });

  SideTitles get _leftTitles => SideTitles(
      reservedSize: 35,
      showTitles: true,
      getTitlesWidget: (value, meta) {
        // String text = '';
        final formatter = NumberFormat.compact();
        // print(formatter.format(value));
        return Text(
          formatter.format(value),
          style: TextStyle(fontSize: 10),
        );
      });

  List<List<FlSpot>> getMonthlyDocs() {
    List<List<FlSpot>> result = [];
    List<Year?> yList = context.watch<FilesTJ>().yearsList;

    yList.forEach((year) {
      List<Map<String, dynamic>> docsByYear = context
          .watch<FilesTJ>()
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

  List<FlSpot> getAnnuallyDocs() {
    final filesTJ = Provider.of<FilesTJ>(context);
    List<double> values = [];
    List<String> years = <String>[
      '2018',
      '2019',
      '2020',
      '2021',
      '2022',
      '2023'
    ];
    List<FlSpot> points = [];
    // if (!filesTJ.isMonthView) {
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

    values = temp;
    if (values.isNotEmpty) {
      points = List<FlSpot>.generate(years.length,
          (int index) => FlSpot(double.parse(years[index]), values[index]));
    }

    return points;
    // }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<FilesTJ>(context, listen: false).fetchDocuments();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        // color: Colors.grey,
        margin: const EdgeInsets.only(
          top: 24,
        ),
        padding: const EdgeInsets.only(right: 25, left: 10),
        child: AspectRatio(
            aspectRatio: 3 / 4,
            child: LineChart(LineChartData(
                lineBarsData: context.watch<FilesTJ>().isMonthView
                    ? getMonthlyDocs()
                        .map(
                          (e) => LineChartBarData(
                              spots: e,
                              isCurved: false,
                              dotData: const FlDotData(show: true)),
                        )
                        .toList()
                    : [
                        LineChartBarData(
                            spots: getAnnuallyDocs(),
                            isCurved: false,
                            dotData: const FlDotData(show: true))
                      ],
                borderData: FlBorderData(
                    border:
                        const Border(bottom: BorderSide(), left: BorderSide())),
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                    leftTitles: AxisTitles(sideTitles: _leftTitles),
                    bottomTitles: AxisTitles(sideTitles: _monthsTitles),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)))))),
      ),
    );
  }
}
