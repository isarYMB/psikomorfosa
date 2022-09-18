import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';

import '../../../../imports.dart';
import '../../data/groups.dart';
import '../../models/group.dart';

class GroupsSearch extends StatefulWidget {
  @override
  _GroupsSearchState createState() => _GroupsSearchState();
}

class _GroupsSearchState extends State<GroupsSearch> {
  final textController = TextEditingController();

  List<Group>? groups;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await 0.1.delay();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child:
              // ListView.builder(
              //     itemCount: groups!.length,
              //     itemBuilder: (context, index) {
              //       final group = groups![index];

              //       return ListTile(
              //         onTap: () => ChatRoutes.toGroupInfo(group),
              //         leading: AvatarWidget(
              //           group.photoURL,
              //           radius: 50,
              //         ),
              //         title: Text(
              //           group.name,
              //           style: GoogleFonts.basic(
              //             textStyle: Theme.of(context).textTheme.subtitle1,
              //           ),
              //         ),
              //         trailing: group.isAdmin()
              //             ? OutlinedButton(onPressed: () {}, child: Text(t.Admin))
              //             : group.isMember()
              //                 ? OutlinedButton(
              //                     onPressed: () {}, child: Text(t.Joined))
              //                 : null,
              //       );
              //     })
              SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: PaginatedSearchBar<Group>(
              inputStyle: TextStyle(
                fontSize: 20,
              ),
              inputDecoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 25),
                hintText: 'Search for groups',
                border: InputBorder.none,
                prefixIcon: BackButton(),
              ),
              autoFocus: true,
              maxHeight: Get.height,
              containerDecoration: BoxDecoration(),
              itemPadding: 0,
              padding: EdgeInsets.symmetric(vertical: 10),
              emptyBuilder: (_) => const Text("Oops, no results found!"),
              itemBuilder: (_, {required item, required index}) =>
                  _SearchResultItem(item),
              onSearch: ({
                required pageIndex,
                required pageSize,
                required searchQuery,
              }) async {
                final res = await GroupsRepository.groupsSearch(searchQuery);
                return res;
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final Group group;

  const _SearchResultItem(
    this.group,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListTile(
        onTap: () => ChatRoutes.toGroupInfo(group),
        leading: AvatarWidget(
          group.photoURL,
          radius: 50,
        ),
        title: Text(
          group.name,
          style: GoogleFonts.basic(
            textStyle: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        trailing: group.isAdmin()
            ? OutlinedButton(onPressed: () {}, child: Text(t.Admin))
            : group.isMember()
                ? OutlinedButton(onPressed: () {}, child: Text(t.Joined))
                : null,
      ),
    );
  }
}
