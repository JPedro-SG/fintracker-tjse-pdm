import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:postgres/postgres.dart';
import 'package:provider/provider.dart';

import 'package:FinTracker/components/MonthExpansionItem.dart';
import 'package:FinTracker/provider.dart';

List<String> years = <String>['2018', '2019', '2020', '2021', '2022', '2023'];
List<Month> months = [
  Month(id: 1, name: 'Janeiro'),
  Month(id: 2, name: 'Fevereiro'),
  Month(id: 3, name: 'Março'),
  Month(id: 4, name: 'Abril'),
  Month(id: 5, name: 'Maio'),
  Month(id: 6, name: 'Junho'),
  Month(id: 7, name: 'Julho'),
  Month(id: 8, name: 'Agosto'),
  Month(id: 9, name: 'Setembro'),
  Month(id: 10, name: 'Outubro'),
  Month(id: 11, name: 'Novembro'),
  Month(id: 12, name: 'Dezembro'),
];

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  List<Map<String, dynamic>> _documents = [];
  List<Month?> _selectedMonths = [];
  String _selectedYear = years.first;

  @override
  void initState() {
    super.initState();
    // _fetchDocuments();
    _selectedMonths = months;
  }

  void setSelectedYear(String value) {
    setState(() {
      _selectedYear = value;
    });
  }

  void setSelectedMonths(List<Month?> value) {
    setState(() => _selectedMonths = value);
  }

  String converteMonthNumberToMonthStr(int monthNumber) {
    switch (monthNumber) {
      case 1:
        return 'Janeiro';
      case 2:
        return 'Fevereiro';
      case 3:
        return 'Março';
      case 4:
        return 'Abril';
      case 5:
        return 'Maio';
      case 6:
        return 'Junho';
      case 7:
        return 'Julho';
      case 8:
        return 'Agosto';
      case 9:
        return 'Setembro';
      case 10:
        return 'Outubro';
      case 11:
        return 'Novembro';
      case 12:
        return 'Dezembro';
      default:
        return 'error';
    }
  }

  List<Map<String, dynamic>> mapDocuments(List<List<dynamic>> results) {
    return results.map((row) {
      DateTime date = row[4];
      return {
        'sigla': row[0],
        'orgao': row[1],
        'autoridade': row[2],
        'responsavel': row[3],
        'data': date,
        'inicisoi': (row[5]),
        'inicisoii': (row[6]),
        'inicisoiii': (row[7]),
        'inicisoiv': (row[8]),
        'inicisov': (row[9]),
        'inicisovi': (row[10]),
        'mes': converteMonthNumberToMonthStr(date.month)
      };
    }).toList();
  }

  Future<void> _fetchDocuments() async {
    try {
      Connection conn = await Connection.open(
          Endpoint(
              port: 5432,
              host: '10.0.2.2',
              database: 'fintracker-db',
              username: 'postgres',
              password: 'dgcs9922'),
          settings: const ConnectionSettings(sslMode: SslMode.disable));

      final results = await conn.execute('SELECT * FROM tb_documento;');

      // print(mapDocuments(results));
      setState(() {
        _documents = mapDocuments(results);
      });
      conn.close();
    } catch (e) {
      // print('requisição not ok');
      print('Error: ${e.toString()}');
      throw Exception('Something went wrong in db connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> documentsByYear = context
        .read<FilesTJ>()
        .documents
        .where((element) => element['data']?.year == int.parse(_selectedYear))
        .toList();

    List<int?> filteredMonths =
        _selectedMonths.map((element) => element?.id).toList();

    print(filteredMonths);
    List<Map<String, dynamic>> documentsFiltered = documentsByYear
        .where((element) => filteredMonths.contains(element['data'].month))
        .toList();

    documentsFiltered.sort((a, b) => a['data'].compareTo(b['data']));
    //  print(documentsFiltered);

    List<Widget> WidgetList = List.generate(
        documentsFiltered.length,
        (index) => MonthExpansionItem(
              month: documentsFiltered[index]['mes'],
              autority: documentsFiltered[index]['autoridade'],
              org: documentsFiltered[index]['orgao'],
              responsible: documentsFiltered[index]['responsavel'],
              id: documentsFiltered[index]['id'],
            )).toList();
    return ListView(
      children: <Widget>[
        YearDropdownButton(onSelectYear: setSelectedYear),
        MultSelectMonths(onSelectMonths: setSelectedMonths),
        const FilterButton(),
        ...WidgetList,
      ],
    );
  }
}

// Dropdown para esocolher os anos
// Adicionar ações para os botões de foward e back!!!
class YearDropdownButton extends StatefulWidget {
  final Function onSelectYear;
  const YearDropdownButton({super.key, required this.onSelectYear});

  @override
  State<YearDropdownButton> createState() => _YearDropdownButtonState();
}

class _YearDropdownButtonState extends State<YearDropdownButton> {
  String dropdownValue = years.first;

  void setDropdownValueByArrows(String direction) {
    int index = years.indexWhere((element) => element == dropdownValue);
    if (direction.toLowerCase() == 'right') {
      index++;
      if (index >= years.length) return;
    } else {
      index--;
      if (index < 0) return;
    }

    setState(() {
      dropdownValue = years[index];
    });
    widget.onSelectYear(years[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () => setDropdownValueByArrows('left'),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey[800],
              )),
          DropdownButton<String>(
              value: dropdownValue,
              elevation: 16,
              icon: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Icon(Icons.calendar_month)),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
                widget.onSelectYear(dropdownValue);
              },
              items: years.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList()),
          IconButton(
              onPressed: () => setDropdownValueByArrows('right'),
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[800],
              )),
        ],
      ),
    );
  }
}

