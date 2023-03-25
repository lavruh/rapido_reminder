abstract class IStoreServ {
  create(Map<String, dynamic> map);
  Future<Map<String, dynamic>> read(String id);
  Stream<Map<String, dynamic>> readAll();
  update(Map<String, dynamic> map);
  delete(String id);
}
