import 'package:get/get.dart';
import 'package:myapp/cons/data.dart';
import 'package:pocketbase/pocketbase.dart';

const coll_etfs = 'etfs';

class PBC extends GetxController {
  late PocketBase pb;

  @override
  onInit() async {
    super.onInit();

    pb = PocketBase('https://pb.p1gd0g.cc');
  }

  Future<List<ETF>> getETFs() async {
    var r = await pb.collection(coll_etfs).getFullList();
    return r.map((e) => ETF.fromMap(e.toJson())).toList();
  }
}


