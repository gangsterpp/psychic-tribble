import 'dart:math';

import 'package:b1c_test_app/repository/image_generator_repository.dart';
import 'package:bloc/bloc.dart';

sealed class ImageEvent {}

class ImageGeneratePromtEvent implements ImageEvent {
  final String value;

  const ImageGeneratePromtEvent(this.value);

  @override
  String toString() {
    return value;
  }
}

class ImageRegeneratePromt implements ImageEvent {
  const ImageRegeneratePromt();
}

sealed class ImageState {}

class ImageIdle implements ImageState {
  const ImageIdle();
}

class ImageLoading implements ImageState {
  const ImageLoading();
}

class ImageError implements ImageState {
  final String message;

  const ImageError(this.message);
}

class ImageSuccess implements ImageState {
  final String _url;

  const ImageSuccess(this._url);

  @override
  String toString() {
    return _url;
  }
}

class ImageGeneratorBloc extends Bloc<ImageEvent, ImageState> {
  final ImageGeneratorRepository _repository;
  var _currentPromt = '';

  String get currentPromt => _currentPromt;

  ImageGeneratorBloc(this._repository, super.initialState) {
    on<ImageEvent>((event, emitter) async {
      emitter(const ImageIdle());
      switch (event) {
        case ImageGeneratePromtEvent event:
          _currentPromt = '$event';
          try {
            emitter(const ImageLoading());
            final url = await _generate(event.value);
            emitter(ImageSuccess(url));
          } catch (e) {
            emitter(ImageError('$e'));
          }
        case ImageRegeneratePromt():
          try {
            emitter(const ImageLoading());
            final url = await _generate(_currentPromt);
            emitter(ImageSuccess(url));
          } catch (e) {
            emitter(ImageError('$e'));
          }
      }
    });
  }

  Future<String> _generate(String value) async {
    await Future.delayed(Duration(seconds: 2));
    final isError = Random().nextBool();

    if (isError) {
      throw Exception('We have an error');
    }

    return await _repository.generate(value);
  }
}
