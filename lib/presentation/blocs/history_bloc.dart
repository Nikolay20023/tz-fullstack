import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/usecases/get_shifts_usecase.dart';

abstract class HistoryEvent {}

class LoadShiftsEvent extends HistoryEvent {
  final String userId;

  LoadShiftsEvent(this.userId);
}

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<ShiftEntity> shifts;

  HistoryLoaded(this.shifts);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final GetShiftsUseCase _getShiftsUseCase;

  HistoryBloc({required GetShiftsUseCase getShiftsUseCase})
      : _getShiftsUseCase = getShiftsUseCase,
        super(HistoryInitial()) {
    on<LoadShiftsEvent>(_onLoadShifts);
  }

  Future<void> _onLoadShifts(LoadShiftsEvent event, Emitter<HistoryState> emit) async {
    emit(HistoryLoading());
    try {
      final shifts = await _getShiftsUseCase.call(event.userId);
      emit(HistoryLoaded(shifts));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
