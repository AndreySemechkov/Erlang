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
-export([circleFilterWrapper/1]).
-export([squareFilterWrapper/1]).

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
   
squaresArea({shapes,[]}) -> 0;
squaresArea({shapes, [H|T]})  ->
   case getShape(H) == rectangle of
      true -> calcAreaSquare(getShapeDim(H)) + squaresArea({shapes, T});
      false -> 0 + squaresArea({shapes, T})
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

calcAreaSquare({dim, Height, Width}) when Height == Width ->
   math:pow(Width,2);
calcAreaSquare({dim, _, _}) -> 0.



squareFilterWrapper({shapes,[H|T]}) ->
   ShapesList = squareFilter({shapes,[H|T]}),
   {shapes, ShapesList};
squareFilterWrapper({radius, _, _}) ->
   io:format("Invalid Dimensions!~n").

squareFilter({shapes,[]}) -> [];
squareFilter({shapes,[H|T]}) ->
   case getShape(H) == rectangle of
      true ->
         {_, Width, Height} = getShapeDim(H),
         case Height == Width of
            true -> [H|squareFilter({shapes, T})];
            false -> squareFilter({shapes,T})
         end;
      false -> squareFilter({shapes,T})
   end.


circleFilterWrapper({shapes,[H|T]}) ->
   ShapesList = circleFilter({shapes,[H|T]}),
   {shapes, ShapesList};
circleFilterWrapper({radius, _, _}) ->
   io:format("Invalid Dimensions!~n").


circleFilter({shapes,[]}) -> [];
circleFilter({shapes,[H|T]}) ->
   case getShape(H) == ellipse of
      true ->
         {_, Radius1, Radius2} = getShapeDim(H),
         case Radius1 == Radius2 of
            true -> [H|circleFilter({shapes, T})];
            false -> circleFilter({shapes,T})
         end;
      false -> circleFilter({shapes,T})
   end.

