import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Canal de notificação para Android (obrigatório Android 8+)
  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'documents_channel',
    'Documentos',
    description: 'Notificações de vencimento de documentos',
    importance: Importance.max,
  );

  static Future<void> init() async {
    // Inicializa base de fusos horários
    tz.initializeTimeZones();

    // Define timezone local (Portugal)
    tz.setLocalLocation(tz.getLocation('Europe/Lisbon'));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    // Inicializa plugin
    await _plugin.initialize(settings);

    // Cria canal Android (necessário para Android 8+)
    final androidImplementation =
        _plugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.createNotificationChannel(_channel);

    // ⚠️ NÃO usamos requestPermission()
    // Sua versão 17.2.4 não possui esse método.
    // Em Android 13+, o sistema pedirá automaticamente
    // quando a primeira notificação for exibida.
  }

  static Future<void> show({
    required int id,
    required String title,
    required String body,
  }) async {
    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'documents_channel',
          'Documentos',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
