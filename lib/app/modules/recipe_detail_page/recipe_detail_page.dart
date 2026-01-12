import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_finder_app/app/data/models/recipe_detail_model.dart';
import 'package:recipe_finder_app/app/modules/favourite_recipe_page/bloc/favorites_bloc.dart';
import 'package:recipe_finder_app/app/modules/recipe_detail_page/bloc/recipe_detail_bloc.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class RecipeDetailPage extends StatefulWidget {
  String mealId;
  int index;
  RecipeDetailPage({super.key, required this.mealId, required this.index});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  YoutubePlayerController? _controller;
  late List<RecipeDetailModel> mealRecipe = [];

  @override
  void initState() {
    super.initState();
    context.read<RecipeDetailBloc>().add(
      fetchRecipeDetail(mealId: widget.mealId),
    );
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  void _initializeYouTubePlayer(String ytUrl) {
    _controller?.close();

    if (ytUrl.isEmpty) {
      print('YouTube URL is empty');
      _controller = null;
      return;
    }

    String? videoId = _extractVideoId(ytUrl);

    print('YT URL => $ytUrl');
    print('VIDEO ID => $videoId');

    if (videoId != null && videoId.isNotEmpty) {
      try {
        _controller = YoutubePlayerController.fromVideoId(
          videoId: videoId,
          autoPlay: false,
          params: const YoutubePlayerParams(
            showControls: true,
            showFullscreenButton: true,
            mute: false,
            showVideoAnnotations: false,
            enableCaption: false,
            strictRelatedVideos: true,
          ),
        );
        print('YouTube controller initialized successfully');
      } catch (e) {
        print('Error initializing YouTube controller: $e');
        _controller = null;
      }
    } else {
      print('Invalid video ID extracted from URL');
      _controller = null;
    }
  }

  String? _extractVideoId(String url) {
    if (url.isEmpty) return null;

    final regExp = RegExp(
      r'(?:youtube\.com\/(?:[^\/]+\/.+\/|(?:v|e(?:mbed)?)\/|.*[?&]v=)|youtu\.be\/)([^"&?\/\s]{11})',
      caseSensitive: false,
    );

    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight * 0.4;
    return BlocConsumer<RecipeDetailBloc, RecipeDetailState>(
      listener: (context, state) {
        if (state is recipieDetailfetched) {
          mealRecipe = state.recipeDetail;

          if (mealRecipe.isNotEmpty) {
            final ytUrl = mealRecipe[0].youtubeUrl ?? '';
            _initializeYouTubePlayer(ytUrl);
            setState(() {});
          }
        }
      },
      builder: (context, state) {
        if (state is RecipeDetailLoading || mealRecipe.isEmpty) {
          return Scaffold(
            backgroundColor: Color(0xFFf7f7f7),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(0),
                    child: Container(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      Hero(
                        tag: "image-${widget.index}",
                        child: Container(
                          width: double.infinity,
                          height: imageHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.black.withOpacity(0.04),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 20.h,
                              width: 150.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: Colors.black.withOpacity(0.04),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: Colors.black.withOpacity(0.04),
                              ),
                            ),
                            SizedBox(width: 12),
                            Container(
                              height: 40.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                color: Colors.black.withOpacity(0.04),
                              ),
                            ),
                            SizedBox(width: 12),
                          ],
                        ),
                        SizedBox(height: 20),

                        Container(
                          height: 40.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.black.withOpacity(0.04),
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 200.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            color: Colors.black.withOpacity(0.04),
                          ),
                        ),

                        SizedBox(height: 30),

                        Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12),

                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                    color: Colors.black12,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Container(
                                      height: 40.h,
                                      width: 40.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        color: Colors.black.withOpacity(0.04),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30.h,
                                          width: 150.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                            color: Colors.black.withOpacity(
                                              0.04,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 20.h,
                                          width: 50.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16.r,
                                            ),
                                            color: Colors.black.withOpacity(
                                              0.04,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 30),

                        Text(
                          'Recipe Video',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 8,
                                color: Colors.black12,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _controller == null
                                ? Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.video_library_outlined,
                                            size: 48,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Video not available',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                          if (mealRecipe.isNotEmpty &&
                                              mealRecipe[0].youtubeUrl != null)
                                            Padding(
                                              padding: EdgeInsets.only(top: 4),
                                              child: Text(
                                                'URL: ${mealRecipe[0].youtubeUrl}',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                : YoutubePlayer(
                                    controller: _controller!,
                                    aspectRatio: 16 / 9,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        print('Seeeeeee herrreerererererer${mealRecipe[0].youtubeUrl}');
        final steps = parseInstructions(mealRecipe[0].instructions);

        return SafeArea(
          child: Scaffold(
            backgroundColor: Color(0xFFf7f7f7),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    BlocBuilder<FavoritesBloc, FavoritesState>(
                      builder: (context, favState) {
                        final isFavorite =
                            favState is FavoritesLoaded &&
                            favState.favoriteIds.contains(widget.mealId);
                        return AnimatedScale(
                          scale: isFavorite ? 1.3 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                          child: AnimatedOpacity(
                            opacity: 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.black,
                              ),
                              onPressed: () {
                                if (mealRecipe.isNotEmpty) {
                                  context.read<FavoritesBloc>().add(
                                    ToggleFavorite(
                                      id: widget.mealId,
                                      name: mealRecipe[0].name,
                                      thumbnailUrl: mealRecipe[0].thumbnailUrl,
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(0),
                    child: Container(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _openImageViewer(context, mealRecipe[0].thumbnailUrl);
                        },
                        child: Container(
                          width: double.infinity,
                          height: imageHeight,
                          child: Hero(
                            tag: "image-${widget.index}",
                            child: Image.network(
                              mealRecipe[0].thumbnailUrl,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 20,
                        left: 20,
                        right: 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mealRecipe[0].name,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 4,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              label: Text(mealRecipe[0].area),
                              backgroundColor: Colors.orange.shade100,
                              shape: StadiumBorder(),
                            ),
                            SizedBox(width: 12),
                            Chip(
                              label: Text(mealRecipe[0].category),
                              backgroundColor: Colors.blue.shade100,
                              shape: StadiumBorder(),
                            ),
                            SizedBox(width: 12),
                          ],
                        ),
                        SizedBox(height: 20),

                        Text(
                          mealRecipe[0].name,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: steps.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.amber,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                    child: Text(
                                      steps[index],
                                      softWrap: true,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 30),

                        Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mealRecipe[0].ingredients.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12),

                          itemBuilder: (context, index) {
                            final ingredient = mealRecipe[0].ingredients[index];
                            return Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 2),
                                    blurRadius: 8,
                                    color: Colors.black12,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.ramen_dining,
                                      color: Colors.amber[700],
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ingredient.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          ingredient.measure,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 30),

                        Text(
                          'Recipe Video',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 2),
                                blurRadius: 8,
                                color: Colors.black12,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _controller == null
                                ? Container(
                                    height: 200,
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.video_library_outlined,
                                            size: 48,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Video not available',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                          if (mealRecipe.isNotEmpty &&
                                              mealRecipe[0].youtubeUrl != null)
                                            Padding(
                                              padding: EdgeInsets.only(top: 4),
                                              child: Text(
                                                'URL: ${mealRecipe[0].youtubeUrl}',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 12,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  )
                                : YoutubePlayer(
                                    controller: _controller!,
                                    aspectRatio: 16 / 9,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openImageViewer(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Center(
                  child: Hero(
                    tag: 'image-${widget.index}',
                    child: Image.network(imageUrl),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

List<String> parseInstructions(String instructions) {
  return instructions
      .split(RegExp(r'\r?\n'))
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}
