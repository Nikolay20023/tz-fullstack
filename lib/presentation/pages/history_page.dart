import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/history_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class HistoryPage extends StatefulWidget {
  final String userId;

  const HistoryPage({super.key, required this.userId});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(LoadShiftsEvent(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift History'),
      ),
      body: BlocListener<HistoryBloc, HistoryState>(
        listener: (context, state) {
          if (state is HistoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            if (state is HistoryLoading) {
              return const LoadingWidget();
            } else if (state is HistoryError) {
              return ErrorWidget(message: state.message);
            } else if (state is HistoryLoaded) {
              return _buildShiftsList(state.shifts);
            } else {
              return const Center(child: Text('No shifts found'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildShiftsList(List shifts) {
    if (shifts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No shifts found'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: shifts.length,
      itemBuilder: (context, index) {
        final shift = shifts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: shift.status == 'completed' 
                  ? Colors.green 
                  : Colors.orange,
              child: Icon(
                shift.status == 'completed' 
                    ? Icons.check 
                    : Icons.pending,
                color: Colors.white,
              ),
            ),
            title: Text('Shift ${index + 1}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Start: ${_formatDateTime(shift.startTime)}'),
                if (shift.endTime != null)
                  Text('End: ${_formatDateTime(shift.endTime)}'),
                if (shift.duration != null)
                  Text('Duration: ${_formatDuration(shift.duration)}'),
              ],
            ),
            trailing: Text(
              shift.status.toUpperCase(),
              style: TextStyle(
                color: shift.status == 'completed' 
                    ? Colors.green 
                    : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    return '${duration.inHours}h ${duration.inMinutes % 60}m';
  }
}
