class ResponseEntity<T> {
  int status;
  String message;
  T data;

  ResponseEntity(this.status, this.message, this.data);
}
