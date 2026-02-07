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

    for (final doc in docs) {
      final days = doc.expiryDate.difference(now).inDays;

      // 🟡 30 a 8 dias
      if (days <= 30 && days > 7) {
        await NotificationService.show(
          id: '${doc.id}-yellow'.hashCode,
          title: 'Documento próximo do vencimento',
          body: 'Seu documento ${doc.title} vence em $days dias',
        );
      }

      // 🔴 7 dias ou menos
      else if (days <= 7 && days >= 0) {
        await NotificationService.show(
          id: '${doc.id}-red'.hashCode,
          title: '⚠️ Atenção!',
          body: 'Seu documento ${doc.title} vence em $days dias',
        );
      }

      // ❌ Vencido
      else if (days < 0) {
        await NotificationService.show(
          id: '${doc.id}-expired'.hashCode,
          title: '❌ Documento vencido',
          body:
              'Seu documento ${doc.title} está vencido há ${days.abs()} dias',
        );
      }
    }

    return true;
  });
}
