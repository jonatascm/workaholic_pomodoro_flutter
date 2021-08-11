import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitState extends AuthState {}

class AuthAuthenticatedState extends AuthState {}

class AuthNotAuthenticatedState extends AuthState {}
