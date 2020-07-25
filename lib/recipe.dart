class Recipe{

  String recipeName;
  String recipeDescription;
  String recipeRef;
  double recipeDiff;
  int recipeDurHr;
  int recipeDurMin;
  double recipeDur;


  Recipe({this.recipeDescription, this.recipeName, this.recipeRef, this.recipeDiff, this.recipeDurHr, this.recipeDurMin});

  int getDuration() {
    return (recipeDurHr * 60 + recipeDurMin).toInt();
  }
}