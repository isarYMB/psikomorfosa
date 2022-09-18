import 'package:equatable/equatable.dart';

import '../../../imports.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final bool isPublic;
  final int membersCount;
  final String photoURL;
  final List<String> admins;
  final List<String> members;
  final List<String> mutedFor;
  final List<String> blockedUsers;
  final List<String> typing;

  const Group({
    required this.id,
    required this.name,
    required this.membersCount,
    required this.photoURL,
    required this.admins,
    required this.members,
    required this.mutedFor,
    required this.blockedUsers,
    required this.typing,
    required this.isPublic,
  });

  factory Group.create({
    required String name,
    required String photoURL,
  }) {
    final uid = authProvider.uid;
    return Group(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      admins: [uid],
      members: [uid],
      membersCount: 0,
      mutedFor: const [],
      photoURL: photoURL,
      isPublic: true,
      blockedUsers: const [],
      typing: const [],
    );
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: parseString(map['id']),
      name: parseString(map['name']),
      membersCount: parseInt(map['membersCount']),
      photoURL: parseString(map['photoURL']),
      isPublic: parseBool(map['isPublic']),
      admins: List<String>.from(map['admins'] as List? ?? const []),
      members: List<String>.from(map['members'] as List? ?? const []),
      mutedFor: List<String>.from(map['mutedFor'] as List? ?? const []),
      blockedUsers: List<String>.from(map['blockedUsers'] as List? ?? const []),
      typing: List<String>.from(map['typing'] as List? ?? const []),
    );
  }
  bool get isTyping => (typing..remove(_uid)).isNotEmpty;

  @override
  List<Object> get props {
    return [
      id,
      name,
      isPublic,
      membersCount,
      photoURL,
      admins,
      members,
      mutedFor,
      blockedUsers,
      typing,
    ];
  }

  List<String> get searchIndexes {
    final indices = <String>[];
    for (var i = 1; i < name.length + 1; i++) {
      indices.add(name.substring(0, i).toLowerCase());
    }
    return indices;
  }

  @override
  bool get stringify => true;
  String get _uid => authProvider.uid;

  Group copyWith({
    String? id,
    String? name,
    int? membersCount,
    String? photoURL,
    bool? isPublic,
    List<String>? admins,
    List<String>? members,
    List<String>? mutedFor,
    List<String>? blockedUsers,
    List<String>? typing,
  }) {
    return Group(
      id: id ?? this.id,
      name: name ?? this.name,
      isPublic: isPublic ?? this.isPublic,
      membersCount: membersCount ?? this.membersCount,
      photoURL: photoURL ?? this.photoURL,
      admins: admins ?? this.admins,
      members: members ?? this.members,
      mutedFor: mutedFor ?? this.mutedFor,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      typing: typing ?? this.typing,
    );
  }

  bool isAdmin([String? userId]) => admins.contains(userId ?? _uid);

  bool isBlocked([String? userId]) => blockedUsers.contains(userId ?? _uid);
  bool isMember([String? userId]) => members.contains(userId ?? _uid);

  bool isMuted([String? userId]) => mutedFor.contains(userId ?? _uid);

  void toggleBlock(String userId) => isBlocked(userId)
      ? blockedUsers.remove(userId)
      : blockedUsers.add(userId);

  void toggleJoin([String? userId]) => isMember(userId)
      ? members.remove(userId ?? _uid)
      : members.add(userId ?? _uid);

  void toggleMute() => isMuted() ? mutedFor.remove(_uid) : mutedFor.add(_uid);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isPublic': isPublic,
      'membersCount': membersCount,
      'searchIndexes': searchIndexes,
      'photoURL': photoURL,
      'admins': admins,
      'members': members,
      'mutedFor': mutedFor,
      'blockedUsers': blockedUsers,
      'typing': typing,
    };
  }
}
