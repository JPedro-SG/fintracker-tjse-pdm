import 'package:flutter/material.dart';

class MonthExpansionItem extends StatefulWidget {
  final String month;
  final String org;
  final String autority;
  final String responsible;
  final String id;
  const MonthExpansionItem({
    super.key,
    required this.month,
    required this.org,
    required this.autority,
    required this.responsible,
    required this.id,
  });

  @override
  State<MonthExpansionItem> createState() => _MonthExpansionItemState();
}

class _MonthExpansionItemState extends State<MonthExpansionItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 10),
      elevation: 1,
      child: ExpansionTile(
        title: Text(widget.month),
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
            const EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 5),
        children: <Widget>[
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              widget.org,
              style: const TextStyle(color: Colors.white),
            ),
            Text(widget.autority, style: const TextStyle(color: Colors.white)),
            Text(widget.responsible,
                style: const TextStyle(color: Colors.white)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Visualizar',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
                Row(children: [
                  TextButton.icon(
                      onPressed: null,
                      icon: const Icon(Icons.download),
                      label: const Text('Baixar')),
                  const IconButton(onPressed: null, icon: Icon(Icons.star))
                ]),
              ],
            )
          ])
        ],
      ),
    );
  }
}
