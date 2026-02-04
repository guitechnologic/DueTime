import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/document_model.dart';

class LocalStorage {
  static const _key = 'documents';

  static Future<List<DocumentModel>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    final list = jsonDecode(raw) as List;
    return list.map((e) => DocumentModel.fromJson(e)).toList();
  }

  static Future<void> save(DocumentModel doc) async {
    final prefs = await SharedPreferences.getInstance();
    final docs = await getAll();

    final index = docs.indexWhere((d) => d.id == doc.id);
    if (index >= 0) {
      docs[index] = doc;
    } else {
      docs.add(doc);
    }

    await prefs.setString(
      _key,
      jsonEncode(docs.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> delete(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final docs = await getAll()
      ..removeWhere((d) => d.id == id);

    await prefs.setString(
      _key,
      jsonEncode(docs.map((e) => e.toJson()).toList()),
    );
  }

  static Future<DocumentModel?> getById(String id) async {
    final docs = await getAll();
    try {
      return docs.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }
}
