import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tcp_console/providers.dart';
import 'package:tcp_console/tcp_socket/tcp_socket_service.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final TextEditingController _textController = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    ref.read(tcpSocketServiceProvider).closeConnection();
    _focusNode.dispose();
    super.dispose();
  }

  List<String> messages = [];

  @override
  Widget build(BuildContext context) {
    final dataStream = ref.watch(dataStreamProvider);
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: dataStream.when(
                data: (data) {
                  if (data != null) {
                    messages.add(data);
                  }
                  print(messages);
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (_, index) {
                      return Text(
                        messages[index],
                        style: const TextStyle(color: Colors.white),
                      );
                    },
                  );
                },
                error: (_, __) => const Center(
                  child: Text('Se ha producido un error'),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            TextField(
              controller: _textController,
              focusNode: _focusNode,
              onSubmitted: _onSubmitted,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _onSubmitted(String text) {
    ref.read(tcpSocketServiceProvider).sendData(text);
    _textController.clear();
    FocusScope.of(context).requestFocus(_focusNode);
  }
}
