enum DocumentType {
  passport,
  nif,
  cnh,
}

class DocumentModel {
  final String id;
  final DocumentType type;
  final String title;
  final String holderName;

  final DateTime issueDate;
  final DateTime expiryDate;

  /// Dados específicos por tipo (passaporte, nif, cnh…)
  final Map<String, dynamic> extra;

  final String? imagePath;

  DocumentModel({
    required this.id,
    required this.type,
    required this.title,
    required this.holderName,
    required this.issueDate,
    required this.expiryDate,
    this.extra = const {},
    this.imagePath,
  });

  /// Primeiro + último nome
  String get shortName {
    final parts = holderName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first;
    return '${parts.first} ${parts.last}';
  }

  int get daysToExpire =>
      expiryDate.difference(DateTime.now()).inDays;

  DocumentModel copyWith({
    String? id,
    DocumentType? type,
    String? title,
    String? holderName,
    DateTime? issueDate,
    DateTime? expiryDate,
    Map<String, dynamic>? extra,
    String? imagePath,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      holderName: holderName ?? this.holderName,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      extra: extra ?? this.extra,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title': title,
      'holderName': holderName,
      'issueDate': issueDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'extra': extra,
      'imagePath': imagePath,
    };
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'],
      type: DocumentType.values.firstWhere(
        (e) => e.name == json['type'],
      ),
      title: json['title'],
      holderName: json['holderName'],
      issueDate: DateTime.parse(json['issueDate']),
      expiryDate: DateTime.parse(json['expiryDate']),
      extra: Map<String, dynamic>.from(json['extra'] ?? {}),
      imagePath: json['imagePath'],
    );
  }
}
