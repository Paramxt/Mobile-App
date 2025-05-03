import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WebSocketService {
  final WebSocketChannel channel = WebSocketChannel.connect(
    Uri.parse(dotenv.env['WEBSOCKET_SERVER_URL'] ?? 'ws://localhost:8080'),
  );
  Stream<dynamic> get stream => channel.stream;

  void dispose() {
    channel.sink.close();
  }
}

class SensorManager {
  Future<void> saveSensorValue(String sensorKey, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(sensorKey, value);
  }

  Future<int> getSensorValue(String sensorKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(sensorKey) ?? 0; // ถ้าไม่มีค่าจะใช้ 0 เป็นค่าเริ่มต้น
  }
}
