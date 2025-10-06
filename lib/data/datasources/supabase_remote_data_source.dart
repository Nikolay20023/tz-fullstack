import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/shift_model.dart';
import '../models/user_model.dart';

abstract class SupabaseRemoteDataSource {
  Future<UserModel?> getCurrentUser();
  Future<List<ShiftModel>> getUserShifts(String userId);
  Future<ShiftModel> startShift(String userId);
  Future<ShiftModel> endShift(String shiftId);
  Future<void> signInWithEmail(String email, String password);
  Future<void> signUpWithEmail(String email, String password, String name);
  Future<void> signOut();
}

class SupabaseRemoteDataSourceImpl implements SupabaseRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      return UserModel(
        id: user.id,
        email: user.email ?? '',
        name: user.userMetadata?['name'] ?? '',
      );
    }
    return null;
  }

  @override
  Future<List<ShiftModel>> getUserShifts(String userId) async {
    try {
        final response = await _supabase
            .from('shifts')
            .select()
            .eq('profile_id', userId)
            .order('start_time', ascending: false);

        return response.map((shift) => ShiftModel.fromJson(shift)).toList();
    } catch (e) {
        throw Exception(e.toString());
    }
  }

  @override
  Future<ShiftModel> startShift(String userId) async {
    try {
        final response = await _supabase.from('shifts').insert({
            'profile_id': userId,
            'start_time': DateTime.now().toIso8601String(),
            'status': 'active',
        }).select().single();

        return ShiftModel.fromJson(response);
    } catch (e) {
        throw Exception(e.toString());
    }
  }

  @override
  Future<ShiftModel> endShift(String shiftId) async {
    try {
        final response = await _supabase.from('shifts').update({
            'end_time': DateTime.now().toIso8601String(),
            'status': 'completed',
        }).eq('id', shiftId).select().single();

        return ShiftModel.fromJson(response);
    } catch (e) {
        throw Exception(e.toString());
    }
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
        await _supabase.auth.signInWithPassword(email: email.trim(), password: password.trim());
    } catch (e) {
        throw Exception(e.toString());
    }
  }

  @override
  Future<void> signUpWithEmail(String email, String password, String name) async {
    try {
      print('Начинаем регистрацию для: $email'); // Отладочный вывод
      
      final response = await _supabase.auth.signUp(
        email: email.trim(), 
        password: password.trim(),
        data: {'name': name.trim()},
      );
      
      print('Ответ от Supabase: ${response.toString()}'); // Отладочный вывод
      
      if (response.user != null) {
        print('Пользователь создан с ID: ${response.user!.id}');
        
        // Проверяем, подтверждена ли регистрация
        if (response.session != null) {
          print('Сессия создана, пользователь автоматически вошел в систему');
        } else {
          print('Пользователь создан, но требует подтверждения email');
        }
        
        // Пытаемся создать профиль (может не сработать если таблица не существует)
        try {
          await _supabase.from('profiles').insert({
            'id': response.user!.id,
            'name': name.trim(),
            'email': email.trim(),
            'created_at': DateTime.now().toIso8601String(),
          });
          print('Профиль создан в таблице profiles');
        } catch (profileError) {
          print('Ошибка создания профиля (возможно таблица не существует): $profileError');
          // Не выбрасываем ошибку, так как пользователь уже создан в auth
        }
      } else {
        print('Ошибка: пользователь не был создан');
        throw Exception('Не удалось создать пользователя');
      }
    } catch (e) {
      print('Ошибка регистрации: $e');
      throw Exception('Ошибка регистрации: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
