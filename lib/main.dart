import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Data layer imports
import 'data/datasources/supabase_remote_data_source.dart';
import 'data/repositories/shift_repository_impl.dart';
import 'data/repositories/user_repository_impl.dart';

// Domain layer imports
import 'domain/repositories/shift_repository.dart';
import 'domain/repositories/user_repository.dart';
import 'domain/usecases/start_shift_usecase.dart';
import 'domain/usecases/end_shift_usecase.dart';
import 'domain/usecases/get_shifts_usecase.dart';
import 'domain/usecases/sign_in_usecase.dart';
import 'domain/usecases/sign_up_usecase.dart';
import 'domain/usecases/get_current_user_usecase.dart';
import 'domain/usecases/sign_out_usecase.dart';

// Presentation layer imports
import 'presentation/blocs/auth_bloc.dart';
import 'presentation/blocs/shift_bloc.dart';
import 'presentation/blocs/history_bloc.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/shift_page.dart';
import 'presentation/pages/history_page.dart';

const supabaseUrl = 'https://dtohbtgidavssedfuwlg.supabase.co';
const supabaseKey = String.fromEnvironment('SUPABASE_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR0b2hidGdpZGF2c3NlZGZ1d2xnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk2MjkyMzUsImV4cCI6MjA3NTIwNTIzNX0.zYEmTp9cTYqHtDKZ4pY1F_RqPhdOCnnITs9vGe-flA0');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency injection setup
    final SupabaseRemoteDataSource remoteDataSource = SupabaseRemoteDataSourceImpl();
    final ShiftRepository shiftRepository = ShiftRepositoryImpl(remoteDataSource);
    final UserRepository userRepository = UserRepositoryImpl(remoteDataSource);

    // Use cases
    final startShiftUseCase = StartShiftUseCase(shiftRepository);
    final endShiftUseCase = EndShiftUseCase(shiftRepository);
    final getShiftsUseCase = GetShiftsUseCase(shiftRepository);
    final signInUseCase = SignInUseCase(userRepository);
    final signUpUseCase = SignUpUseCase(userRepository);
    final getCurrentUserUseCase = GetCurrentUserUseCase(userRepository);
    final signOutUseCase = SignOutUseCase(userRepository);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            signInUseCase: signInUseCase,
            signUpUseCase: signUpUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase,
            signOutUseCase: signOutUseCase,
          )..add(GetCurrentUserEvent()),
        ),
        BlocProvider<ShiftBloc>(
          create: (context) => ShiftBloc(
            startShiftUseCase: startShiftUseCase,
            endShiftUseCase: endShiftUseCase,
          ),
        ),
        BlocProvider<HistoryBloc>(
          create: (context) => HistoryBloc(getShiftsUseCase: getShiftsUseCase),
        ),
      ],
      child: MaterialApp(
        title: 'Shift Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthBloc, AuthBlocState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (state is AuthAuthenticated) {
              return MainPage(user: state.user);
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  final dynamic user;

  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ShiftPage(userId: widget.user.id),
      HistoryPage(userId: widget.user.id),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Shift',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Shift Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent());
            },
          ),
        ],
      ),
    );
  }
}