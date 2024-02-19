import 'package:flutter/material.dart';
import 'package:FinTracker/components/MonthExpansionItem.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class Documents extends StatelessWidget {
  final List<Map<String, dynamic>> months = <Map<String, dynamic>>[
    {'month': 'Janeiro'},
    {'month': 'Fevereiro'},
    {'month': 'Março'},
    {'month': 'Abril'},
    {'month': 'Maio'},
    {'month': 'Junho'},
    {'month': 'Julho'},
    {'month': 'Agosto'},
    {'month': 'Setembro'},
    {'month': 'Outubro'},
    {'month': 'Novembro'},
    {'month': 'Dezembro'}
  ];

  final List<Widget> item = List.generate(
      12,
      (index) => Container(
            child: Text('My title is $index'),
          ));

  Documents({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        YearDropdownButton(),
        MultSelectMonths(),
        FilterButton(),
        MonthExpansionItem(month: 'Janeiro'),
        MonthExpansionItem(month: 'Fevereiro'),
        MonthExpansionItem(month: 'Março'),
        MonthExpansionItem(month: 'Abril'),
        MonthExpansionItem(month: 'Maio'),
        MonthExpansionItem(month: 'Junho'),
        MonthExpansionItem(month: 'Julho'),
        MonthExpansionItem(month: 'Agosto'),
        MonthExpansionItem(month: 'Setembro'),
        MonthExpansionItem(month: 'Outubro'),
        MonthExpansionItem(month: 'Novembro'),
        MonthExpansionItem(month: 'Dezembro'),
      ],
    );
  }
}

const List<String> years = <String>[
  '2018',
  '2019',
  '2020',
  '2021',
  '2022',
  '2023'
];

// Dropdown para esocolher os anos
// Adicionar ações para os botões de foward e back!!!
class YearDropdownButton extends StatefulWidget {
  const YearDropdownButton({super.key});

  @override
  State<YearDropdownButton> createState() => _YearDropdownButtonState();
}

class _YearDropdownButtonState extends State<YearDropdownButton> {
  String dropdownValue = years.first;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios)),
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
              },
              items: years.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList()),
          const IconButton(
              onPressed: null, icon: Icon(Icons.arrow_forward_ios)),
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
  const MultSelectMonths({super.key});

  @override
  State<MultSelectMonths> createState() => _MultSelectMonthsState();
}

class _MultSelectMonthsState extends State<MultSelectMonths> {
  static final List<Month> _months = [
    Month(id: 0, name: 'Todos'),
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

  final _items =
      _months.map((month) => MultiSelectItem(month, month.name)).toList();
  final _multiSelectKey = GlobalKey<FormFieldState>();
  List<Month?> _selectedMonths = _months;
  @override
  Widget build(BuildContext context) {
    return MultiSelectChipField<Month?>(
      key: _multiSelectKey,
      items: _items,
      onSaved: (values) {
        print('onconfirmed');
        print(values);
      },
      onTap: (values) {
        setState(() => _selectedMonths = values);
        // print(_selectedMonths.length);
        // print(values.length);
        // if(_selectedMonths.length != values.length) {
        //   values.removeAt(0);
        // }

        // if (_selectedMonths.map((item) => item?.name).contains('Todos')) {
        //   List<Month?> temp = _selectedMonths;
        //   print(temp);
        //   temp.removeAt(_selectedMonths.map((item) => item?.id).toList().indexOf(0));
          
        //   setState(() => _selectedMonths = temp);
        //   values.clear();
        //   values.addAll(_selectedMonths);
        //   // setState(() {
        //   //   _selectedMonths = values;
        //   // });
        //   print(values);
        // }
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
