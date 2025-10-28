abstract interface class ImageGeneratorRepository {
  Future<String> generate(String value);
}

class ImageGeneratorRepositoryImpl implements ImageGeneratorRepository {
  @override
  Future<String> generate(String value) async {
    return 'https://picsum.photos/200/300?random=${DateTime.now().millisecondsSinceEpoch}';
  }
}
