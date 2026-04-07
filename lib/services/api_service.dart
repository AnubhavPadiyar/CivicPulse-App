import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ApiService {
  // ← Updated to ngrok URL
  static const String baseUrl = 'https://lineally-unlocal-keva.ngrok-free.dev/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cp_token');
  }

  static Future<void> saveAuth(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cp_token', token);
    await prefs.setString('cp_user', jsonEncode(user.toJson()));
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cp_token');
    await prefs.remove('cp_user');
  }

  static Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString('cp_user');
    if (str == null) return null;
    return User.fromJson(jsonDecode(str));
  }

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      };

  static Future<Map<String, String>> get _authHeaders async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // AUTH
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: _headers,
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode != 200) throw data['message'] ?? 'Login failed';
    return data;
  }

  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    final res = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: _headers,
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode != 201) throw data['message'] ?? 'Registration failed';
    return data;
  }

  static Future<User> getMe() async {
    final res = await http.get(
      Uri.parse('$baseUrl/auth/me'),
      headers: await _authHeaders,
    );
    final data = jsonDecode(res.body);
    if (res.statusCode != 200) throw data['message'] ?? 'Failed';
    return User.fromJson(data['user']);
  }

  // COMPLAINTS
  static Future<Complaint> submitComplaint({
    required String rawText,
    String? category,
    String? locationAddress,
    double? lat,
    double? lng,
    File? image,
  }) async {
    final headers = await _authHeaders;
    final body = <String, dynamic>{
      'rawText': rawText,
      if (category != null) 'category': category,
      if (locationAddress != null) 'locationAddress': locationAddress,
      if (lat != null) 'locationLat': lat,
      if (lng != null) 'locationLng': lng,
    };
    final res = await http.post(
      Uri.parse('$baseUrl/complaints'),
      headers: headers,
      body: jsonEncode(body),
    );
    final data = jsonDecode(res.body);
    if (res.statusCode != 201) throw data['message'] ?? 'Submission failed';
    return Complaint.fromJson(data['complaint']);
  }

  static Future<Complaint> trackComplaint(String trackingId) async {
    final res = await http.get(
      Uri.parse('$baseUrl/complaints/track/$trackingId'),
      headers: _headers,
    );
    final data = jsonDecode(res.body);
    if (res.statusCode != 200) throw data['message'] ?? 'Not found';
    return Complaint.fromJson(data['complaint']);
  }

  static Future<List<Complaint>> myComplaints() async {
    final res = await http.get(
      Uri.parse('$baseUrl/complaints/my'),
      headers: await _authHeaders,
    );
    final data = jsonDecode(res.body);
    if (res.statusCode != 200) throw data['message'] ?? 'Failed';
    return (data['complaints'] as List)
        .map((c) => Complaint.fromJson(c))
        .toList();
  }
}