import 'package:flutter/material.dart';

import '../models/board.dart';

class BoardHeader extends StatelessWidget {
  const BoardHeader({
    super.key,
    required this.board,
    required this.boards,
    required this.onSelectBoard,
    required this.onCreateBoard,
  });

  final Board board;
  final List<Board> boards;
  final ValueChanged<Board> onSelectBoard;
  final VoidCallback onCreateBoard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              board.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          PopupMenuButton<int>(
            tooltip: 'Selecionar quadro',
            onSelected: (id) {
              final selected = boards.firstWhere((item) => item.id == id);

              onSelectBoard(selected);
            },
            itemBuilder: (_) => boards
                .map(
                  (item) => PopupMenuItem<int>(
                    value: item.id,
                    child: Text(item.name),
                  ),
                )
                .toList(),
            icon: const Icon(Icons.dashboard_outlined),
          ),
          IconButton(
            tooltip: 'Novo quadro',
            onPressed: onCreateBoard,
            icon: const Icon(Icons.add_box_outlined),
          ),
        ],
      ),
    );
  }
}
