class NewPost {
  final String title, date, url, content;

  NewPost({
    this.content,
    this.title,
    this.date,
    this.url,
  });

  factory NewPost.fromJson(Map<String, dynamic> json) {
    return NewPost(
      content: json['content'],
      date: json['date'],
      title: json['title'],
      url: json['link'],
    );
  }
}
