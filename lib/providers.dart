import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tcp_console/tcp_socket/tcp_socket_service.dart';

final dataStreamProvider = StreamProvider(
  (ref) => ref.watch(tcpSocketServiceProvider).subscribeToTcpSocket(),
);
