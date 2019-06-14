%%%-------------------------------------------------------------------
%%% @author Sean
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jun 2019 7:16 PM
%%%-------------------------------------------------------------------
-module(loadBalance).
-author("Sean").

%% API
-behavior(supervisor).
-export([]).

start_link() ->
   supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
   Server1 = {server1, {server1, start_link, []}, permanent, infinity, worker, [server1]},
   Server2 = {server2, {server2, start_link, []}, permanent, , worker, [server2]},
   Server3 = {server3, {server3, start_link, []}, permanent, , worker, [server3]},
   {ok, {{one_for_all, 1, 1}, [Server1, Server2, Server3]}}.