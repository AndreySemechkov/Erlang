%%%-------------------------------------------------------------------
%%% @author asemetchkov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. May 2019 17:20
%%%-------------------------------------------------------------------
-module(matrix_server).
-author("asemetchkov").
-export([start_server/0]).
-export([shutdown/0]).
-export([get_version/0]).
-export([explanation/0]).
-export([mult/2]).
-export([loop/0]).

start_server() ->
  spawn(server, invoke, []).

loop() ->
  receive

    shutdown ->

    sw_upgrade ->

  end.


mult(Mat1, Mat2) ->
  receive

  after
    10000 -> ok
  end.

shutdown() ->


get_version() ->


explanation() ->
