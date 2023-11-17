import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final tcpSocketServiceProvider = Provider<TcpSocketService>(
  (ref) => TcpSocketService(),
);

class TcpSocketService {
  Socket? _socket;

  final host = '127.0.0.1';
  final port = 4040;

  Future<void> connectSocket() async {
    return await Socket.connect(host, port).then(
      (socket) {
        _socket = socket;
        print('Socket conectado');
      },
      onError: (error) {
        print('Error de conexión: $error');
      },
    );
  }

  Stream<String?> subscribeToTcpSocket() async* {
    if (_socket == null) {
      await connectSocket();
    }
    String? data;
    _socket!.listen(
      (List<int> event) {
        data = utf8.decode(event);
        print('Datos recibidos: $data');
      },
      onError: (error) {
        print('Error: $error');
        _socket!.destroy();
      },
      onDone: () {
        print('Conexión cerrada');
        _socket!.destroy();
      },
    );

    yield data;
  }

  void sendData(String text) async {
    if (_socket == null) return;
    _socket!.write(text);
  }

  void closeConnection() async {
    if (_socket == null) return;
    await _socket!.close();
  }
}
