import 'package:equatable/equatable.dart';
import 'package:flutter_infinite_list_bloc/posts/models/post.dart';

sealed class PostEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

//PostFetched que será adicionado pela camada de apresentação sempre que precisar de mais Posts para apresentar
final class PostFetched extends PostEvent {}

final class PostFilterFetched extends PostEvent {
  final bool writing;
  final String text;
  final List<Post> posts;

  PostFilterFetched(
      {required this.writing, required this.text, required this.posts});
}
