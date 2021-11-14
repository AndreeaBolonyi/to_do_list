class User {
  int? id;
  String? name;
  String? gitHubUsername;
  String? email;
  String? password;

  User(this.id, this.name, this.gitHubUsername, this.email, this.password);

  @override
  String toString() {
    return "$id $name $gitHubUsername $email";
  }
}