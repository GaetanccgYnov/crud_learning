enum Civilite { Monsieur, Madame, Mademoiselle }

class User {
  final String id;
  final String name;
  final String email;
  final Civilite civilite;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.civilite,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '', // Utilisez ?? pour fournir une valeur par défaut si null
      name: json['name'] ?? '', // Utilisez ?? pour fournir une valeur par défaut si null
      email: json['email'] ?? '', // Utilisez ?? pour fournir une valeur par défaut si null
      civilite: stringToCivilite(json['civilite'] ?? ''), // Gérez correctement la civilité
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'civilite': civiliteToString(civilite),
    };
  }
}

String civiliteToString(Civilite civilite) {
  return civilite.toString().split('.').last;
}

Civilite stringToCivilite(String civiliteStr) {
  return Civilite.values.firstWhere(
        (c) => c.toString().split('.').last == civiliteStr,
    orElse: () => Civilite.Monsieur, // Fournit une valeur par défaut si non trouvé
  );
}
