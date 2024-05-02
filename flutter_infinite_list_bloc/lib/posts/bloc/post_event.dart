import 'package:equatable/equatable.dart';

sealed class PostEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

//PostFetched que será adicionado pela camada de apresentação sempre que precisar de mais Posts para apresentar
final class PostFetched extends PostEvent {}
