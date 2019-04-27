%%%-------------------------------------------------------------------
%%% @author Sean
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Apr 2019 2:22 PM
%%%-------------------------------------------------------------------
-module(shapes).
-author("Sean").

%% API
-export([shapesArea/1]).
-export([squaresArea/1]).
-export([trianglesArea/1]).
-export([shapesFilter/1]).
-export([shapesFilter2/1]).

%% =========================================== %%
%%             Exported Functions              %%
%% =========================================== %%

%% This function gets a shapes data-structure {shapes, [list of shapes]}
%% returns the sum of the areas of all the shapes
shapesArea({shapes,[]}) -> 0;
shapesArea({shapes,[H|T]}) ->
   ValidDS = isDSLegal({shapes,[H|T]}),
   if ValidDS == true ->
      calcArea({shapes,[H|T]}, all)
   end.

%% This function gets a shapes data-structure {shapes, [list of shapes]}
%% returns the sum of the areas of all the squares
squaresArea({shapes,[]}) -> 0;
squaresArea({shapes,[H|T]}) ->
   ValidDS = isDSLegal({shapes,[H|T]}),
   if ValidDS == true ->
      calcArea({shapes,[H|T]}, square)
   end.

%% This function gets a shapes data-structure {shapes, [list of shapes]}
%% returns the sum of the areas of all the triangles
trianglesArea({shapes,[]}) -> 0;
trianglesArea({shapes,[H|T]}) ->
   ValidDS = isDSLegal({shapes,[H|T]}),
   if ValidDS == true ->
      calcArea({shapes,[H|T]}, triangle)
   end.

%% This function gets a shape
%% returns a function that filters out the other shapes
shapesFilter(Shape) ->
   case Shape of
      rectangle -> fun rectangleFilter/1;
      triangle -> fun triangleFilter/1;
      ellipse -> fun ellipseFilter/1
   end.

%% This function gets a shape
%% returns a function that filters out the other shapes
shapesFilter2(Shape) ->
   case Shape of
      rectangle -> fun rectangleFilter/1;
      square -> fun squareFilter/1;
      triangle -> fun triangleFilter/1;
      ellipse -> fun ellipseFilter/1;
      circle -> fun circleFilter/1
   end.


%% ========================================== %%
%%             Private Functions              %%
%% ========================================== %%

%%%%%%%%%%%%%%%%%%%%%%%
%% Validity Checkers %%
%%%%%%%%%%%%%%%%%%%%%%%

%% This function gets a shapes data-structure {shapes, [list of shapes]}
%% returns whether the data-structure is valid
isDSLegal({shapes, []}) -> true;
isDSLegal({shapes, [H|T]}) ->
   ShapeIsValid = isShapeNameLegal(H),
   ShapeDimIsValid = isDimLegal(H),
   if
      ShapeIsValid, ShapeDimIsValid -> isDSLegal({shapes, T});
      true -> false
   end.

%% This function gets a shape tuple ({shape, {var, x, y}})
%% returns whether the shape name is valid
isShapeNameLegal(ShapeTuple) ->
   Shape = getShape(ShapeTuple),
   case Shape of
      rectangle -> true;
      triangle -> true;
      ellipse -> true;
      _ -> false
   end.

%% This function gets a shape tuple ({shape, {var, x, y}})
%% returns whether the shape dimensions are valid
isDimLegal(ShapeTuple) ->
   ShapeDim = getShapeDim(ShapeTuple),
   {_, Param1, Param2} = ShapeDim,
   if
      Param1 > 0 , Param2 > 0 -> true;
      true -> false
   end.

%%%%%%%%%%%%%
%% Getters %%
%%%%%%%%%%%%%

%% This function gets a shape tuple {shape, {dim, x, y}}
%% returns the shape's name
getShape(ShapeTuple) ->
   {Shape, {_, _, _}} = ShapeTuple,
   Shape.

%% This function gets a shape tuple {shape, {dim, x, y}}
%% returns the dimension tuple
getShapeDim(ShapeTuple) ->
   {_, ShapeDim} = ShapeTuple,
   ShapeDim.

%%%%%%%%%%%%%%%%%
%% Calculators %%
%%%%%%%%%%%%%%%%%

