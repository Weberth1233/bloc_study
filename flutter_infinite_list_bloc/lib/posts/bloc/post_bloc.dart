import 'dart:convert';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:flutter_infinite_list_bloc/posts/bloc/post_event.dart';
import 'package:flutter_infinite_list_bloc/posts/bloc/post_state.dart';
import 'package:stream_transform/stream_transform.dart';

import '../models/models.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

/* otimização que podemos fazer é debounce evitar Events spam desnecessário em 
nossa API. Podemos fazer isso substituindo o transformmétodo em nosso arquivo 
PostBloc. */
/* Este código é uma maneira de controlar a frequência com que os eventos 
são processados em sua aplicação Flutter, evitando que eles 
sejam processados muito rapidamente e sobrecarreguem a interface do usuário.*/
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;

  PostBloc({required this.httpClient}) : super(PostState()) {
    on<PostFetched>(
      _onPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onPostFetched(
      PostFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax!) return;
    try {
      if (state.status == PostStatus.initial) {
        final posts = await _fetchPosts();
        return emit(
          state.copyWith(
            status: PostStatus.sucess,
            posts: posts,
            hasReachedMax: false,
          ),
        );
      }
      final posts = await _fetchPosts(state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: PostStatus.sucess,
                posts: List.of(state.posts)..addAll(posts),
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(
        state.copyWith(status: PostStatus.failure),
      );
    }
  }

  Future<List<Post>> _fetchPosts([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit': '$_postLimit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post(
          id: map['id'],
          title: map['title'],
          body: map['body'],
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}
