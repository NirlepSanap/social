import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _baseUrl = 'https://api.example.com'; // Replace with actual AI service URL
  static const String _apiKey = 'your-api-key-here'; // Replace with actual API key

  // Categorize report using AI
  static Future<String> categorizeReport(String title, String description) async {
    try {
      // Simulate AI categorization - in real app, call actual AI service
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay
      
      final text = '$title $description'.toLowerCase();
      
      if (text.contains('road') || text.contains('street') || text.contains('light') || text.contains('pothole')) {
        return 'Infrastructure';
      } else if (text.contains('trash') || text.contains('pollution') || text.contains('environment') || text.contains('tree')) {
        return 'Environment';
      } else if (text.contains('safety') || text.contains('security') || text.contains('danger') || text.contains('crime')) {
        return 'Safety';
      } else if (text.contains('school') || text.contains('education') || text.contains('teacher') || text.contains('student')) {
        return 'Education';
      } else if (text.contains('hospital') || text.contains('health') || text.contains('medical') || text.contains('clinic')) {
        return 'Health';
      } else if (text.contains('community') || text.contains('social') || text.contains('public')) {
        return 'Community';
      } else {
        return 'Other';
      }
    } catch (e) {
      print('Error categorizing report: $e');
      return 'Other'; // Default category
    }
  }

  // Determine priority using AI
  static Future<String> determinePriority(String title, String description, String category) async {
    try {
      // Simulate AI priority determination
      await Future.delayed(Duration(milliseconds: 500));
      
      final text = '$title $description'.toLowerCase();
      
      // Critical priority keywords
      if (text.contains('urgent') || text.contains('emergency') || text.contains('danger') || 
          text.contains('critical') || text.contains('life') || text.contains('death')) {
        return 'Critical';
      }
      
      // High priority keywords
      if (text.contains('safety') || text.contains('broken') || text.contains('damage') || 
          text.contains('serious') || text.contains('immediate') || text.contains('blocking')) {
        return 'High';
      }
      
      // Low priority keywords
      if (text.contains('minor') || text.contains('small') || text.contains('cosmetic') || 
          text.contains('aesthetic') || text.contains('suggestion')) {
        return 'Low';
      }
      
      // Default to medium
      return 'Medium';
    } catch (e) {
      print('Error determining priority: $e');
      return 'Medium'; // Default priority
    }
  }

  // Generate tags using AI
  static Future<List<String>> generateTags(String title, String description, String category) async {
    try {
      // Simulate AI tag generation
      await Future.delayed(Duration(milliseconds: 300));
      
      List<String> tags = [];
      final text = '$title $description'.toLowerCase();
      
      // Add category as tag
      tags.add(category.toLowerCase());
      
      // Extract keywords as tags
      if (text.contains('urgent')) tags.add('urgent');
      if (text.contains('safety')) tags.add('safety');
      if (text.contains('repair')) tags.add('repair');
      if (text.contains('maintenance')) tags.add('maintenance');
      if (text.contains('clean')) tags.add('cleanup');
      if (text.contains('fix')) tags.add('fix');
      if (text.contains('broken')) tags.add('broken');
      if (text.contains('water')) tags.add('water');
      if (text.contains('electric')) tags.add('electrical');
      if (text.contains('road')) tags.add('road');
      if (text.contains('park')) tags.add('park');
      if (text.contains('public')) tags.add('public');
      
      return tags.take(5).toList(); // Limit to 5 tags
    } catch (e) {
      print('Error generating tags: $e');
      return [category.toLowerCase()]; // Default to category only
    }
  }

  // Get AI suggestions for solving the problem
  static Future<List<String>> getSuggestions(String title, String description, String category) async {
    try {
      // Simulate AI suggestion generation
      await Future.delayed(Duration(seconds: 1));
      
      List<String> suggestions = [];
      
      switch (category.toLowerCase()) {
        case 'infrastructure':
          suggestions = [
            'Contact local municipal authority',
            'Report to public works department',
            'Document with photos and location',
            'Follow up with city council',
          ];
          break;
        case 'environment':
          suggestions = [
            'Contact environmental protection agency',
            'Organize community cleanup drive',
            'Report to waste management department',
            'Engage local environmental groups',
          ];
          break;
        case 'safety':
          suggestions = [
            'Report to local police immediately',
            'Contact emergency services if urgent',
            'Document evidence safely',
            'Alert neighborhood watch group',
          ];
          break;
        case 'education':
          suggestions = [
            'Contact school administration',
            'Reach out to parent-teacher association',
            'Report to education department',
            'Organize community meeting',
          ];
          break;
        default:
          suggestions = [
            'Contact relevant local authority',
            'Document the issue thoroughly',
            'Engage community members',
            'Follow proper reporting channels',
          ];
      }
      
      return suggestions;
    } catch (e) {
      print('Error getting suggestions: $e');
      return ['Contact local authorities for assistance'];
    }
  }

  // Analyze image using AI (placeholder)
  static Future<Map<String, dynamic>> analyzeImage(String imagePath) async {
    try {
      // Simulate AI image analysis
      await Future.delayed(Duration(seconds: 2));
      
      // Mock analysis results
      return {
        'objects_detected': ['street', 'pothole', 'road'],
        'category_suggestion': 'Infrastructure',
        'priority_suggestion': 'High',
        'description_enhancement': 'Large pothole detected on street surface, approximately 2 feet in diameter',
      };
    } catch (e) {
      print('Error analyzing image: $e');
      return {};
    }
  }

  // Match volunteers using AI
  static Future<List<String>> matchVolunteers(String category, String location, List<String> skills) async {
    try {
      // Simulate AI volunteer matching
      await Future.delayed(Duration(seconds: 1));
      
      // Mock matched volunteer IDs
      return ['volunteer1', 'volunteer2', 'volunteer3'];
    } catch (e) {
      print('Error matching volunteers: $e');
      return [];
    }
  }

  // Real implementation would look like this:
  /*
  static Future<String> _makeAIRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['result'];
      } else {
        throw Exception('AI service error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to AI service: $e');
    }
  }
  */
}