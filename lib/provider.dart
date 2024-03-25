import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';

class FilesTJ with ChangeNotifier {
  List<Map<String, dynamic>> _documents = [];
  bool _isMonthView = true;
  List<Year?> _yearsList = [Year(id: -2022, year: '2022')];
  final List<String> _incs = [
    'incisoi',
    'incisoii',
    'incisoiii',
    'incisoiv',
    'incisov',
    'incisovi'
  ];

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
        'id': row[11].toString(),
        'sigla': row[0],
        'orgao': row[1],
        'autoridade': row[2],
        'responsavel': row[3],
        'data': date,
        'incisoi': (row[5]),
        'incisoii': (row[6]),
        'incisoiii': (row[7]),
        'incisoiv': (row[8]),
        'incisov': (row[9]),
        'incisovi': (row[10]),
        'mes': converteMonthNumberToMonthStr(date.month)
      };
    }).toList();
  }

  Future<void> fetchDocuments() async {
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
      _documents = mapDocuments(results);
      notifyListeners();
      conn.close();
    } catch (e) {
      // print('requisição not ok');
      print('Error: ${e.toString()}');
      throw Exception('Something went wrong in db connection');
    }
  }

  List<Map<String, dynamic>> get documents => _documents;
  List<Map<String, dynamic>> get documents2018 =>
      _documents.where((element) => element['data'].year == 2018).toList();

  void setMonthView(value) {
    _isMonthView = value;
    notifyListeners();
  }

  bool get isMonthView => _isMonthView;

  void setYearsList(values) {
    _yearsList = values;
    notifyListeners();
  }

  List<Year?> get yearsList => _yearsList;

  List<String> get incs => _incs;

  void addInc(value) {
    _incs.add(value);
    notifyListeners();
  }

  void removeInc(value) {
    _incs.remove(value);
    notifyListeners();
  }
}

class Year {
  final int id;
  final String year;
  Year({required this.id, required this.year});
}
