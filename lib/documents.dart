import 'package:flutter/material.dart';
import 'package:FinTracker/components/MonthExpansionItem.dart';

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
      children: [
        const YearDropdownButton(),
        FilterButton(),
        const MonthExpansionItem(month: 'Janeiro'),
        const MonthExpansionItem(month: 'Fevereiro'),
        const MonthExpansionItem(month: 'Março'),
        const MonthExpansionItem(month: 'Abril'),
        const MonthExpansionItem(month: 'Maio'),
        const MonthExpansionItem(month: 'Junho'),
        const MonthExpansionItem(month: 'Julho'),
        const MonthExpansionItem(month: 'Agosto'),
        const MonthExpansionItem(month: 'Setembro'),
        const MonthExpansionItem(month: 'Outubro'),
        const MonthExpansionItem(month: 'Novembro'),
        const MonthExpansionItem(month: 'Dezembro'),
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

// Botão de Filtrar e modal
class FilterButton extends StatelessWidget {
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
