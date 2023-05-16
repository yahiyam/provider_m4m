import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:m4m_app/pages/search_page.dart';
import 'package:m4m_app/pages/tabs/all_songs.dart';
import 'package:m4m_app/pages/tabs/liked_songs_screen.dart';
import 'package:m4m_app/pages/tabs/recently_played.dart';
import 'package:provider/provider.dart';

import '../dataBase/models/songdb.dart';
import '../provider/dark_mode.dart';
import '../widgets/menu_items.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AssetsAudioPlayer.withId('0');
    final List<Songs> audioList = [];
    final List<Songs> foundSongs = audioList;

    final darkModeState = Provider.of<DarkModeState>(context);
    final isGridMode = darkModeState.isDarkMode;

    void toggleViewMode() {
      darkModeState.toggleDarkMode();
      Navigator.pop(context);
    }

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear),
                          ),
                          IconButton(
                            onPressed: darkModeState.toggleDarkMode,
                            icon: Icon(
                              darkModeState.isDarkMode
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                buildMenuItems(
                  context: context,
                ),
              ],
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SearchSongs(
                        audioList: audioList,
                        audioPlayer: audioPlayer,
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: TextButton.icon(
                        onPressed: toggleViewMode,
                        icon: Icon(
                          isGridMode ? Icons.list : Icons.grid_view,
                        ),
                        label: isGridMode
                            ? const Text('List View')
                            : const Text('Grid View'),
                      ),
                    ),
                  ],
                ),
              ],
              floating: true,
              bottom: const TabBar(
                labelStyle:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
                isScrollable: true,
                tabs: [
                  Tab(text: "All Songs"),
                  Tab(text: "Favorites"),
                  Tab(text: "Recently Played"),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              AllSongs(
                foundSongs: foundSongs,
                isGridMode: isGridMode,
              ),
              FavoriteSongsScreen(isGridMode: isGridMode),
              RecentlyPlayed(isGridMode: isGridMode),
            ],
          ),
        ),
      ),
    );
  }
}
