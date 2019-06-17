%%%-------------------------------------------------------------------
%%% @author Sean
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 17. Jun 2019 11:40 PM
%%%-------------------------------------------------------------------
-module(systemSupervisor).
-author("Sean").

%% API
-export([start_link/0, init/1, shutdown_link/0]).
-behavior(supervisor).

start_link() ->
   supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
   Server1 = {server1, {workerServer, start_link, [server1]}, permanent, 2000, worker, []},
   Server2 = {server2, {workerServer, start_link, [server2]}, permanent, 2000, worker, []},
   Server3 = {server3, {workerServer, start_link, [server3]}, permanent, 2000, worker, []},
   {ok, {{one_for_one, 1, 1}, [Server1, Server2, Server3]}}.

shutdown_link() ->
   exit(self(), shutdown).