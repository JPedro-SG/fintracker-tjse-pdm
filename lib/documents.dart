import 'package:flutter/material.dart';

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
  int counter = -1;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        CustomDropdownButton(),
        FilterButton(),
        CustomListItem(month: 'Janeiro'),
        CustomListItem(month: 'Fevereiro'),
        CustomListItem(month: 'Março'),
        CustomListItem(month: 'Abril'),
        CustomListItem(month: 'Maio'),
        CustomListItem(month: 'Junho'),
        CustomListItem(month: 'Julho'),
        CustomListItem(month: 'Agosto'),
        CustomListItem(month: 'Setembro'),
        CustomListItem(month: 'Outubro'),
        CustomListItem(month: 'Novembro'),
        CustomListItem(month: 'Dezembro'),
      ],
    );
  }
}

class CustomListItem extends StatelessWidget {
  final String month;

  const CustomListItem({super.key, required this.month});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
      elevation: 1,
      child: ExpansionTile(
        title: Text(month),
        backgroundColor: Colors.red[400],
        collapsedBackgroundColor: Colors.red[400],
        textColor: Colors.white,
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        collapsedTextColor: Colors.white,
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        expandedAlignment: Alignment.centerLeft,
        childrenPadding:
            EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 20),
        children: <Widget>[
          Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Orgão: TJSE',
                style: TextStyle(color: Colors.white),
              ),
              const Text('Aut. Max: Ulysses ---',
                  style: TextStyle(color: Colors.white)),
              const Text('Responsável: Ulysses ---',
                  style: TextStyle(color: Colors.white)),
            ]),
          )
          // Text('Aut. Max: Ulysses ---'),
          // Text('Responsável: Ulysses ---'),
        ],
        // trailing: Icon(Icons.keyboard_arrow_down),
        // contentPadding: EdgeInsets.all(10),
        // onTap: () {
        //   print('Clicadooo');
        // },
      ),
    );
  }
}

class CustomDropdownButton extends StatefulWidget {
  const CustomDropdownButton({super.key});

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
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

class _CustomDropdownButtonState extends State<CustomDropdownButton> {
  String dropdownValue = years.first;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: null, icon: Icon(Icons.arrow_back_ios)),
          DropdownButton<String>(
              value: dropdownValue,
              elevation: 16,
              icon: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.calendar_month)),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: years.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList()),
          IconButton(onPressed: null, icon: Icon(Icons.arrow_forward_ios)),
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
                    return ModalContent();
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

class ModalContent extends StatefulWidget {
  const ModalContent({super.key});
  @override
  State<ModalContent> createState() => _ModalContentState();
}

class _ModalContentState extends State<ModalContent> {
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
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              const Text('Nome do Orgão'),
              TextField(
                controller: _orgaoController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              const Text('Autoridade Máxima'),
              TextField(
                controller: _autMaxController,
                decoration: InputDecoration(border: OutlineInputBorder()),
              ),
              const Text('Responsável pela informação'),
              TextField(
                controller: _responsavelController,
                decoration: InputDecoration(border: OutlineInputBorder()),
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
