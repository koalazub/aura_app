import 'package:flutter/material.dart';

class Playlist extends StatefulWidget {
  final List<String> playlist;

  Playlist({Key key, this.playlist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Playlist();
}

//Retrieve the data from the checkbox list from playlistCheckbox
// Store in a list
//Pass the list to Playlist
class _Playlist extends State<Playlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Playlist'),
          centerTitle: true,
        ),
        body: Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: reorderablePlaylist(widget.playlist),
        ));
  }

  ReorderableListView reorderablePlaylist(List<String> playlist) {
    return ReorderableListView(
        children: <Widget>[
          if (playlist != null)
            for (var i in playlist)
              ListTile(
                trailing: Icon(Icons.drag_handle),
                key: ValueKey(i),
                title: Text(i),
              )
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (newIndex >= oldIndex) {
              newIndex -= 1;
            }
            final String item = playlist.removeAt(oldIndex);
            playlist.insert(newIndex, item);
          });
        });
  }
}
