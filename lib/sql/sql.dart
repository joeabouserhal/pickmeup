import 'package:mysql1/mysql1.dart';

class SQL {
  void main(List<String> args) async {
    var settings = ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'bob',
        password: 'wibble',
        db: 'mydb');

    var conn = await MySqlConnection.connect(settings);
  }
}
