part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersLoading extends UsersState {
  @override
  List<User> get props => [];
}

class UsersLoaded extends UsersState {
  const UsersLoaded(this.users);
  final List<User> users;

  @override
  List<Object?> get props => [users];
}

class UsersError extends UsersState {}
