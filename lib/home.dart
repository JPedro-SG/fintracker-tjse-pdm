import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:FinTracker/documents.dart';
import 'package:FinTracker/favorite.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageIndex = 0;

  void _updateCurrentPageIndex(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  void _updateCurrentPageIndexPageController(int index) {
    setState(() {
      _currentPageIndex = index;
      pageController.animateToPage(index,
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  String updateAppBarTitle() {
    switch (_currentPageIndex) {
      case 1:
        return 'Documentos';
      case 2:
        return 'Favoritos';
      default:
        return 'Home';
    }
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
        controller: pageController,
        onPageChanged: (index) {
          _updateCurrentPageIndex(index);
        },
        children: <Widget>[const HomeBody(), Documents(), const Favorite()]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // automaticallyImplyLeading: false,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Icon(
                Icons.menu,
                color: Colors.red[900],
              ));
        }),
        centerTitle: true,
        title: Text(
          updateAppBarTitle(),
          style: TextStyle(
            color: Colors.red[900],
          ),
        ),
        actions: [
          if (_currentPageIndex == 0)
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return const ConfigGraphicModal();
                      });
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.red.shade900,
                ))
        ],
      ),
      body: buildPageView(),
      drawer: const Drawer(child: DrawerContent()),
      // body: Column(children: [Progress(), TaskList()])
      bottomNavigationBar: CustomNavigationBar(
          currentPageIndex: _currentPageIndex,
          updateCurrentPageIndex: _updateCurrentPageIndexPageController),
    );
  }
}

class Year {
  final int id;
  final String year;
  Year({required this.id, required this.year});
}

class ConfigGraphicModal extends StatefulWidget {
  const ConfigGraphicModal({super.key});

  @override
  State<ConfigGraphicModal> createState() => _ConfigGraphicModalState();
}

class _ConfigGraphicModalState extends State<ConfigGraphicModal> {
  bool _isGraphicModalSelected = false;
  static final List<Year> _years = [
    Year(id: 2018, year: '2018'),
    Year(id: 2019, year: '2019'),
    Year(id: 2020, year: '2020'),
    Year(id: 2021, year: '2021'),
    Year(id: 2022, year: '2022'),
    Year(id: 2023, year: '2023')
  ];

  final _items =
      _years.map((year) => MultiSelectItem(year, year.year)).toList();
  List<Year> _selectedYears = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Gráfico'),
              ),
              IconButton(
                  onPressed: () => setState(() {
                        _isGraphicModalSelected = false;
                      }),
                  icon: Icon(
                    Icons.line_axis,
                    color: !_isGraphicModalSelected
                        ? Colors.red[300]
                        : Colors.grey[400],
                  )),
              IconButton(
                  onPressed: () => setState(() {
                        _isGraphicModalSelected = true;
                      }),
                  icon: Icon(
                    Icons.bar_chart,
                    color: _isGraphicModalSelected
                        ? Colors.red[300]
                        : Colors.grey[400],
                  ))
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Anos', textAlign: TextAlign.left),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MultiSelectChipField<Year?>(
                  items: _items,
                  title: const Text('Anos'),
                  headerColor: Colors.red.withOpacity(0.5),
                  showHeader: false,
                  // height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 1.8),
                  ),
                  selectedChipColor: Colors.red.withOpacity(0.5),
                  onTap: (results) {
                    // print(results.elementAt(0)?.year);
                    // _selectedYears = results;
                  })),
          Container(
            padding: const EdgeInsets.only(top: 10, right: 20),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  // side: BorderSide(width: 8, color: Colors.yellow)
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Concluido',
                  style: TextStyle(color: Colors.white),
                )),
          )
        ],
      )),
    );
  }
}

class DrawerContent extends StatefulWidget {
  const DrawerContent({super.key});

