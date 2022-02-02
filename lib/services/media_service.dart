import 'package:file_picker/file_picker.dart';

class MediaService {
  Future<PlatformFile?> pickImageFromLibrary() async {
    FilePickerResult? _result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (_result != null) {
      return _result.files.first;
    }
    return null;
  }
}
