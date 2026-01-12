import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipe_finder_app/app/data/models/home_recipe_model.dart';
import 'package:recipe_finder_app/app/modules/favourite_recipe_page/bloc/favorites_bloc.dart';
import 'package:recipe_finder_app/app/modules/favourite_recipe_page/favourite_recipe_page.dart';
import 'package:recipe_finder_app/app/modules/recipe_detail_page/recipe_detail_page.dart';
import 'package:recipe_finder_app/app/modules/recipe_list_page/bloc/recipe_list_bloc.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({super.key});

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  bool isGridView = false;
  bool descending = false;
  late List<HomeRecipeModel> recipes = [];
  int filterCount = 0;
  @override
  void initState() {
    super.initState();
    context.read<RecipeListBloc>().add(fetchRecipeOnHome());
    context.read<RecipeListBloc>().add(fetchFilterCategories());
    context.read<FavoritesBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipeListBloc, RecipeListState>(
      listener: (context, state) {
        if (state is RecipeLoaded) {
          recipes = state.recipes;
          if (state.selectedArea != null && state.selectedCategory != null) {
            filterCount = 2;
          } else if (state.selectedArea == null &&
              state.selectedCategory == null) {
            filterCount = 0;
          } else {
            filterCount = 1;
          }
        }
      },
      builder: (context, state) {
        return SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: Color(0xFFf7f7f7),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 12.w,
                    left: 12.w,
                    top: 30.h,
                    bottom: 5.h,
                  ),
                  child: SizedBox(
                    height: 85.h,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'What would you like \n to cook today?',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FavouriteRecipePage(),
                                    ),
                                  );
                                },
                                child:
                                    BlocBuilder<FavoritesBloc, FavoritesState>(
                                      builder: (context, favState) {
                                        final hasItems =
                                            favState is FavoritesLoaded &&
                                            favState.favorites.isNotEmpty;
                                        return Stack(
                                          children: [
                                            Icon(
                                              hasItems
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: hasItems
                                                  ? Colors.red
                                                  : Colors.white,
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          descending = !descending;
                          context.read<RecipeListBloc>().add(
                            SortRecipes(descending: descending),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0),
                          child: Container(
                            // height: 20,
                            // width: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.sort_by_alpha),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: 10.h,
                            bottom: 10.h,
                            right: 8.w,
                            left: 8.w,
                          ),
                          height: 40.h,
                          // width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10.r,
                                offset: Offset(0, 4.h),
                                spreadRadius: 1.r,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 8.w, right: 8.w),
                            child: Row(
                              children: [
                                Icon(Icons.search),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9.0,
                                    ),
                                    child: TextField(
                                      onChanged: (value) {
                                        if (state is RecipeLoaded) {
                                          context.read<RecipeListBloc>().add(
                                            SearchQueryChanged(
                                              value,
                                              state.selectedArea,
                                              state.selectedCategory,
                                            ),
                                          );
                                        }
                                      },
                                      onSubmitted: (value) {
                                        if (state is RecipeLoaded) {
                                          context.read<RecipeListBloc>().add(
                                            SearchQueryChanged(
                                              value,
                                              state.selectedArea,
                                              state.selectedCategory,
                                            ),
                                          );
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hint: Text("Search any recipes"),
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30.h,
                                  width: 2.w,
                                  child: Container(color: Colors.grey),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final currentState = context
                                        .read<RecipeListBloc>()
                                        .state;
                                    if (currentState is RecipeLoaded &&
                                        currentState.categories.isEmpty &&
                                        currentState.areas.isEmpty) {
                                      context.read<RecipeListBloc>().add(
                                        fetchFilterCategories(),
                                      );
                                    }

                                    final result =
                                        await showModalBottomSheet<
                                          Map<String, String?>
                                        >(
                                          context: context,
                                          isScrollControlled: true,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (bottomSheetContext) =>
                                              BlocProvider.value(
                                                value: context
                                                    .read<RecipeListBloc>(),
                                                child: const FilterPopup(),
                                              ),
                                        );

                                    if (result != null) {
                                      print('Selected filters: $result');
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    child: Stack(
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/filter.svg',
                                        ),
                                        filterCount != 0
                                            ? Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                  ),
                                                  constraints: BoxConstraints(
                                                    minWidth: 12,
                                                    minHeight: 12,
                                                  ),
                                                  child: Text(
                                                    '${filterCount}',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 8,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isGridView = !isGridView;
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 5.w),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                isGridView ? Icons.grid_view : Icons.view_list,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: (state is RecipeLoading)
                      ? ListView.builder(
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 120.h,
                              margin: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10.r,
                                    offset: Offset(0, 4.h),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 120.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.r),
                                      color: Colors.black.withOpacity(0.04),
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(12.w),
                                        child: Container(
                                          height: 20.h,
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
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : recipes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_menu,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No recipes found',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (state is RecipeLoaded &&
                                  (state.selectedCategory != null ||
                                      state.selectedArea != null))
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: TextButton(
                                    onPressed: () {
                                      context.read<RecipeListBloc>().add(
                                        clearFilters(),
                                      );
                                    },
                                    child: Text('Clear filters'),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : isGridView
                      ? _buildGridView()
                      : ListView.builder(
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => RecipeDetailPage(
                                      mealId: recipes[index].id,
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 120.h,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10.r,
                                      offset: Offset(0, 4.h),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: Hero(
                                        tag: "image-${index}",
                                        child: Image.network(
                                          recipes[index].thumbnailUrl,
                                          width: double.infinity,
                                          height: 120.h,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 120.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.8),
                                          ],
                                          stops: const [0.5, 1.0],
                                        ),
                                      ),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: EdgeInsets.all(12.w),
                                          child: Text(
                                            recipes[index].name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              shadows: [
                                                Shadow(
                                                  offset: Offset(1, 1),
                                                  blurRadius: 4,
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: recipes.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return _RecipeGridCard(recipe: recipe, index: index);
      },
    );
  }
}

class _RecipeGridCard extends StatelessWidget {
  final HomeRecipeModel recipe;
  final int index;

  const _RecipeGridCard({required this.recipe, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailPage(mealId: recipe.id, index: index),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Hero(
              tag: "image-${index}",
              child: Image.network(
                recipe.thumbnailUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                recipe.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FilterPopup extends StatefulWidget {
  const FilterPopup({super.key});

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {
  String? selectedCategory;
  String? selectedArea;

  @override
  void initState() {
    super.initState();

    final currentState = context.read<RecipeListBloc>().state;
    if (currentState is RecipeLoaded) {
      selectedCategory = currentState.selectedCategory;
      selectedArea = currentState.selectedArea;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeListBloc, RecipeListState>(
      builder: (context, state) {
        if (state is RecipeLoaded &&
            (state.categories.isNotEmpty || state.areas.isNotEmpty)) {
          return Scaffold(
            backgroundColor: Color(0xFFf7f7f7),
            body: Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(context),
                    const SizedBox(height: 12),

                    if (state.categories.isNotEmpty) ...[
                      _sectionTitle('Category'),
                      _chipWrap(
                        state.categories.map((e) => e.name).toList(),
                        selectedCategory,
                        onSelected: (val) {
                          setState(() => selectedCategory = val);
                        },
                      ),
                      const SizedBox(height: 16),
                    ],

                    if (state.areas.isNotEmpty) ...[
                      _sectionTitle('Cuisine Area'),
                      _chipWrap(
                        state.areas.map((e) => e.name).toList(),
                        selectedArea,
                        onSelected: (val) {
                          setState(() => selectedArea = val);
                        },
                      ),
                      const SizedBox(height: 20),
                    ],

                    _actionButtons(context),
                  ],
                ),
              ),
            ),
          );
        }

        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is RecipeLoading)
                const CircularProgressIndicator()
              else ...[
                const Icon(Icons.filter_list, size: 48, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Loading filter options...',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Filters',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              selectedCategory = null;
              selectedArea = null;
            });

            context.read<RecipeListBloc>().add(clearFilters());
            Navigator.pop(context);
          },
          child: const Text('Clear All'),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
    );
  }

  Widget _chipWrap(
    List<String> items,
    String? selectedValue, {
    required Function(String?) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      children: items.map((item) {
        final isSelected = selectedValue == item;
        return ChoiceChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (_) => onSelected(isSelected ? null : item),
          selectedColor: Colors.amber,
        );
      }).toList(),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context.read<RecipeListBloc>().add(
                applyFilter(category: selectedCategory, area: selectedArea),
              );
              Navigator.pop(context, {
                'category': selectedCategory,
                'area': selectedArea,
              });
            },
            child: const Text('Apply'),
          ),
        ),
      ],
    );
  }
}
