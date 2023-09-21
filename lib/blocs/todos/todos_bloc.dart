import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/models/models.dart';
import '../../service/user_repository.dart';
part 'todos_event.dart';
part 'todos_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UserRepository _userRepository;
  UsersBloc(this._userRepository) : super(UsersLoading()) {
    on<LoadUsers>(_onLoadUsers);
    on<SearchUser>(_onSearchUsers);
    on<FetchPage>(_onFetchPage);
  }
  void _onLoadUsers(
    event,
    emit,
  ) async {
    emit(UsersLoading());
    try {
      final users = await _userRepository.getUser(1, '');
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError());
      print(e);
      print("Errors");
    }
  }

  void _onSearchUsers(
    event,
    emit,
  ) async {
    try {
      final users = await _userRepository.searchUser(event.users);
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError());

      print("Errors");
    }
  }

  void _onFetchPage(
    event,
    emit,
  ) async {
    emit(UsersLoading());
    try {
      final users = await _userRepository.getUser(event.page, event.users);
      emit(UsersLoaded(users));
    } catch (e) {
      emit(UsersError());
      print("Errors");
    }
  }
}
