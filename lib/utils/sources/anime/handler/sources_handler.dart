import 'package:anymex/utils/sources/anime/extensions/animepahe/animepahe.dart';
import 'package:anymex/utils/sources/anime/extensions/anivibe/anivibe.dart';
import 'package:anymex/utils/sources/anime/extensions/aniwatch_api/api.dart';
import 'package:anymex/utils/sources/anime/base/source_base.dart';
import 'package:anymex/utils/sources/anime/extensions/aniwatch/aniwatch.dart';
import 'package:anymex/utils/sources/anime/extensions/gogoanime/gogoanime.dart';
import 'package:anymex/utils/sources/anime/extensions/hiddenleaf/hiddenleaf.dart';
import 'package:anymex/utils/sources/anime/extensions/yugenanime/yugenanime.dart';
import 'package:anymex/utils/sources/manga/helper/jaro_helper.dart';

class SourcesHandler {
  final Map<String, SourceBase> animeSourcesMap = {
    'HiAnime (Scrapper)': HiAnime(),
    "HiAnime (API)": HiAnimeApi(),
    "GogoAnime": GogoAnime(),
    "YugenAnime": YugenAnime(),
    "AnimePahe": AnimePahe(),
    "AniVibe": AniVibe(),
    "HiddenLeaf": HiddenLeaf()
  };

  SourcesHandler() {
    selectedSource = animeSourcesMap.entries.elementAt(3).key;
    isMulti = animeSourcesMap[selectedSource]!.isMulti;
  }
  String selectedSource = '';
  bool isMulti = false;

  String getSelectedSource() {
    if (selectedSource == '') {
      selectedSource = animeSourcesMap.entries.first.key;
      return selectedSource;
    }
    return selectedSource;
  }

  bool getExtensionType() {
    return animeSourcesMap[selectedSource]!.isMulti;
  }

  List<dynamic> getAvailableSource() {
    return animeSourcesMap.entries.map((entry) {
      return {'name': entry.value.sourceName, 'isMulti': entry.value.isMulti};
    }).toList();
  }

  void changeSelectedSource(String sourceName) {
    if (animeSourcesMap.entries.any((entry) => entry.key == sourceName)) {
      selectedSource = sourceName;
    } else {
      selectedSource = animeSourcesMap.entries.first.key;
    }
  }

  Future<dynamic> mapToAnilist(String title) async {
    final animeList = await fetchSearchResults(title);
    String bestMatchId = findBestMatch(title, animeList);
    if (bestMatchId.isNotEmpty) {
      return await fetchEpisodes(bestMatchId);
    } else {
      throw Exception('No suitable match found for the query');
    }
  }

  Future<dynamic> fetchEpisodes(String url) async {
    final animeList =
        await animeSourcesMap[selectedSource]?.scrapeEpisodes(url);
    return animeList;
  }

  Future<dynamic> fetchEpisodesSrcs(String episodeId,
      {AnimeServers server = AnimeServers.MegaCloud,
      String? category,
      String? lang}) async {
    final animeList = await animeSourcesMap[selectedSource]?.scrapeEpisodesSrcs(
        episodeId,
        server: server,
        category: category,
        lang: lang);
    return animeList;
  }

  Future<dynamic> fetchSearchResults(String query) async {
    final animeList =
        await animeSourcesMap[selectedSource]?.scrapeSearchResults(query);
    return animeList;
  }
}
