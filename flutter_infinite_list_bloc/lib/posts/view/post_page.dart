import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list_bloc/posts/bloc/post_bloc.dart';
import 'package:flutter_infinite_list_bloc/posts/bloc/post_event.dart';
import 'package:http/http.dart' as http;
import 'post_list.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => PostBloc(httpClient: http.Client())
          ..add(
            PostFetched(),
          ),
        child: PostList(),
      ),
    );
  }
}
