// SplashPage triggers AppStarted and shows a short loading indicator.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:orchestrator/presentation/bloc/auth/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Delay to ensure context is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(const AppStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to AuthState and route accordingly once the check completes.
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          prev.user != curr.user || (prev.isLoading && !curr.isLoading),
      listener: (context, state) {
        if (state.user != null) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (r) => false);
        } else if (!state.isLoading) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
        }
      },
      child: const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
