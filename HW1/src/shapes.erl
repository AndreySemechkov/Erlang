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
-export([trianglesArea/1]).
-export([getShape/1]).
-export([getShapeDim/1]).
-export([calcAreaRectangle/1]).
-export([calcAreaTriangle/1]).
-export([calcAreaEllipse/1]).
-export([squaresArea/1]).
-export([testSquare/0]).

shapesArea({shapes,[]}) -> 0;
shapesArea({shapes,[H|T]}) ->
  case getShape(H) of
    rectangle -> calcAreaRectangle(getShapeDim(H)) + shapesArea({shapes, T});
    triangle -> calcAreaTriangle(getShapeDim(H)) + shapesArea({shapes, T});
    ellipse -> calcAreaEllipse(getShapeDim(H)) + shapesArea({shapes, T})
  end.


trianglesArea({shapes,[]}) -> 0;
trianglesArea({shapes,[H|T]}) ->
   case getShape(H) == triangle of
      true -> calcAreaTriangle(getShapeDim(H)) + trianglesArea({shapes, T});
      false -> 0 + trianglesArea({shapes,T})
   end.


getShape(ShapeTuple) ->
   {Shape, {_, _, _}} = ShapeTuple,
   Shape.

getShapeDim(ShapeTuple) ->
   {_, ShapeDim} = ShapeTuple,
   ShapeDim.

calcAreaRectangle({dim, Width, Height}) when Width > 0 , Height > 0 ->
   Width * Height;
calcAreaRectangle({dim, _, _}) ->
   io:format("Invalid Dimensions!~n").

calcAreaTriangle({dim, Base, Height}) when Base > 0 , Height > 0 ->
   Base * Height / 2;
calcAreaTriangle({dim, _, _}) ->
   io:format("Invalid Dimensions!~n").

calcAreaEllipse({radius, Radius1, Radius2}) when Radius1 > 0 , Radius2 > 0 ->
   math:pi() * Radius1 * Radius2;
calcAreaEllipse({radius, _, _}) ->
   io:format("Invalid Dimensions!~n").

squaresArea({shapes,[]}) -> 0;
squaresArea({shapes, [H|T]})  ->
   case getShape(H) == rectangle of
      true -> calcAreaSquare(getShapeDim(H)) + squaresArea({shapes, T});
      false -> 0 + squaresArea({shapes, T})
   end.

calcAreaSquare({dim, Height, Width}) when Height == Width -> math:pow(Width,2);
calcAreaSquare({dim, _, _}) -> 0.

testSquare() ->
   io:fwrite("Starting!~n"),
   shapes:squaresArea({shapes, [{rectangle, {dim, 5, 6}}, {rectangle, {dim, 5, 5.0}}, {rectangle, {dim, 5, 5}}, {triangle, {dim, 5, 5.0}}, {ellipse, {radius, 5, 5.0}}]}).
