import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../imports.dart';
import '../../data/groups.dart';
import '../../models/group.dart';
import 'widgets/group_item.dart';

class GroupsListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GroupsListPageState();
}

class _GroupsListPageState extends State<GroupsListPage> {
  final refreshController = RefreshController();

  List<Group> groups = [];
  int limit = 20;

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor:Color.fromRGBO(163, 144, 201, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8, left: 20),
                  child: Text(
                    t.Groups,
                    style: GoogleFonts.nunito(
                        textStyle: theme.textTheme.headline5,color: Colors.white
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search,color: Colors.white,),
                  onPressed: ChatRoutes.toGroupsSearch,
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<List<Group>>(
                stream: GroupsRepository.myGroupsStream(limit),
                builder: (_, snap) {
                  groups = snap.data ?? groups;
                  if (groups.isEmpty) {
                    return Center(
                      child: GestureDetector(
                        onTap: ChatRoutes.toGroupsSearch,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.search,color: Colors.white,),
                            SizedBox(width: 22),
                            Text(t.Search,style: TextStyle(color: Colors.white),)
                          ],
                        ),
                      ),
                    );
                  }
                  return SmartRefresher(
                    controller: refreshController,
                    enablePullUp: groups.length >= limit,
                    enablePullDown: false,
                    onLoading: () {
                      setState(() => limit += 20);
                      refreshController.loadComplete();
                    },
                    child: ListView.builder(
                      itemCount: groups.length,
                      itemBuilder: (_, i) => GroupItem(groups[i]),
                    ),
                  );
                },
              ),
            ),
            TextButton.icon(
              onPressed: ChatRoutes.toGroupEditor,
              style: TextButton.styleFrom(primary: Colors.white),
              label: Text(t.CreateGroup),
              icon: Icon(Icons.add_circle_outline),
            )
          ],
        ),
      ),
    );
  }
}
