import 'package:autoequal/autoequal.dart';
import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';
part 'login_cubit.g.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const _Initial()) {
    setInitial();
  }

  setInitial() {
    emit(
      const _LoggingIn(
        email: '',
        password: '',
        isObscured: true,
      ),
    );
  }

  toggleObscurity() {
    emit(
      state.asLoggingIn.copyWith(
        isObscured: !state.asLoggingIn.isObscured,
        email: state.asLoggingIn.email,
        password: state.asLoggingIn.password,
      ),
    );
  }

  changeEmail(String email) {
    emit(
      state.asLoggingIn.copyWith(
        email: email,
        isObscured: state.asLoggingIn.isObscured,
        password: state.asLoggingIn.password,
      ),
    );
    enabledLogin();
  }

  changePassword(String password) {
    emit(
      state.asLoggingIn.copyWith(
        email: state.asLoggingIn.email,
        isObscured: state.asLoggingIn.isObscured,
        password: password,
      ),
    );
    enabledLogin();
  }

  bool enabledLogin() {
    if (state.asLoggingIn.email.isEmpty) return false;
    if (state.asLoggingIn.password.isEmpty) return false;
    return true;
  }
}
