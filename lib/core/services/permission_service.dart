import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'logging_service.dart';

class PermissionService {
  final Ref _ref;
  final ImagePicker _picker = ImagePicker();

  PermissionService(this._ref);

  // Check and Request Gallery/Storage Permission
  Future<bool> requestStoragePermission() async {
    final log = _ref.read(loggerProvider);
    log.i("Requesting storage/photos permission...");
    
    // In Android 13+ (SDK 33+), we should check photos permission
    final status = await Permission.photos.status;
    if (status.isGranted) {
      log.i("Storage/Photos permission already granted.");
      return true;
    }
    
    final requestStatus = await Permission.photos.request();
    if (requestStatus.isGranted) {
      log.i("Storage/Photos permission granted by user.");
      return true;
    } else {
      log.w("Storage/Photos permission denied.");
      // Fallback for older Android versions
      final oldStatus = await Permission.storage.request();
      log.i("Older storage permission status: $oldStatus");
      return oldStatus.isGranted;
    }
  }

  // Pick an image from gallery
  Future<String?> pickImageFromGallery() async {
    final log = _ref.read(loggerProvider);
    final hasPermission = await requestStoragePermission();
    
    if (!hasPermission) {
      log.w("Cannot pick image: Storage permission denied.");
      return null;
    }

    try {
      log.i("Opening Gallery via ImagePicker...");
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (image != null) {
        log.i("Successfully picked image: ${image.path}");
        return image.path;
      }
      log.i("User cancelled image picking.");
      return null;
    } catch (e, stackTrace) {
      log.e("Error picking image from gallery", e, stackTrace);
      return null;
    }
  }
}

// Provider for PermissionService
final permissionServiceProvider = Provider<PermissionService>((ref) => PermissionService(ref));
