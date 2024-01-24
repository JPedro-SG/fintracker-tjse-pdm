import 'package:flutter/material.dart';

class Favorite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ExpansionTile(
          title: Text('2018'),
          children: [
            CustomListItem(month: 'Janeiro'),
            CustomListItem(month: 'Outubro')
          ],
        ),
        ExpansionTile(
          title: Text('2019'),
          children: [
            CustomListItem(month: 'Agosto'),
            CustomListItem(month: 'Outubro')
          ],
        ),
        ExpansionTile(
          title: Text('2020'),
          children: [
            CustomListItem(month: 'Fevereiro'),
            CustomListItem(month: 'Março')
          ],
        ),
        ExpansionTile(
          title: Text('2021'),
          children: [
            CustomListItem(month: 'Março'),
            CustomListItem(month: 'Dezembro')
          ],
        )
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
