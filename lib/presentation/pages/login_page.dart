import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth_bloc.dart';
import '../../debug_supabase.dart';
import '../../network_test.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLogin = true; 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Вход' : 'Регистрация'),
      ),
      body: BlocListener<AuthBloc, AuthBlocState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Логотип или заголовок
                Icon(
                  Icons.timer,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 20),
                Text(
                  _isLogin ? 'Добро пожаловать!' : 'Создать аккаунт',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Поле имени (только для регистрации)
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Имя',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (!_isLogin && (value == null || value.isEmpty)) {
                        return 'Пожалуйста, введите ваше имя';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Поле email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите email';
                    }
                    if (!value.contains('@')) {
                      return 'Пожалуйста, введите корректный email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Поле пароля
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите пароль';
                    }
                    if (!_isLogin && value.length < 6) {
                      return 'Пароль должен содержать минимум 6 символов';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                BlocBuilder<AuthBloc, AuthBlocState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  if (_isLogin) {
                                    // Вход
                                    context.read<AuthBloc>().add(
                                          SignInEvent(
                                            _emailController.text,
                                            _passwordController.text,
                                          ),
                                        );
                                  } else {
                                    // Регистрация
                                    context.read<AuthBloc>().add(
                                          SignUpEvent(
                                            _emailController.text,
                                            _passwordController.text,
                                            _nameController.text,
                                          ),
                                        );
                                  }
                                }
                              },
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(_isLogin ? 'Войти' : 'Зарегистрироваться'),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Отладочные кнопки (только для разработки)
                if (!_isLogin) ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await NetworkTest.testConnection();
                          },
                          child: const Text('🌐 Тест сети'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await SupabaseDebug.testConnection();
                            await SupabaseDebug.testSignUp(
                              _emailController.text.isNotEmpty ? _emailController.text : 'test@example.com',
                              _passwordController.text.isNotEmpty ? _passwordController.text : '123456',
                              _nameController.text.isNotEmpty ? _nameController.text : 'Test User',
                            );
                          },
                          child: const Text('🔧 Тест Supabase'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                
                // Переключение между входом и регистрацией
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin ? 'Нет аккаунта?' : 'Уже есть аккаунт?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                          // Очищаем поля при переключении
                          _formKey.currentState?.reset();
                        });
                      },
                      child: Text(
                        _isLogin ? 'Зарегистрироваться' : 'Войти',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
