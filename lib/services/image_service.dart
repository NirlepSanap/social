import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageService {
  static const String _cloudinaryUrl = 'https://api.cloudinary.com/v1_1/your-cloud-name/image/upload';
  static const String _uploadPreset = 'your-upload-preset';

  static final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  static Future<XFile?> pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      return image;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  // Pick image from camera
  static Future<XFile?> pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      return image;
    } catch (e) {
      print('Error picking image from camera: $e');
      return null;
    }
  }

  // Pick multiple images
  static Future<List<XFile>?> pickMultipleImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      return images;
    } catch (e) {
      print('Error picking multiple images: $e');
      return null;
    }
  }

  // Show image source selection dialog
  static Future<XFile?> showImageSourceDialog(context) async {
    return await showDialog<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await pickFromCamera();
                  Navigator.pop(context, image);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await pickFromGallery();
                  Navigator.pop(context, image);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Upload image to cloud storage (Cloudinary example)
  static Future<String?> uploadImage(XFile imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(_cloudinaryUrl),
        body: {
          'file': 'data:image/jpeg;base64,$base64Image',
          'upload_preset': _uploadPreset,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['secure_url'];
      } else {
        print('Upload failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Upload multiple images
  static Future<List<String>> uploadMultipleImages(List<XFile> imageFiles) async {
    List<String> uploadedUrls = [];
    
    for (XFile imageFile in imageFiles) {
      final url = await uploadImage(imageFile);
      if (url != null) {
        uploadedUrls.add(url);
      }
    }
    
    return uploadedUrls;
  }

  // Compress image before upload
  static Future<Uint8List?> compressImage(XFile imageFile, {int quality = 80}) async {
    try {
      final bytes = await imageFile.readAsBytes();
      
      // In a real app, you might use image compression packages like:
      // - flutter_image_compress
      // - image (dart package)
      
      // For now, just return the original bytes
      // In production, implement actual compression logic
      return bytes;
    } catch (e) {
      print('Error compressing image: $e');
      return null;
    }
  }

  // Get image info
  static Future<Map<String, dynamic>?> getImageInfo(XFile imageFile) async {
    try {
      final file = File(imageFile.path);
      final stats = await file.stat();
      final bytes = await imageFile.readAsBytes();

      return {
        'name': imageFile.name,
        'path': imageFile.path,
        'size': stats.size,
        'sizeInMB': (stats.size / (1024 * 1024)).toStringAsFixed(2),
        'lastModified': stats.modified,
        'mimeType': imageFile.mimeType ?? 'image/jpeg',
        'width': null, // Would require image processing package
        'height': null, // Would require image processing package
      };
    } catch (e) {
      print('Error getting image info: $e');
      return null;
    }
  }

  // Delete image from cloud storage
  static Future<bool> deleteImage(String imageUrl) async {
    try {
      // Extract public ID from Cloudinary URL
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final publicId = pathSegments.last.split('.').first;

      // In real implementation, use Cloudinary's admin API to delete
      // For now, just return success
      await Future.delayed(Duration(milliseconds: 500)); // Simulate API call
      return true;
    } catch (e) {
      print('Error deleting image: $e');
      return false;
    }
  }

  // Generate thumbnail URL (for Cloudinary)
  static String generateThumbnailUrl(String imageUrl, {int width = 200, int height = 200}) {
    if (imageUrl.contains('cloudinary.com')) {
      // Insert transformation parameters before the image filename
      final parts = imageUrl.split('/upload/');
      if (parts.length == 2) {
        return '${parts[0]}/upload/c_fill,w_$width,h_$height/${parts[1]}';
      }
    }
    return imageUrl; // Return original if not a Cloudinary URL
  }

  // Validate image file
  static bool isValidImage(XFile imageFile) {
    final validExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
    final fileName = imageFile.name.toLowerCase();
    
    return validExtensions.any((ext) => fileName.endsWith(ext));
  }

  // Check image size
  static Future<bool> isImageSizeValid(XFile imageFile, {int maxSizeInMB = 10}) async {
    try {
      final file = File(imageFile.path);
      final stats = await file.stat();
      final sizeInMB = stats.size / (1024 * 1024);
      
      return sizeInMB <= maxSizeInMB;
    } catch (e) {
      print('Error checking image size: $e');
      return false;
    }
  }

  // Create image placeholder URL
  static String createPlaceholderUrl(int width, int height, {String? text}) {
    final placeholderText = text ?? '${width}x$height';
    return 'https://via.placeholder.com/${width}x$height/CCCCCC/666666?text=$placeholderText';
  }

  // Process image for report (compress, upload, etc.)
  static Future<String?> processReportImage(XFile imageFile) async {
    try {
      // Validate image
      if (!isValidImage(imageFile)) {
        throw Exception('Invalid image format');
      }

      // Check size
      if (!await isImageSizeValid(imageFile)) {
        throw Exception('Image size too large');
      }

      // Compress if needed
      final compressedBytes = await compressImage(imageFile);
      if (compressedBytes == null) {
        throw Exception('Failed to compress image');
      }

      // Upload to cloud storage
      final imageUrl = await uploadImage(imageFile);
      if (imageUrl == null) {
        throw Exception('Failed to upload image');
      }

      return imageUrl;
    } catch (e) {
      print('Error processing report image: $e');
      return null;
    }
  }
}