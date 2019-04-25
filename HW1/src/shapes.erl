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
-export([trianglesArea/1]).
-export([squaresArea/1]).
-export([testSquare/0]).


shapesArea([]) -> 0;
shapesArea([H|T]) ->
%   case H


trianglesArea([]) -> 0;
trianglesArea([H|T]) when H == {triangle, {dim, _, _}}->
   areaTriangle(H) + trianglesArea(T);
trianglesArea([_|T]) ->
   0 + trianglesArea(T).

calcAreaRectangle({dim, Width, Height}) when Width > 0 , Height > 0 ->
   Width * Height;
calcAreaRectangle({dim, _, _}) ->
   io:format("Invalid Dimensions!~n").

-export([areaTriangle/1]).
areaTriangle({dim, Base, Height}) when Base > 0 , Height > 0 ->
   Base * Height / 2;
areaTriangle({dim, _, _}) ->
   io:format("Invalid Dimensions!~n").

-export([areaEllipse/1]).
areaEllipse({radius, Radius1, Radius2}) when Radius1 > 0 , Radius2 > 0 ->
   math:pi() * Radius1 * Radius2;
areaEllipse({radius, _, _}) ->
   io:format("Invalid Dimensions!~n").




calcSquareArea({dim, Height, Width}) when Height == Width -> math:pow(Width,2);
calcSquareArea({dim, _, _}) -> 0;

squaresArea({shapes, [H|T]})  ->
   case getShape(H)[0]==rectangle of
      calcSquareArea(H) + squaresArea(T);
   end.
squaresArea({dim, _, _}) -> io:format("Invalid Dimensions!~n").

testSquare() ->
   io:fwrite("Starting!~n"),
   shapes:squaresArea({shapes, [{rectangle, {dim, 5, 6}}, {rectangle, {dim, 5, 5.0}}]}).




