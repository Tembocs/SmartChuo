// LoginPage presents email/password form and dispatches LoginRequested.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:orchestrator/presentation/bloc/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController(text: 'admin@smartchuo.local');
  final _passwordCtrl = TextEditingController(text: 'admin123');

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartChuo Orchestrator Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.error != null && state.error!.isNotEmpty) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          if (state.user != null) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter email' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Enter password' : null,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      LoginRequested(
                                        email: _emailCtrl.text.trim(),
                                        password: _passwordCtrl.text,
                                      ),
                                    );
                                  }
                                },
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Login'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
