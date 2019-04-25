%%%-------------------------------------------------------------------
%%% @author Sean
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. Apr 2019 8:06 PM
%%%-------------------------------------------------------------------
-module(main).
-author("Sean").

%% API
-export([test/0]).

validRectangle1() -> {rectangle,{dim,1,2}}.		% size 2
validRectangle3() -> {rectangle,{dim,5,5}}.		% size 25
validRectangle4() -> {rectangle,{dim,1,1}}.		% size 1

validTriangle2() -> {triangle,{dim,3,2}}.		% size 3
validTriangle3() -> {triangle,{dim,4,4}}.		% size 8

%%validEllipse1() -> {ellipse,{radius,1,2}}.
validEllipse2() -> {ellipse,{radius,3,2}}.

validShapes4() -> {shapes,[validEllipse2(), validRectangle1(), validTriangle2() , validTriangle3(), validRectangle3(),
                           validRectangle4()]}.
%%validShapes4() -> {shapes,[validRectangle1(), validTriangle2() , validTriangle3(), validRectangle3(),
%%                           validRectangle4()]}.


test() ->
   io:fwrite("Starting!~n"),
   shapes:squaresArea({shapes, [{rectangle, {dim, 5, 6}}, {rectangle, {dim, 5, 5.0}}, {rectangle, {dim, 5, 5}}, {triangle, {dim, 5, 5.0}}, {ellipse, {radius, 5, 5.0}}]}).
   io:format("expecting ~p and got ~p ~n",[57.84955592153876,shapes:shapesArea(validShapes4())]).
