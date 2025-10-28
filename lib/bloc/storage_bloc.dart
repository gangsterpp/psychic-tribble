import 'package:b1c_test_app/repository/storage_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StorageBloc extends Bloc<String, List<String>> {
  final StorageRepository _repository;
  StorageBloc(this._repository) : super([]) {
    _repository.readAll().then((value) => emit([...state, ...value]));
    on<String>((e, emitter) async {
      await _repository.write(
        'promt_${DateTime.now().millisecondsSinceEpoch}',
        e,
      );
      emitter([...state, e]);
    });
  }
}
