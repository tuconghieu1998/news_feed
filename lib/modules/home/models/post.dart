import 'package:news_feed/models/image_model.dart';
import 'package:news_feed/models/user_model.dart';

class Post {
  String? id;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? title;
  String? description;
  int? commentCounts;
  List<Image>? images;
  int? likeCounts;
  int? viewCounts;
  int? pulseScore;
  //Null tags;
  User? user;
  bool? liked;

  Post(
      {this.id,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.title,
      this.description,
      this.commentCounts,
      this.images,
      this.likeCounts,
      this.viewCounts,
      this.pulseScore,
      //this.tags,
      this.user,
      this.liked});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    title = json['title'];
    description = json['description'];
    commentCounts = json['comment_counts'];
    if (json['images'] != null) {
      images = <Image>[];
      json['images'].forEach((v) {
        images!.add(Image.fromJson(v));
      });
    }
    likeCounts = json['like_counts'];
    viewCounts = json['view_counts'];
    pulseScore = json['pulse_score'];
    //tags = json['tags'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    liked = json['liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['title'] = title;
    data['description'] = description;
    data['comment_counts'] = commentCounts;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['like_counts'] = likeCounts;
    data['view_counts'] = viewCounts;
    data['pulse_score'] = pulseScore;
    //data['tags'] = this.tags;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['liked'] = liked;
    return data;
  }
}