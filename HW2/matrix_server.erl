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
-export([mult/2]).
-export([get_version/0]).
-export([explanation/0]).

-export([mat_server/0]).

start_server() ->
  spawn(server, invoke, []).

mat_server() ->
  receive

    {Pid, MsgRef, {multiple, Mat1, Mat2}} ->
      %spawn a new server to do the job
      spawn(server, mult, [Mat1, Mat2, Pid, MsgRef]),
      mat_server();

    shutdown ->
      %shut down the servers
      exit(shutdown);

    {Pid, MsgRef, get_version} ->
      Pid ! {MsgRef, get_version()},
      mat_server();

    sw_upgrade ->
      ?MODULE:mat_server()

  end.


mult(Mat1, Mat2) ->
  receive

  after
    10000 -> ok
  end.

shutdown() ->
  exit(whereis(matrix_server), shutdown).

get_version() ->
  version_1.

explanation() ->
   "".
