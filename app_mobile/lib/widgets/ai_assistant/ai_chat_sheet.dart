import 'package:flutter/material.dart';

class AiChatSheet extends StatefulWidget {
  const AiChatSheet({super.key});

  @override
  State<AiChatSheet> createState() => _AiChatSheetState();
}

class _AiChatSheetState extends State<AiChatSheet> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();

    if (message.isEmpty) return;

    // Futuramente, a mensagem será enviada para a IA.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('A integração com a IA será adicionada futuramente.'),
      ),
    );

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Color(0xFF8B5CF6)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Assistente AMVE',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Em breve você poderá organizar suas tarefas '
            'e seus projetos conversando com a IA.',
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _messageController,
            minLines: 1,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: 'Escreva sua mensagem...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              suffixIcon: IconButton(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send_rounded),
                color: const Color(0xFF8B5CF6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
