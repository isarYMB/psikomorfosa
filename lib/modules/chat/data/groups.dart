import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../imports.dart';
import '../../auth/data/user.dart';
import '../models/group.dart';

mixin GroupsRepository {
  static final _firestore = FirebaseFirestore.instance;
  static final groupsCol = _firestore.collection('groups').withConverter<Group>(
        fromFirestore: (m, _) => Group.fromMap(m.data()!),
        toFirestore: (m, _) => m.toMap(),
      );

  static DocumentSnapshot? lastGroupDoc;
  static DocumentSnapshot? lastMemDoc;

  static String? get _uid => authProvider.uid;
  DocumentSnapshot? lastSearchedGroupDoc;

  static Future<void> createGroup(Group group) async {
    await groupDoc(group.id).set(group);
    await joinOrLeaveGroup(group);
  }

  static Future<void> editGroup(Group group) => groupDoc(group.id).update({
        'name': group.name,
        'photoURL': group.photoURL,
        'searchIndexes': group.searchIndexes,
        'isPublic': group.isPublic,
        'typing': [],
      });

  static Future<List<Group>> fetchAllGroups(int page) async {
    var query = groupsCol
        .where('isPublic', isEqualTo: true)
        .orderBy('membersCount', descending: true)
        .limit(20);

    if (lastGroupDoc != null && page != 0) {
      query = query.startAfterDocument(lastGroupDoc!);
    }

    final docs = (await query.get()).docs;
    if (docs.isEmpty) return [];
    lastGroupDoc = docs.last;
    final res = [for (final d in docs) d.data()];
    res.sort(
      (a, b) => a.isMember()
          ? 1
          : b.isMember()
              ? -1
              : 0,
    );
    return res;
  }

  static Future<Group> fetchGroup(String id) async =>
      (await groupDoc(id).get()).data()!;

  static Future<List<User>> fetchMembers(String groupId, int page) async {
    var query = UserRepository.usersCol
        .where('joinedGroups', arrayContains: groupId)
        .orderBy('activeAt')
        .limit(20);

    if (lastMemDoc != null && page != 0) {
      query = query.startAfterDocument(lastMemDoc!);
    }
    final docs = (await query.get()).docs;
    if (docs.isEmpty) return [];
    lastMemDoc = docs.last;
    return [for (final d in docs) d.data()];
  }

  static DocumentReference<Group> groupDoc(String? id) => groupsCol.doc(id);

  static Future<List<Group>> groupsSearch(String query) async {
    final docs = await groupsCol
        .where('isPublic', isEqualTo: true)
        .where('searchIndexes', arrayContains: query.toLowerCase())
        .orderBy('membersCount', descending: true)
        .limit(10)
        .get();

    return [for (final g in docs.docs) g.data()];
  }

  static Stream<Group> groupStream(String id) => groupDoc(id)
      .snapshots()
      .map((e) => e.data()!)
      .handleError((e) => logError(e));

  static Future<void> joinOrLeaveGroup(Group? group, [String? userID]) async {
    userID ??= _uid;
    await _firestore.runTransaction(
      (tr) async => tr.update(groupDoc(group!.id), {
        'members': group.isMember(userID)
            ? FieldValue.arrayUnion([userID])
            : FieldValue.arrayRemove([userID]),
        'membersCount': FieldValue.increment(group.isMember(userID) ? 1 : -1),
        'mutedFor': FieldValue.arrayRemove([userID]),
        'typing': []
      }).update(_firestore.doc('users/$userID'), {
        'joinedGroups': group.isMember(userID)
            ? FieldValue.arrayUnion([group.id])
            : FieldValue.arrayRemove([group.id]),
      }),
    );
  }

  static Future<void> muteOrUnmuteGroup(Group group) async {
    await groupDoc(group.id).update(
      {
        'mutedFor': group.isMuted()
            ? FieldValue.arrayUnion([_uid])
            : FieldValue.arrayRemove([_uid]),
        'typing': []
      },
    );
  }

  static Stream<List<Group>> myGroupsStream(int limit) => groupsCol
      .where('members', arrayContains: _uid)
      .orderBy('membersCount', descending: true)
      .limit(limit)
      .snapshots()
      .map((e) => [for (final d in e.docs) d.data()]);

  static Future<void> toggleBlockUser(
    Group group,
    String userId,
  ) async {
    groupDoc(group.id).update(
      {
        'blockedUsers': group.isBlocked(userId)
            ? FieldValue.arrayUnion([userId])
            : FieldValue.arrayRemove([userId]),
      },
    );
  }

  static Future<void> toggleTyping(String groupID, bool isTyping) async {
    await groupDoc(groupID).update({
      'typing': isTyping
          ? FieldValue.arrayUnion([_uid])
          : FieldValue.arrayRemove([_uid])
    });
  }
}
