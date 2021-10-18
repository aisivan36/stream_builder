import 'dart:core';
import 'dart:async';
import 'repository.dart';
import 'models/models.dart';

class MemoryRepository extends Repository {
  final List<Recipe> _currentRecipes = <Recipe>[];
  final List<Ingredient> _currentIngredients = <Ingredient>[];

  ///[_recipeStream] and [_ingredientStream] are private fields for the streams.
  /// These will be [captured] the first time a [stream] is requested,
  /// which prevents new streams from being created for each call.
  Stream<List<Recipe>>? _recipeStream;
  Stream<List<Ingredient>>? _ingredientStream;

  /// Creates [StreamControllers] for recipes and ingredients
  final StreamController _recipeStreamController =
      StreamController<List<Recipe>>();
  final StreamController _ingredientStreamController =
      StreamController<List<Ingredient>>();

  /// Check to see if we already have the [stream]. If not,
  /// call the stream method, which creates a new stream, then return it.
  @override
  Stream<List<Recipe>> watchAllRecipes() {
    if (_recipeStream == null) {
      _recipeStream = _recipeStreamController.stream as Stream<List<Recipe>>;
    }
    return _recipeStream!;
  }

  /// as well as the above's [Ingredient]
  @override
  Stream<List<Ingredient>> watchAllIngredients() {
    if (_ingredientStream == null) {
      _ingredientStream =
          _ingredientStreamController.stream as Stream<List<Ingredient>>;
    }
    return _ingredientStream!;
  }

  @override
  Future<List<Recipe>> findAllRecipes() {
    return Future.value(_currentRecipes);
  }

  @override
  Future<Recipe> findRecipeById(int id) {
    return Future.value(
        _currentRecipes.firstWhere((recipe) => recipe.id == id));
  }

  @override
  Future<List<Ingredient>> findAllIngredients() {
    return Future.value(_currentIngredients);
  }

  @override
  Future<List<Ingredient>> findRecipeIngredients(int recipeId) {
    final recipe =
        _currentRecipes.firstWhere((recipe) => recipe.id == recipeId);

    final recipeIngredients = _currentIngredients
        .where((ingredient) => ingredient.recipeId == recipe.id)
        .toList();

    return Future.value(recipeIngredients);
  }

  @override
  Future<int> insertRecipe(Recipe recipe) {
    _currentRecipes.add(recipe);

    /// adds [_currentRecipes] to the sink
    _recipeStreamController.sink.add(_currentRecipes);

    if (recipe.ingredients != null) {
      insertIngredients(recipe.ingredients!);
    }
    return Future.value(0);
  }

  @override
  Future<List<int>> insertIngredients(List<Ingredient> ingredients) {
    if (ingredients.length != 0) {
      _currentIngredients.addAll(ingredients);
      _ingredientStreamController.sink.add(_currentIngredients);
    }
    return Future.value(<int>[]);
  }

  @override
  Future<void> deleteRecipe(Recipe recipe) {
    _currentRecipes.remove(recipe);

    _recipeStreamController.sink.add(_currentRecipes);

    if (recipe.id != null) {
      deleteRecipeIngredients(recipe.id!);
    }

    return Future.value();
  }

  @override
  Future<void> deleteIngredient(Ingredient ingredient) {
    _currentIngredients.remove(ingredient);
    _ingredientStreamController.sink.add(_currentIngredients);

    return Future.value();
  }

  @override
  Future<void> deleteIngredients(List<Ingredient> ingredients) {
    _currentIngredients
        .removeWhere((ingredient) => ingredients.contains(ingredient));

    _ingredientStreamController.sink.add(_currentIngredients);

    return Future.value();
  }

  @override
  Future<void> deleteRecipeIngredients(int recipeId) {
    _currentIngredients
        .removeWhere((ingredient) => ingredient.recipeId == recipeId);
    _recipeStreamController.sink.add(_currentIngredients);

    return Future.value();
  }

  @override
  Future init() {
    return Future.value();
  }

  @override
  void close() {
    ///close the stream
    _recipeStreamController.close();
    _ingredientStreamController.close();
  }
}
