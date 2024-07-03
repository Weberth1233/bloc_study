/*
PostInitial- dirá à camada de apresentação que precisa renderizar um indicador 
de carregamento enquanto o lote inicial de postagens é carregado
PostSuccess- dirá à camada de apresentação que há conteúdo para renderizar 
PostFailure- informará à camada de apresentação que ocorreu um erro ao buscar postagens
*/
import 'package:equatable/equatable.dart';

import '../models/post.dart';

enum PostStatus { initial, sucess, failure }

final class PostState extends Equatable {
  final PostStatus status;
  final List<Post> posts;
  final bool? hasReachedMax;

  PostState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false,
  });

  PostState copyWith({
    PostStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, posts, hasReachedMax];
}

final class CheckConnectionState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
