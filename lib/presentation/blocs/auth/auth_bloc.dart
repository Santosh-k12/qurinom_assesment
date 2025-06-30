import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qurinom_assesment/data/models/login_request_model.dart';
import 'package:qurinom_assesment/data/repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc(this.repository) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await repository.login(
          LoginRequest(
            email: event.email,
            password: event.password,
            role: event.role,
          ),
        );
        emit(AuthSuccess(user));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
