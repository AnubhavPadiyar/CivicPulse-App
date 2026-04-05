class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final int points;
  final List<String> badges;
  final String? department;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.points,
    required this.badges,
    this.department,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
        id: j['id'] ?? j['_id'] ?? '',
        name: j['name'] ?? '',
        email: j['email'] ?? '',
        role: j['role'] ?? 'citizen',
        points: j['points'] ?? 0,
        badges: List<String>.from(j['badges'] ?? []),
        department: j['department'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'points': points,
        'badges': badges,
        'department': department,
      };
}

class Complaint {
  final String id;
  final String trackingId;
  final String rawText;
  final String? formalComplaint;
  final String category;
  final String priority;
  final String? authority;
  final String? department;
  final List<String> sdgTags;
  final String? sdgMessage;
  final String status;
  final String? locationAddress;
  final double? lat;
  final double? lng;
  final String? imageUrl;
  final String? adminNotes;
  final DateTime createdAt;

  Complaint({
    required this.id,
    required this.trackingId,
    required this.rawText,
    this.formalComplaint,
    required this.category,
    required this.priority,
    this.authority,
    this.department,
    required this.sdgTags,
    this.sdgMessage,
    required this.status,
    this.locationAddress,
    this.lat,
    this.lng,
    this.imageUrl,
    this.adminNotes,
    required this.createdAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> j) {
    final loc = j['location'] as Map<String, dynamic>?;
    return Complaint(
      id: j['_id'] ?? '',
      trackingId: j['trackingId'] ?? '',
      rawText: j['rawText'] ?? '',
      formalComplaint: j['formalComplaint'],
      category: j['category'] ?? 'Other',
      priority: j['priority'] ?? 'Medium',
      authority: j['authority'],
      department: j['department'],
      sdgTags: List<String>.from(j['sdgTags'] ?? []),
      sdgMessage: j['sdgMessage'],
      status: j['status'] ?? 'Submitted',
      locationAddress: loc?['address'],
      lat: (loc?['lat'] as num?)?.toDouble(),
      lng: (loc?['lng'] as num?)?.toDouble(),
      imageUrl: j['imageUrl'],
      adminNotes: j['adminNotes'],
      createdAt: j['createdAt'] != null
          ? DateTime.tryParse(j['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String get categoryEmoji {
    switch (category) {
      case 'Roads & Infrastructure': return '🛣️';
      case 'Water Supply': return '💧';
      case 'Garbage & Waste': return '🗑️';
      case 'Drainage & Sewage': return '🌊';
      case 'Electricity & Streetlights': return '⚡';
      default: return '📋';
    }
  }
}
