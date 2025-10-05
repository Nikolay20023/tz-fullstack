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
        name: user.userMetadata['name'] ?? '',
      );
    }
    throw UnimplementedError();
  }

  @override
  Future<List<ShiftModel>> getUserShifts(String userId) async {
    try {
        final response = await _supabase.from('shifts').select().eq('user_id', userId);

        return response.map((shift) => ShiftModel.fromJson(shift)).toList();
    } catch (e) {
        throw Exception(e);
    }
    throw UnimplementedError();
  }

  @override
  Future<ShiftModel> startShift(String userId) async {
    try {
        final response = await _supabase.from('shifts').insert({
            'user_id': userId,
            'start_time': DateTime.now().toIso8601String(),
            'status': 'active',
        }).select().single();

        return ShiftModel.fromJson(response);
    } catch (e) {
        throw Exception(e);
    }
    throw UnimplementedError();
  }

  @override
  Future<ShiftModel> endShift(String shiftId) async {
    try {
        final response  = await _supabase.from('shifts').update({
            'end_time': DateTime.now().toIso8601String(),
            'status': 'completed',
        }).eq('id', shiftId).select().single();

        return ShiftModel.fromJson(response);
    } catch (e) {
        throw Exception(e);
    }
    throw UnimplementedError();
  }

  @override
  Future<void> signInWithEmail(String email, String password) async {
    try {
        await _supabase.auth.signInWithPassword(email: email.trim(), password: password.trim());
    } catch (e) {
        throw Exception(e);
    }
    throw UnimplementedError();
  }

  @override
  Future<void> signUpWithEmail(String email, String password, String name) async {
    final user = await _supabase.auth.signUp(email: email.trim(), password: password.trim());
    if (user.user != null) {
        await _supabase.from('users').insert({
            'id': user.user?.id,
            'email': email.trim(),
            'name': name.trim(),
        });
    }

    await _supabase.from('profiles').insert({
        'id': response.user!.id,
        'name': name,
      });
    
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
    throw UnimplementedError();
  }
}
