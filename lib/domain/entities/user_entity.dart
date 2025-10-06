class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });
}
