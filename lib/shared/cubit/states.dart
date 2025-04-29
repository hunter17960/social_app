abstract class SocialStates {}

class SocialInitial extends SocialStates {}

class ToggleTheme extends SocialStates {}

//?
class GetUserLoading extends SocialStates {}

class GetUserSuccess extends SocialStates {}

class GetUserError extends SocialStates {
  final String error;
  GetUserError(this.error);
}

//?
class GetUsersLoading extends SocialStates {}

class GetUsersSuccess extends SocialStates {}

class GetUsersError extends SocialStates {
  final String error;
  GetUsersError(this.error);
}

//?
class GetPostsLoading extends SocialStates {}

class GetPostsSuccess extends SocialStates {}

class GetPostsError extends SocialStates {
  final String error;
  GetPostsError(this.error);
}

//?
class UpdateUserLoading extends SocialStates {}

class UpdateUserSuccess extends SocialStates {}

class UpdateUserError extends SocialStates {
  final String error;
  UpdateUserError(this.error);
}

//?
class ChoosingImageSuccess extends SocialStates {}

class ChoosingImageError extends SocialStates {
  ChoosingImageError();
}

//?
class UploadProfileImageLoading extends SocialStates {}

class UploadProfileImageSuccess extends SocialStates {}

class UploadProfileImageError extends SocialStates {
  String error;
  UploadProfileImageError(this.error);
}

//?
class UploadCoverImageLoading extends SocialStates {}

class UploadCoverImageSuccess extends SocialStates {}

class UploadCoverImageError extends SocialStates {
  String error;
  UploadCoverImageError(this.error);
}

//?
class UpdateProfileImageSuccess extends SocialStates {}

class UpdateProfileImageError extends SocialStates {
  String error;
  UpdateProfileImageError(this.error);
}

//?
class UpdateCoverImageSuccess extends SocialStates {}

class UpdateCoverImageError extends SocialStates {
  String error;
  UpdateCoverImageError(this.error);
}

//?
class UpdateImagesLoading extends SocialStates {}

class UpdateImagesSuccess extends SocialStates {}

class UpdateImagesError extends SocialStates {}

//?
class CreatePostLoading extends SocialStates {}

class CreatePostSuccess extends SocialStates {}

class CreatePostError extends SocialStates {
  String error;
  CreatePostError(this.error);
}

//?
class DeletePostLoading extends SocialStates {}

class DeletePostSuccess extends SocialStates {}

class DeletePostError extends SocialStates {
  String error;
  DeletePostError(this.error);
}

//?
class ChoosingPostImageSuccess extends SocialStates {}

class ChoosingPostImageError extends SocialStates {
  // ChoosingImageError();
}

//?
class PostLikeSuccess extends SocialStates {}

class PostLikeError extends SocialStates {
  final String error;
  PostLikeError(this.error);
}

//?
class PostCommentSuccess extends SocialStates {}

class PostCommentError extends SocialStates {
  final String error;
  PostCommentError(this.error);
}

//?
class DeleteCommentSuccess extends SocialStates {}

class DeleteCommentError extends SocialStates {
  final String error;
  DeleteCommentError(this.error);
}

//?
class EditCommentSuccess extends SocialStates {}

class EditCommentError extends SocialStates {
  final String error;
  EditCommentError(this.error);
}

//?
class MessageSentSuccess extends SocialStates {}

class MessageSentError extends SocialStates {
  final String error;
  MessageSentError(this.error);
}

//?
class DeleteMessageSuccess extends SocialStates {}

class DeleteMessageError extends SocialStates {
  final String error;
  DeleteMessageError(this.error);
}

//?
class EditMessageSuccess extends SocialStates {}

class EditMessageError extends SocialStates {
  final String error;
  EditMessageError(this.error);
}

//?
class GetPostCommentsSuccess extends SocialStates {}

//?
class GetPostLikesSuccess extends SocialStates {}

//?
class UploadPostImageLoading extends SocialStates {}

class UploadPostImageSuccess extends SocialStates {}

class UploadPostImageError extends SocialStates {
  String error;
  UploadPostImageError(this.error);
}

//?

class CommentFullChange extends SocialStates {}
//?

class ChatFullChange extends SocialStates {}

//?
class DiscardPostImageFile extends SocialStates {}

class DeleteSelectedPostImage extends SocialStates {}

class SocialToggleTheme extends SocialStates {}

class SocialChangeBottomNavBar extends SocialStates {}

class ChangeScheme extends SocialStates {}

// class ShopToggleIsImageLoaded extends SocialStates {}

// class SearchLoading extends SocialStates {}

// class SearchLoadingError extends SocialStates {
//   final String error;
//   SearchLoadingError(this.error);
// }
