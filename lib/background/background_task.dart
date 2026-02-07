import 'dart:convert';

import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/notification_service.dart';
import '../models/document_model.dart';

const String dailyCheckTask = 'dailyDocumentCheck';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == dailyCheckTask) {
      await NotificationService.init();
      await _checkDocuments();
    }
    return Future.value(true);
  });
}

Future<void> _checkDocuments() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString('documents');

  if (raw == null) return;

  final List decoded = jsonDecode(raw);

  final docs = decoded
      .map((e) => DocumentModel.fromJson(e))
      .toList();

  for (final doc in docs) {
    final days = doc.daysToExpire;

    String? title;
    String? body;

    if (days <= 0) {
      title = '📛 Documento vencido';
      body =
          'O documento "${doc.title}" venceu. '
          'Atualize a data após a renovação.';
    } else if (days <= 7) {
      title = '⚠️ Documento prestes a vencer';
      body =
          'Faltam $days dias para o vencimento do documento '
          '"${doc.title}". Evite atrasos.';
    } else if (days <= 30) {
      title = '📄 Documento próximo do vencimento';
      body =
          'O documento "${doc.title}" vai vencer em breve. '
          'Organize-se para a renovação.';
    } else {
      continue;
    }

    await NotificationService.show(
      id: doc.id.hashCode,
      title: title,
      body: body,
    );
  }
}
