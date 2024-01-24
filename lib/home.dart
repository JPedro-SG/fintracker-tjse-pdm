import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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
          duration: Duration(milliseconds: 500), curve: Curves.ease);
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
        children: <Widget>[HomeBody(), Documents(), Favorite()]);
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
                        return SizedBox(
                          height: 200,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Text('Graphic config bottomsheet'),
                              ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cole config bottomsheet'))
                            ],
                          )),
                        );
                      });
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.red.shade900,
                ))
        ],
      ),
      body: buildPageView(),
      drawer: Drawer(child: DrawerContent()),
      // body: Column(children: [Progress(), TaskList()])
      bottomNavigationBar: CustomNavigationBar(
          currentPageIndex: _currentPageIndex,
          updateCurrentPageIndex: _updateCurrentPageIndexPageController),
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
                Text('Notification'),
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
                Text('Light Mode'),
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
            Graphic(),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
                  const IncisoItem(label: 'Inciso I'),
                  const IncisoItem(label: 'Inciso II'),
                  const IncisoItem(label: 'Inciso III'),
                  const IncisoItem(label: 'Inciso IV'),
                  const IncisoItem(label: 'Inciso V'),
                  const IncisoItem(label: 'Inciso VI'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PseudoScreen extends StatelessWidget {
  final String label;

  const PseudoScreen({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
        shadowColor: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: SizedBox.expand(
          child: Center(child: Text(label)),
        ));
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
      decoration: BoxDecoration(
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
        indicatorColor: Color.fromARGB(255, 247, 102, 90),

        // unselectedFontSize: 12,
        // selectedFontSize: 12,
        // selectedItemColor: Color.fromARGB(255, 247, 102, 90),
        // selectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
        // unselectedItemColor: Color.fromARGB(255, 193, 193, 193),
        // elevation: 0,
        // iconSize: 40,
        // backgroundColor: Color.fromARGB(0, 255, 252, 252),
      ),
    );
  }
}

// class CustomNavigationBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 80,
//       decoration: BoxDecoration(
//           border: Border(
//               top: BorderSide(
//                   color: Color.fromARGB(255, 247, 102, 90), width: 2))),
//       child: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.home,
//               ),
//               label: 'Home'),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.insert_drive_file,
//               ),
//               label: 'Documentos'),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.star,
//               ),
//               label: 'Favoritos')
//         ],
//         backgroundColor: Color.fromARGB(255, 255, 252, 252),
//         unselectedFontSize: 12,
//         selectedFontSize: 12,
//         selectedItemColor: Color.fromARGB(255, 247, 102, 90),
//         selectedLabelStyle: TextStyle(fontWeight: FontWeight.w300),
//         unselectedItemColor: Color.fromARGB(255, 193, 193, 193),
//         elevation: 0,
//         iconSize: 40,
//         // backgroundColor: Color.fromARGB(0, 255, 252, 252),
//       ),
//     );
//   }
// }

class Graphic extends StatelessWidget {
  List<FlSpot> points = List<FlSpot>.generate(12,
      (int index) => FlSpot((index + 2018).toDouble(), (index + 1).toDouble()),
      growable: false);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, right: 24),
      child: AspectRatio(
          aspectRatio: 3 / 4,
          child: LineChart(LineChartData(
              lineBarsData: [
                LineChartBarData(
                    spots: points,
                    isCurved: false,
                    dotData: FlDotData(show: true))
              ],
              borderData: FlBorderData(
                  border:
                      const Border(bottom: BorderSide(), left: BorderSide())),
              gridData: const FlGridData(show: true),
              titlesData: const FlTitlesData(
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)))))),
    );
  }
}

class IncisoItem extends StatelessWidget {
  final String label;

  const IncisoItem({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: [const Checkbox(value: true, onChanged: null), Text(label)],
      ),
    );
  }
}
