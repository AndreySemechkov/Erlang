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
-export([start_server/0, shutdown/0, get_version/0, explanation/0, matrix_server_listener/0]).

start_server() ->
   spawn(super_server, invoke, []).

matrix_server_listener() ->
  receive

    {Pid, MsgRef, {multiple, Mat1, Mat2}} ->
       matrix:multiply(Mat1, Mat2, Pid, MsgRef),
       matrix_server_listener();

    shutdown ->
       %shut down the servers
       exit(shutdown);

    {Pid, MsgRef, get_version} ->
       Pid ! {MsgRef, get_version()},
       matrix_server_listener();

    sw_upgrade ->
       ?MODULE:matrix_server_listener()

  end.


%%mult(Mat1, Mat2) ->
%%  receive
%%
%%  after
%%    10000 -> ok
%%  end.

shutdown() ->
  exit(whereis(matrix_server), shutdown).

get_version() ->
  version_1.

explanation() ->
   "".