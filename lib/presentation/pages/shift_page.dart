import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/shift_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class ShiftPage extends StatelessWidget {
  final String userId;

  const ShiftPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Management'),
      ),
      body: BlocListener<ShiftBloc, ShiftState>(
        listener: (context, state) {
          if (state is ShiftError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<ShiftBloc, ShiftState>(
          builder: (context, state) {
            if (state is ShiftLoading) {
              return const LoadingWidget();
            } else if (state is ShiftError) {
              return CustomErrorWidget(message: state.message);
            } else if (state is ShiftActive) {
              return _buildActiveShiftView(context, state);
            } else {
              return _buildInactiveShiftView(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildActiveShiftView(BuildContext context, ShiftActive state) {
    final duration = DateTime.now().difference(state.activeShift.startTime);
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.timer,
            size: 100,
            color: Colors.green,
          ),
          const SizedBox(height: 24),
          Text(
            'Shift Active',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Duration: ${duration.inHours}h ${duration.inMinutes % 60}m',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<ShiftBloc>().add(EndShiftEvent(state.activeShift.id));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('End Shift'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveShiftView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.play_circle_outline,
            size: 100,
            color: Colors.blue,
          ),
          const SizedBox(height: 24),
          Text(
            'No Active Shift',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          const Text('Start your shift to begin tracking time'),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<ShiftBloc>().add(StartShiftEvent(userId));
              },
              child: const Text('Start Shift'),
            ),
          ),
        ],
      ),
    );
  }
}
