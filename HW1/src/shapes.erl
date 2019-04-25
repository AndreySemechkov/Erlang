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

%% This function gets a shapes data-structure {shapes, [list of shapes]} and returns the sum of all areas
shapesArea({shapes,[]}) -> 0;
shapesArea({shapes,[H|T]}) ->
  case getShape(H) of
    rectangle -> calcAreaRectangle(getShapeDim(H)) + shapesArea({shapes, T});
    triangle -> calcAreaTriangle(getShapeDim(H)) + shapesArea({shapes, T});
    ellipse -> calcAreaEllipse(getShapeDim(H)) + shapesArea({shapes, T})
  end.

%% This function gets a shapes data-structure {shapes, [list of shapes]} and returns the sum of all triangle areas
trianglesArea({shapes,[]}) -> 0;
trianglesArea({shapes,[H|T]}) ->
   case getShape(H) == triangle of
      true -> calcAreaTriangle(getShapeDim(H)) + trianglesArea({shapes, T});
      false -> 0 + trianglesArea({shapes,T})
   end.

%% This function gets a shapes data-structure {shapes, [list of shapes]} and returns the sum of all square areas
squaresArea({shapes,[]}) -> 0;
squaresArea({shapes, [H|T]})  ->
   case getShape(H) == rectangle of
      true -> calcAreaSquare(getShapeDim(H)) + squaresArea({shapes, T});
      false -> 0 + squaresArea({shapes, T})
   end.

shapesFilter(Shape) ->
   case Shape of
      rectangle -> fun rectangleFilter/1;
      triangle -> fun triangleFilter/1;
      ellipse -> fun ellipseFilter/1
   end.

%% This function gets a shape tuple {shape, {dim, x, y}} and returns the shape
getShape(ShapeTuple) ->
   {Shape, {_, _, _}} = ShapeTuple,
   Shape.

%% This function gets a shape tuple {shape, {dim, x, y}} and returns the dimension tuple
getShapeDim(ShapeTuple) ->
   {_, ShapeDim} = ShapeTuple,
   ShapeDim.

%% Calculating the area of a rectangle if dimensions are valid.
%% If not, returns a proper message.
calcAreaRectangle({dim, Width, Height}) when Width > 0 , Height > 0 ->
   Width * Height;
calcAreaRectangle({dim, _, _}) ->
   io:format("Invalid Dimensions!~n").

%% Calculating the area of a triangle if dimensions are valid.
%% If not, returns a proper message.
calcAreaTriangle({dim, Base, Height}) when Base > 0 , Height > 0 ->
   Base * Height / 2;
calcAreaTriangle({dim, _, _}) ->
   io:format("Invalid Dimensions!~n").

%% Calculating the area of an ellipse if dimensions are valid.
%% If not, returns a proper message.
calcAreaEllipse({radius, Radius1, Radius2}) when Radius1 > 0 , Radius2 > 0 ->
   math:pi() * Radius1 * Radius2;
calcAreaEllipse({radius, _, _}) ->
   io:format("Invalid Dimensions!~n").

%% Calculating the area of an square if dimensions are valid.
%% If not, returns a proper message.
calcAreaSquare({dim, Height, Width}) when Height == Width -> math:pow(Width,2);
calcAreaSquare({dim, _, _}) -> 0.


rectangleFilter({shapes, []}) -> [];
rectangleFilter({shapes, [H|T]}) ->
   case getShape(H) == rectangle of
      true -> [H|rectangleFilter({shapes, T})];
      false -> rectangleFilter({shapes, T})
   end.

triangleFilter({shapes, []}) -> [];
triangleFilter({shapes, [H|T]}) ->
   case getShape(H) == triangle of
      true -> [H|rectangleFilter({shapes, T})];
      false -> rectangleFilter({shapes, T})
   end.

ellipseFilter({shapes, []}) -> [];
ellipseFilter({shapes, [H|T]}) ->
   case getShape(H) == ellipse of
      true -> [H|rectangleFilter({shapes, T})];
      false -> rectangleFilter({shapes, T})
   end.