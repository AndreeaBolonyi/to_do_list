import 'dart:developer';

import 'package:to_do_list/domain/user.dart';

class UsersRepository {
  List<User> users = [];

  UsersRepository() {
    users.add(User(1, "Andreea Bolonyi", "AndreeaBolonyi", "andreea@yahoo.com", "andreea"));
    users.add(User(2, "Flavius Burduleanu", "FlaviusB", "@flavius@yahoo.com", "flavius"));
  }

  User? findUserByEmailAndPassword(String email, String password) {
    for (var user in users) {
      if (user.email == email && user.password == password) {
        log("usersRepo: user found: -> $user");
        return user;
      }
    }
    return null;
  }

  User? findByGitHubUsername(String gitHubUsername) {
    for (var user in users) {
      if (user.gitHubUsername == gitHubUsername) {
        log("usersRepo: user found by githubusername -> $user");
        return user;
      }
    }
    return null;
  }
}