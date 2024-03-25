import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import 'package:FinTracker/documents.dart';
import 'package:FinTracker/favorite.dart';
import 'package:FinTracker/provider.dart';
import 'package:FinTracker/components/BarGraphic.dart';
import 'package:FinTracker/components/LineGraphic.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageIndex = 0;
  bool _isLineChartSelected = true;

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

  void setIsLineChartSelected(value) {
    setState(() {
      _isLineChartSelected = value;
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

// Abaixo somente widgets

  Widget buildPageView() {
    return PageView(
        controller: pageController,
        onPageChanged: (index) {
          _updateCurrentPageIndex(index);
        },
        children: <Widget>[
          HomeBody(isLineChartSelected: _isLineChartSelected),
          const Documents(),
          const Favorite()
        ]);
  }

  // botões leading do AppBar (Ou botão de menu)
  Builder leadingBuilder() {
    return Builder(builder: (BuildContext context) {
      return IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: Icon(
            Icons.menu,
            color: Colors.red[900],
          ));
    });
  }

  //botões de ação do AppBar
  List<Widget>? actionsButton() {
    if (_currentPageIndex == 0) {
      return [
        IconButton(
            onPressed: () {
              final myModel = Provider.of<FilesTJ>(context, listen: false);
              showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return ListenableProvider.value(
                      value: myModel,
                      child: ConfigGraphicModal(
                        onSelectGraphic: setIsLineChartSelected,
                        isLineG: _isLineChartSelected,
                      ),
                    );
                  });
            },
            icon: Icon(
              Icons.settings,
              color: Colors.red.shade900,
            ))
      ];
    }

    return [];
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: leadingBuilder(),
        centerTitle: true,
        title: Text(
          updateAppBarTitle(),
          style: TextStyle(
            color: Colors.red[900],
          ),
        ),
        actions: actionsButton(),
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

// Modal de configuração do gráfico
class ConfigGraphicModal extends StatefulWidget {
  Function onSelectGraphic;
  final bool isLineG;
  ConfigGraphicModal(
      {super.key, required this.onSelectGraphic, required this.isLineG});

  @override
  State<ConfigGraphicModal> createState() => _ConfigGraphicModalState();
}

class _ConfigGraphicModalState extends State<ConfigGraphicModal> {
  bool _isBarChartSelected = false;

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

  @override
  void initState() {
    super.initState();
    _isBarChartSelected = !widget.isLineG;
  }

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
                        _isBarChartSelected = false;
                        widget.onSelectGraphic(true);
                      }),
                  icon: Icon(
                    Icons.line_axis,
                    color: !_isBarChartSelected
                        ? Colors.red[300]
                        : Colors.grey[400],
                  )),
              IconButton(
                  onPressed: () => setState(() {
                        _isBarChartSelected = true;
                        widget.onSelectGraphic(false);
                      }),
                  icon: Icon(
                    Icons.bar_chart,
                    color: _isBarChartSelected
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
                  initialValue: (context.watch<FilesTJ>().yearsList.isNotEmpty &&
                          context.watch<FilesTJ>().yearsList[0]?.id == -2022)
                      ? [_years[4]]
                      : context.watch<FilesTJ>().yearsList,
                  title: const Text('Anos'),
                  headerColor: Colors.red.withOpacity(0.5),
                  showHeader: false,

                  // height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 1.8),
                  ),
                  selectedChipColor: Colors.red.withOpacity(0.5),
                  onTap: (results) {

                    if (_isBarChartSelected) {
                      while(results.length >= 3) {
                        results.removeAt(0);
                      }
                    }

                    Provider.of<FilesTJ>(context, listen: false)
                        .setYearsList(results);

                    // context.read<FilesTJ>()._setYearsList(results);
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

// Conteudo do Drawer (Menu lateral)
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

// Conteudo Principal da pagina
class HomeBody extends StatelessWidget {
  final bool isLineChartSelected;
  const HomeBody({super.key, required this.isLineChartSelected});

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
            (isLineChartSelected) ? const LineGraphic() : const BarGraphic(),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: const Column(
                children: <Widget>[
                  IncisoItem(label: 'Inciso I', value: 'incisoi'),
                  IncisoItem(label: 'Inciso II', value: 'incisoii'),
                  IncisoItem(label: 'Inciso III', value: 'incisoiii'),
                  IncisoItem(label: 'Inciso IV', value: 'incisoiv'),
                  IncisoItem(label: 'Inciso V', value: 'incisov'),
                  IncisoItem(label: 'Inciso VI', value: 'incisovi'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// Botões de Anual e Mensal
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
              Provider.of<FilesTJ>(context, listen: false).setMonthView(true);
              // context.read<FilesTJ>().setMonthView(true);
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
              Provider.of<FilesTJ>(context, listen: false).setMonthView(false);
              // context.read<FilesTJ>()._setMonthView(false);
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

// Versão modificada da Barra de navegação
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

// Incisos (Checkbox)
class IncisoItem extends StatefulWidget {
  final String label;
  final String value;
  const IncisoItem({super.key, required this.label, required this.value});

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
                if (isChecked == true) {
                  context.read<FilesTJ>().addInc(widget.value);
                } else {
                  context.read<FilesTJ>().removeInc(widget.value);
                }
              }),
          Text(widget.label)
        ],
      ),
    );
  }
}
