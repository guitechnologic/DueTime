import '../models/document_model.dart';

class LocalStorage {
  static final List<DocumentModel> _documents = [];

  static void add(DocumentModel doc) {
    _documents.add(doc);
  }

  static List<DocumentModel> getAll() {
    return List.unmodifiable(_documents);
  }

  static List<DocumentModel> getByType(DocumentType type) {
    return _documents.where((d) => d.type == type).toList();
  }
}