  @override
  State<DrawerContent> createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  bool _isToNotify = false;
  bool _isLightMode = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: <Widget>[
                  Icon(
                    Icons.notifications,
                    color: Colors.grey.shade700,
                  ),
                  const Text('Notification'),
                ]),
                Switch(
                    value: _isToNotify,
                    onChanged: (isToNotify) {
                      setState(() {
                        _isToNotify = isToNotify;
                      });
                    })
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: <Widget>[
                  Icon(
                    Icons.dark_mode_rounded,
                    color: Colors.grey.shade700,
                  ),
                  const Text('Dark mode'),
                ]),
                Switch(
                    value: _isLightMode,
                    onChanged: (isLightMode) {
                      setState(() {
                        _isLightMode = isLightMode;
                      });
                    })
              ],
            )
          ]),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.topCenter,
      width: MediaQuery.of(context).size.width,
      // alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(child: const AlternatedAnualMensalButtons()),
            const LineGraphic(),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: const Column(
                children: <Widget>[
                  IncisoItem(label: 'Inciso I'),
                  IncisoItem(label: 'Inciso II'),
                  IncisoItem(label: 'Inciso III'),
                  IncisoItem(label: 'Inciso IV'),
                  IncisoItem(label: 'Inciso V'),
                  IncisoItem(label: 'Inciso VI'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AlternatedAnualMensalButtons extends StatefulWidget {
  const AlternatedAnualMensalButtons({super.key});

  @override
  State<AlternatedAnualMensalButtons> createState() =>
      _AlternatedAnualMensalButtonsState();
}

class _AlternatedAnualMensalButtonsState
    extends State<AlternatedAnualMensalButtons> {
  bool _isMonthSelected = false;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      TextButton(
          onPressed: () {
            setState(() {
              _isMonthSelected = true;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: _isMonthSelected ? Colors.red[300] : Colors.transparent,
                borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text('Mensal',
                style: TextStyle(
                    color: _isMonthSelected ? Colors.white : Colors.black,
                    decoration: !_isMonthSelected
                        ? TextDecoration.underline
                        : TextDecoration.none)),
          )),
      TextButton(
          onPressed: () {
            setState(() {
              _isMonthSelected = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: !_isMonthSelected ? Colors.red[300] : Colors.transparent,
                borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              'Anual',
              style: TextStyle(
                  color: _isMonthSelected ? Colors.black : Colors.white,
                  decoration: _isMonthSelected
                      ? TextDecoration.underline
                      : TextDecoration.none),
            ),
          ))
    ]);
  }
}

class CustomNavigationBar extends StatelessWidget {
  final int currentPageIndex;
  final Function(int) updateCurrentPageIndex;
  const CustomNavigationBar(
      {super.key,
      required this.currentPageIndex,
      required this.updateCurrentPageIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 80,
      decoration: const BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Color.fromARGB(255, 247, 102, 90), width: 1))),
      child: NavigationBar(
        onDestinationSelected: (int index) {
          updateCurrentPageIndex(index);
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(
                Icons.insert_drive_file,
              ),
              label: 'Documentos'),
          NavigationDestination(
              icon: Icon(
                Icons.star,
              ),
              label: 'Favoritos')
        ],
        backgroundColor: Colors.deepOrange[50],
        indicatorColor: const Color.fromARGB(255, 247, 102, 90),
      ),
    );
  }
}

class LineGraphic extends StatefulWidget {
  const LineGraphic({super.key});

  @override
  State<LineGraphic> createState() => _LineGraphicState();
}

class _LineGraphicState extends State<LineGraphic> {
  List<FlSpot> points = List<FlSpot>.generate(
      12, (int index) => FlSpot(index.toDouble(), (index + 1).toDouble()),
      growable: false);

  SideTitles get _monthsTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        String text = '';
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
          case 12:
            text = '';
            break;
        }
        return Text(text);
      });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        // color: Colors.grey,
        margin: const EdgeInsets.only(
          top: 24,
        ),
        padding: const EdgeInsets.only(right: 25),
        child: AspectRatio(
            aspectRatio: 3 / 4,
            child: LineChart(LineChartData(
                lineBarsData: [
                  LineChartBarData(
                      spots: points,
                      isCurved: false,
                      dotData: const FlDotData(show: true))
                ],
                borderData: FlBorderData(
                    border:
                        const Border(bottom: BorderSide(), left: BorderSide())),
                gridData: const FlGridData(show: true),
                titlesData: FlTitlesData(
                    // leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    bottomTitles: AxisTitles(sideTitles: _monthsTitles),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)))))),
      ),
    );
  }
}

class BarGraphic extends StatefulWidget {
  const BarGraphic({super.key});

  @override
  State<BarGraphic> createState() => _BarGraphicState();
}

class _BarGraphicState extends State<BarGraphic> {
  List<FlSpot> points = List<FlSpot>.generate(
      12, (int index) => FlSpot(index.toDouble(), (index + 1).toDouble()),
      growable: false);

  List<BarChartGroupData> _chartGroups() {
    return points
        .map((point) => BarChartGroupData(
            x: point.x.toInt(), barRods: [BarChartRodData(toY: point.y)]))
        .toList();
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
            bottomTitles: AxisTitles(sideTitles: _bottomTitles),
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

class IncisoItem extends StatefulWidget {
  final String label;
  const IncisoItem({super.key, required this.label});

  @override
  State<IncisoItem> createState() => _IncisoItemState();
}

class _IncisoItemState extends State<IncisoItem> {
  bool _isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: [
          Checkbox(
              value: _isChecked,
              onChanged: (isChecked) {
                setState(() {
                  _isChecked = isChecked!;
                });
              }),
          Text(widget.label)
        ],
      ),
    );
  }
}
