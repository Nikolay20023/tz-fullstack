import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/usecases/start_shift_usecase.dart';
import '../../domain/usecases/end_shift_usecase.dart';

abstract class ShiftEvent {}

class StartShiftEvent extends ShiftEvent {
  final String userId;

  StartShiftEvent(this.userId);
}

class EndShiftEvent extends ShiftEvent {
  final String shiftId;

  EndShiftEvent(this.shiftId);
}

abstract class ShiftState {}

class ShiftInitial extends ShiftState {}

class ShiftLoading extends ShiftState {}

class ShiftActive extends ShiftState {
  final ShiftEntity activeShift;

  ShiftActive(this.activeShift);
}

class ShiftInactive extends ShiftState {}

class ShiftError extends ShiftState {
  final String message;

  ShiftError(this.message);
}

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  final StartShiftUseCase _startShiftUseCase;
  final EndShiftUseCase _endShiftUseCase;

  ShiftBloc({
    required StartShiftUseCase startShiftUseCase,
    required EndShiftUseCase endShiftUseCase,
  }) : _startShiftUseCase = startShiftUseCase,
       _endShiftUseCase = endShiftUseCase,
       super(ShiftInitial()) {
    on<StartShiftEvent>(_onStartShift);
    on<EndShiftEvent>(_onEndShift);
  }

  Future<void> _onStartShift(StartShiftEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    try {
      final shift = await _startShiftUseCase.call(event.userId);
      emit(ShiftActive(shift));
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }

  Future<void> _onEndShift(EndShiftEvent event, Emitter<ShiftState> emit) async {
    emit(ShiftLoading());
    try {
      await _endShiftUseCase.call(event.shiftId);
      emit(ShiftInactive());
    } catch (e) {
      emit(ShiftError(e.toString()));
    }
  }
}