%% Calculating the area of all (specific or not) shapes in a provided list.
calcArea({shapes,[]}, _) -> 0;
calcArea({shapes,[H|T]}, ShapeFilter) ->
   case ShapeFilter of
      all ->
         case getShape(H) of
            rectangle -> calcAreaRectangle(getShapeDim(H)) + calcArea({shapes, T}, all);
            triangle -> calcAreaTriangle(getShapeDim(H)) + calcArea({shapes, T}, all);
            ellipse -> calcAreaEllipse(getShapeDim(H)) + calcArea({shapes, T}, all)
         end;
      triangle ->
         case getShape(H) == triangle of
            true -> calcAreaTriangle(getShapeDim(H)) + calcArea({shapes, T}, triangle);
            false -> 0 + calcArea({shapes,T}, triangle)
         end;
      square ->
         case getShape(H) == rectangle of
            true -> calcAreaSquare(getShapeDim(H)) + calcArea({shapes, T}, square);
            false -> 0 + calcArea({shapes, T}, square)
         end
   end.

%% Calculating the area of a rectangle if dimensions are valid.
calcAreaRectangle({dim, Width, Height}) when Width > 0 , Height > 0 -> Width * Height.

%% Calculating the area of a triangle if dimensions are valid.
calcAreaTriangle({dim, Base, Height}) when Base > 0 , Height > 0 -> Base * Height / 2.

%% Calculating the area of an ellipse if dimensions are valid.
calcAreaEllipse({radius, Radius1, Radius2}) when Radius1 > 0 , Radius2 > 0 -> math:pi() * Radius1 * Radius2.

%% Calculating the area of an square if dimensions are valid.
calcAreaSquare({dim, Side, Side}) when Side > 0 -> math:pow(Side,2);
calcAreaSquare({dim, Width, Height}) when Width > 0 , Height > 0 -> 0.

%%%%%%%%%%%%%
%% Filters %%
%%%%%%%%%%%%%

%% This function gets a shapes data-structure {shapes, [list of shapes]}
%% returns a rectangle filtered list
rectangleFilter({shapes,[]}) -> {shapes,[]};
rectangleFilter({shapes,[H|T]}) -> shapeFilter({shapes,[H|T]}, rectangle).

%% This function gets a shapes data-structure {shapes, [list of shapes]}
%% returns a triangle filtered list
triangleFilter({shapes,[]}) -> {shapes,[]};
triangleFilter({shapes,[H|T]}) -> shapeFilter({shapes,[H|T]}, triangle).

%% This function gets a shapes data-structure {shapes, [list of shapes]}
%% returns a ellipse filtered list
ellipseFilter({shapes,[]}) -> {shapes,[]};
ellipseFilter({shapes,[H|T]}) -> shapeFilter({shapes,[H|T]}, ellipse).

%% This function gets a shapes data-structure {shapes, [list of shapes]}
%% returns a square filtered list
squareFilter({shapes,[]}) -> {shapes,[]};
squareFilter({shapes,[H|T]}) -> shapeFilter({shapes,[H|T]}, square).

%% This function gets a shapes data-structure {shapes, [list of shapes]}
%% returns a circle filtered list
circleFilter({shapes,[]}) -> {shapes,[]};
circleFilter({shapes,[H|T]}) -> shapeFilter({shapes,[H|T]}, circle).

%% This function gets a shapes DS {shapes, [list of shapes]} and a shape
%% Checks the validity of the DS and returns a Shape filtered DS
shapeFilter({shapes,[H|T]}, Shape) ->
   ValidDS = isDSLegal({shapes,[H|T]}),
   if ValidDS == true ->
      ShapesList = listFilter(Shape, {shapes,[H|T]}),
      {shapes, ShapesList}
   end.

%% This function gets a shapes DS {shapes, [list of shapes]}
%% returns a Shape filtered list
listFilter(_, {shapes, []}) -> [];
listFilter(Shape, {shapes, [H|T]}) ->
   case Shape of
      square ->
         case getShape(H) == rectangle of
            true ->
               {_, Width, Height} = getShapeDim(H),
               case Height == Width of
                  true -> [H|listFilter(Shape, {shapes, T})];
                  false -> listFilter(Shape, {shapes, T})
               end;
            false -> listFilter(Shape, {shapes, T})
         end;
      circle ->
         case getShape(H) == ellipse of
            true ->
               {_, Radius1, Radius2} = getShapeDim(H),
               case Radius1 == Radius2 of
                  true -> [H|listFilter(Shape, {shapes, T})];
                  false -> listFilter(Shape, {shapes, T})
               end;
            false -> listFilter(Shape, {shapes, T})
         end;
      rectangle ->
         case getShape(H) == rectangle of
            true -> [H|listFilter(Shape, {shapes, T})];
            false -> listFilter(Shape, {shapes, T})
         end;
      triangle ->
         case getShape(H) == triangle of
            true -> [H|listFilter(Shape, {shapes, T})];
            false -> listFilter(Shape, {shapes, T})
         end;
      ellipse ->
         case getShape(H) == ellipse of
            true -> [H|listFilter(Shape, {shapes, T})];
            false -> listFilter(Shape, {shapes, T})
         end
   end.