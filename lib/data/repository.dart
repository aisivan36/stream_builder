import 'models/models.dart';

abstract class Repository {
  Future<List<Recipe>> findAllRecipes();

  /// [watchAllRecipes] whatches for any changes to the list of recipes.
  /// For example, if the user did a new seacrh it updates the list of recipes
  /// and notifies listeners accordingly
  Stream<List<Recipe>> watchAllRecipes();

  /// [watchAllIngredients] listens for changes in the list of ingredients
  /// displayed on the [Groceries] screen
  Stream<List<Ingredient>> watchAllIngredients();

  Future<Recipe> findRecipeById(int id);

  Future<List<Ingredient>> findAllIngredients();

  Future<List<Ingredient>> findRecipeIngredients(int recipeId);

  Future<int> insertRecipe(Recipe recipe);

  Future<List<int>> insertIngredients(List<Ingredient> ingredients);

  Future<void> deleteRecipe(Recipe recipe);

  Future<void> deleteIngredient(Ingredient ingredient);

  Future<void> deleteIngredients(List<Ingredient> ingredients);

  Future<void> deleteRecipeIngredients(int recipeId);

  Future init();
  void close();
}
