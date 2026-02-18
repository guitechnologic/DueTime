import 'package:workmanager/workmanager.dart';
import 'package:timezone/timezone.dart' as tz;

import 'notification_service.dart';
import '../storage/local_storage.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await NotificationService.init();

    final docs = await LocalStorage.getAll();
    final now = tz.TZDateTime.now(tz.local);

    // Só notifica entre 09h e 21h
    if (now.hour < 9 || now.hour > 21) {
      return true;
    }

    for (final doc in docs) {
      final difference = doc.expiryDate.difference(now);
      final days = difference.inDays;

      if (days < 0) continue; // não notifica vencido

      final todayKey = "${doc.id}-${now.year}-${now.month}-${now.day}";
      final notificationId = todayKey.hashCode;

      // 🔴 7 dias ou menos
      if (days <= 7) {
        await NotificationService.show(
          id: notificationId,
          title: '⚠ Atenção: Renovação urgente',
          body:
              'Faltam $days dias para o ${doc.title} vencer. Agende a renovação para evitar problemas.',
        );
      }

      // 🟡 30 dias ou menos
      else if (days <= 30) {
        await NotificationService.show(
          id: notificationId,
          title: 'Documento próximo do vencimento',
          body:
              'Em $days dias o ${doc.title} vai vencer. Organize-se para renovar.',
        );
      }
    }

    return true;
  });
}
