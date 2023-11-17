import 'dart:convert';
import 'dart:io';

void main() async {
  const host = '127.0.0.1';
  const port = 4040;

  try {
    // Crea un servidor TCP
    ServerSocket serverSocket = await ServerSocket.bind(host, port);
    print('Servidor TCP escuchando en $host:$port');

    // Escucha por conexiones entrantes
    serverSocket.listen((Socket clientSocket) {
      print(
          'Cliente conectado desde: ${clientSocket.remoteAddress.address}:${clientSocket.remotePort}');

      // Escuchar datos desde el cliente
      clientSocket.listen((List<int> event) {
        String data = utf8.decode(event);
        print('Client: $data');
        clientSocket.write('Server: $data');
        if (data.contains('close connection')) {
          clientSocket.destroy();
        }
      }, onError: (error) {
        print('Error del cliente: $error');
        clientSocket.destroy();
      }, onDone: () {
        print('Cliente desconectado');
        clientSocket.destroy();
      });
    });
  } catch (e) {
    print('Error al iniciar el servidor: $e');
  }
}
