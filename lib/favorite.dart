import 'package:flutter/material.dart';
import 'package:FinTracker/components/MonthExpansionItem.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        ExpansionTile(
          title: Text('2018'),
          children: [
            MonthExpansionItem(month: 'Janeiro'),
            MonthExpansionItem(month: 'Outubro')
          ],
        ),
        ExpansionTile(
          title: Text('2019'),
          children: [
            MonthExpansionItem(month: 'Agosto'),
            MonthExpansionItem(month: 'Outubro')
          ],
        ),
        ExpansionTile(
          title: Text('2020'),
          children: [
            MonthExpansionItem(month: 'Fevereiro'),
            MonthExpansionItem(month: 'Março')
          ],
        ),
        ExpansionTile(
          title: Text('2021'),
          children: [
            MonthExpansionItem(month: 'Março'),
            MonthExpansionItem(month: 'Dezembro')
          ],
        )
      ],
    );
  }
}