part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UsersEvent {
  // final List<User> users;
  @override
  List<Object?> get props => [];
}

class SearchUser extends UsersEvent {
  final String users;

  const SearchUser(this.users);
}

class FetchPage extends UsersEvent {
  final int page;
  final String users;

  const FetchPage(this.page, this.users);
}
