import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_infinite_list_bloc/core/widgets/text_field_widget.dart';
import 'package:flutter_infinite_list_bloc/posts/bloc/post_bloc.dart';
import 'package:flutter_infinite_list_bloc/posts/bloc/post_event.dart';
import 'package:flutter_infinite_list_bloc/posts/bloc/post_state.dart';
import 'package:flutter_infinite_list_bloc/posts/widgets/bottom_loader.dart';
import 'package:flutter_infinite_list_bloc/posts/widgets/post_list_item.dart';

import '../models/post.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  final _scrollController = ScrollController();
  TextEditingController controller = TextEditingController();
  late List<Post> _posts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: TextFieldWidget(
              controller: controller,
              onChanged: (value) {
                bool writing = value.length > 3;
                context.read<PostBloc>().add(PostFilterFetched(
                    writing: writing, text: controller.text, posts: _posts));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                switch (state.status) {
                  case PostStatus.failure:
                    return const Center(
                      child: Text('Falha ao carregar a listagem'),
                    );
                  case PostStatus.sucess:
                    _posts = state.posts;
                    if (_posts.isEmpty) {
                      return const Center(
                        child: Text('Sem posts..'),
                      );
                    }
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return index >= _posts.length
                            ? const BottomLoader()
                            : PostListItem(post: _posts[index]);
                      },
                      itemCount: state.hasReachedMax!
                          ? _posts.length
                          : _posts.length + 1,
                      controller: _scrollController,
                    );
                  case PostStatus.initial:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

/*Sempre que o usuário rola, calculamos o quanto você rolou para baixo na página e se a nossa distância for ≥ 90% da nossa maxScrollextentadicionamos um PostFetch e de vento para carregar mais postagens. */
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