class Month {
  final int id;
  final String name;
  Month({required this.id, required this.name});
}

class MultSelectMonths extends StatefulWidget {
  final Function onSelectMonths;
  const MultSelectMonths({super.key, required this.onSelectMonths});

  @override
  State<MultSelectMonths> createState() => _MultSelectMonthsState();
}

class _MultSelectMonthsState extends State<MultSelectMonths> {
  final isFirstTimeRendered = true;

  final _items =
      months.map((month) => MultiSelectItem(month, month.name)).toList();
  final _multiSelectKey = GlobalKey<FormFieldState>();
  // List<Month?> _selectedMonths = months;

  // @override
  // void initState() {
  //   super.initState();
  //   widget.onSelectMonths(months);
  // }

  @override
  Widget build(BuildContext context) {
    return MultiSelectChipField<Month?>(
      key: _multiSelectKey,
      items: _items,
      initialValue: months,
      onTap: (values) {
        // print(values);
        widget.onSelectMonths(values);
      },
      selectedChipColor: Colors.red.withOpacity(0.5),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.transparent)),
      showHeader: false,
    );
  }
}

// Botão de Filtrar e modal
class FilterButton extends StatelessWidget {
  const FilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Align(
        alignment: Alignment.topRight,
        child: ElevatedButton.icon(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const FilterModal();
                  });
            },
            // style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.green, // background color
            //     foregroundColor: Colors.white),
            icon: Icon(
              Icons.filter_alt,
              color: Colors.red[900],
            ),
            label: Text(
              'Filtrar',
              style: TextStyle(color: Colors.red[900]),
            )),
      ),
    );
  }
}

class FilterModal extends StatefulWidget {
  const FilterModal({super.key});
  @override
  State<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final _siglaController = TextEditingController();
  final _orgaoController = TextEditingController();
  final _autMaxController = TextEditingController();
  final _responsavelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 440,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Sigla'),
              TextField(
                controller: _siglaController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const Text('Nome do Orgão'),
              TextField(
                controller: _orgaoController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const Text('Autoridade Máxima'),
              TextField(
                controller: _autMaxController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const Text('Responsável pela informação'),
              TextField(
                controller: _responsavelController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: Text(
                    'Filtrar',
                    style: TextStyle(color: Colors.red[900]),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
