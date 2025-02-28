import 'package:flutter/material.dart' hide Image;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spotube/components/Album/AlbumCard.dart';
import 'package:spotube/components/LoaderShimmers/ShimmerPlaybuttonCard.dart';
import 'package:spotube/provider/SpotifyRequests.dart';
import 'package:spotube/utils/type_conversion_utils.dart';

class UserAlbums extends ConsumerWidget {
  const UserAlbums({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final albums = ref.watch(currentUserAlbumsQuery);

    return albums.when(
      data: (data) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 20, // gap between adjacent chips
            runSpacing: 20, // gap between lines
            alignment: WrapAlignment.center,
            children: data
                .map((album) =>
                    AlbumCard(TypeConversionUtils.simpleAlbum_X_Album(album)))
                .toList(),
          ),
        ),
      ),
      loading: () => const Center(child: ShimmerPlaybuttonCard(count: 7)),
      error: (_, __) => const Text("Failure is the pillar of success"),
    );
  }
}
