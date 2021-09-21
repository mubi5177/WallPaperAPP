class ImagesListt {
  int id;

  String src;

  ImagesListt({
    this.id,
    this.src,
  });

  ImagesListt.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    src = json['src'];
  }
}
