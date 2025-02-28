import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:palette_generator/palette_generator.dart';

final _paletteColorState = StateProvider<PaletteColor>(
  (ref) {
    return PaletteColor(Colors.grey[300]!, 0);
  },
);

PaletteColor usePaletteColor(String imageUrl, WidgetRef ref) {
  final context = useContext();
  final paletteColor = ref.watch(_paletteColorState);
  final mounted = useIsMounted();

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final palette = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(
          imageUrl,
          cacheKey: imageUrl,
          maxHeight: 50,
          maxWidth: 50,
        ),
      );
      if (!mounted()) return;
      final color = Theme.of(context).brightness == Brightness.light
          ? palette.lightMutedColor ?? palette.lightVibrantColor
          : palette.darkMutedColor ?? palette.darkVibrantColor;
      if (color != null) {
        ref.read(_paletteColorState.notifier).state = color;
      }
    });
    return null;
  }, [imageUrl]);

  return paletteColor;
}

PaletteGenerator usePaletteGenerator(
  BuildContext context,
  String imageUrl,
) {
  final palette = useState(PaletteGenerator.fromColors([]));
  final mounted = useIsMounted();

  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final newPalette = await PaletteGenerator.fromImageProvider(
        CachedNetworkImageProvider(
          imageUrl,
          cacheKey: imageUrl,
          maxHeight: 50,
          maxWidth: 50,
        ),
      );
      if (!mounted()) return;

      palette.value = newPalette;
    });
    return null;
  }, [imageUrl]);

  return palette.value;
}
