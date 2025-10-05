# Flutter Time Tracker

## Описание
Упрощённое app для учёта смен: авторизация (Supabase Auth), старт/финиш смены, история. Чистая архитектура (data/domain/presentation), Bloc для state.

## Архитектура
- **Data**: SupabaseRemoteDataSource для API.
- **Domain**: Entities, UseCases, Repository абстракции.
- **Presentation**: Bloc (AuthBloc, ShiftBloc), Pages с Form/BlocBuilder.
- State: Bloc + Either<Failure, T> для ошибок.

## API
Supabase (PostgreSQL + Auth):
- Auth: POST /auth/v1/signup, /signin (email/password).
- Shifts: POST /rest/v1/shifts, PATCH /rest/v1/shifts, GET /rest/v1/shifts?user_id=eq.{id}.
- URL: https://твой-проект.supabase.co
- RLS: Только свои данные.

## Запуск
1. Клонируй repo: `git clone ...`
2. `flutter pub get`
3. В main.dart: Замени Supabase URL/anonKey на свои (создай проект на supabase.com).
4. `flutter run` (Android/iOS эмулятор).