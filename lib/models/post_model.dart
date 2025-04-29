// class PostsModel {
//   late String postId;
//   dynamic
// }
class PostLikes {}

class PostModel {
  late String name;
  late String uId;
  late String image;
  String? postImage;
  late String dateTime;
  late String text;
  // late String tags;
  PostModel({
    required this.name,
    required this.uId,
    required this.image,
    this.postImage,
    required this.dateTime,
    required this.text,
    // required this.tags,
  });

  PostModel.fromJson(json) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    postImage = json['postImage'];
    dateTime = json['dateTime'];
    text = json['text'];
    // tags = json['tags'];
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'postImage': postImage,
      'dateTime': dateTime,
      'text': text,
      // 'image': image,
    };
  }
}

class CommentModel {
  late String dateTime;
  late String comment;
  late String uId;
  CommentModel({
    required this.dateTime,
    required this.comment,
    required this.uId,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    dateTime = json['dateTime'];
    comment = json['comment'];
    uId = json['uId'];
  }
  Map<String, dynamic> toMap() {
    return {
      'dateTime': dateTime,
      'comment': comment,
      'uId': uId,
    };
  }
}
