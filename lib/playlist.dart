import 'package:aura_app/MusicLibraryManager.dart';
import 'package:aura_app/Slider.dart';
import 'package:flutter/material.dart';

class Playlist extends StatefulWidget {
  final List<String> playlist;

  Playlist({Key key, this.playlist}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Playlist(playlist);
}

//Retrieve the data from the checkbox list from playlistCheckbox
// Store in a list
//Pass the list to Playlist
class _Playlist extends State<Playlist> with SingleTickerProviderStateMixin {
  final List<String> playlist;

  _Playlist(this.playlist);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Playlist'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: reorderablePlaylist(playlist),
              ),
            ),
            Container(
              height: 50,
              child: FloatingActionButton.extended(
                onPressed: () {
                  return playFromURL(playlist[1]);
                },
                label: Text('Play'),
              ),
            ),
            Expanded(child: SliderClass(2, 10.0, 5.0, playlist)),
          ],
        ));
  }

  ReorderableListView reorderablePlaylist(List<String> playlist) {
    int index = 0;
    return ReorderableListView(
        children: <Widget>[
          if (playlist != null)
            for (var i in playlist)
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent,
                  child: Text(
                    '${index += 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
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
            for (var i in playlist) {
              print(i);
            }
          });
        });
  }
}
