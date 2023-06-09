import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:news_feed/blocs/app_event_bloc.dart';
import 'package:news_feed/modules/firebase/firebase_utils.dart';
import 'package:news_feed/modules/home/repos/list_posts_paging_repo.dart';
import 'package:news_feed/modules/profile/blocs/profile_bloc.dart';
import 'package:news_feed/resource/paging_data_bloc.dart';
import 'package:news_feed/resource/paging_repo.dart';

import '../models/post.dart';

class ListPostRxDartBloc extends PagingDataBehaviorBloc<Post> {
  Stream<List<Post>?> get postsStream => dataStream;

  late final StreamSubscription<BlocEvent> _onLikeAndUnlikePostSub;
  late final StreamSubscription<BlocEvent> _onCreatePostSub;

  final ListPostPagingRepo _repo;

  ListPostRxDartBloc() : _repo = ListPostPagingRepo() {
    _onLikeAndUnlikePostSub = AppEventBloc().listenManyEvents(
      listEventName: [
        EventName.likePostDetail,
        EventName.unLikePostDetail
      ],
      handler: _onLikeAndUnlikePost
    );
    _onCreatePostSub = AppEventBloc().listenEvent(
      eventName: EventName.createPost,
      handler: _onCreatePost
    );
  } 

  Future<void> getPosts() async {
    return getData();
  }

  void _onCreatePost(BlocEvent evt) {
    refresh();
  }

  void _onLikeAndUnlikePost(BlocEvent evt) async {
    final oldPosts = dataValue ?? [];
    final postId = evt.value[0];
    final index = oldPosts.indexWhere((element) => element.id == postId);
    if(index == -1) {
      return;
    }
    final post = oldPosts[index];
    final likeCount = post.likeCounts;
    final eventIsLike = [EventName.likePostDetail].contains(evt.name);
    final likeCountNew = eventIsLike ? likeCount! + 1 : likeCount! -1;
    
    post
      ..likeCounts = likeCountNew
      ..liked = eventIsLike;
    
    oldPosts[index] = post;
    dataSubject.sink.add(oldPosts.toList());

    final isMine = evt.value[1];
    // send Notification to user's post
    if(eventIsLike && isMine == false) {
      final user = post.user;
      if(user != null) {
        final title = "${user.firstName} liked your post";
        final body = "";
        final firebaseUtils = FirebaseUtils();
        firebaseUtils.sendPushMessage(await firebaseUtils.getTokenByUsername(user.username ?? ""), body, title);
      }
      
    }
  }

  @override
  void dispose() {
    _onLikeAndUnlikePostSub.cancel();
    _onCreatePostSub.cancel();
  }

  @override
  PagingRepo get dataRepo => _repo;
  
} 