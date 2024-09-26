part of 'users_cubit.dart';

@immutable
abstract class UsersState extends Equatable {
  const UsersState();
  @override
  List<Object> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersSuccess extends UsersState {
  final String message;

  const UsersSuccess(this.message);
  @override
  List<Object> get props => [message];
}

class UsersLoaded extends UsersState {
  final Map<UserType, List<Users>> usersByType;
  const UsersLoaded(this.usersByType);
  @override
  List<Object> get props => [usersByType];
}

class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);
  @override
  List<Object> get props => [message];
}

class GroupsLoaded extends UsersState {
  final List<Groups> groups;
  const GroupsLoaded(this.groups);
  @override
  List<Object> get props => [groups];
}

class GroupSuccessAdded extends UsersState {
  final String message;
  const GroupSuccessAdded(this.message);
  @override
  List<Object> get props => [message];
}

class GroupErrorAdded extends UsersState {
  final String error;
  const GroupErrorAdded(this.error);
  @override
  List<Object> get props => [error];
}
