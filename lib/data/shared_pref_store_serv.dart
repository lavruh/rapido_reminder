import 'package:rapido_reminder/data/i_store_serv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefStoreServ implements IStoreServ {
  SharedPrefStoreServ() {
    SharedPreferences.getInstance().then((value) => _db = value);
  }

  late final SharedPreferences _db;

  @override
  create(Map<String, dynamic> map) async {
    final id = map['id'];
    if (id == null) throw Exception('No id field found in $map');
    await _db.setStringList(id.toString(), _mapToList(map));
  }

  @override
  delete(String id) {
    _db.remove(id);
  }

  @override
  Future<Map<String, dynamic>> read(String id) async {
    final data = _db.getStringList(id);
    if (data == null) throw Exception('No data with key [$id] found');
    return _listToMap(data);
  }

  @override
  Stream<Map<String, dynamic>> readAll() async* {
    final keys = _db.getKeys();
    for (final k in keys) {
      yield await read(k);
    }
  }

  @override
  update(Map<String, dynamic> map) {
    // TODO: implement update
    throw UnimplementedError();
  }

  List<String> _mapToList(Map<String, dynamic> m) {
    return [
      m['id'].toString(),
      m['title'].toString(),
      m['date'].toString(),
      m['duration'].toString()
    ];
  }

  Map<String, dynamic> _listToMap(List<String> l) {
    return {
      'id': int.tryParse(l[0]),
      'title': l[1],
      'date': int.parse(l[2]),
      'duration': int.parse(l[3])
    };
  }
}
