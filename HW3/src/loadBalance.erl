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
-export([startServers/0, stopServers/0, numberOfRunningFunctions/1, calcFun/3]).

startServers() ->
   systemSupervisor:start_link().

stopServers() ->
   systemSupervisor:shutdown_link(),
   exit(shutdown).

numberOfRunningFunctions(ServerID) ->
   case ServerID of
      1 -> {_, NumOfRunningFunctions} = gen_server:call(server1, {numOfRunning});
      2 -> {_, NumOfRunningFunctions} = gen_server:call(server2, {numOfRunning});
      3 -> {_, NumOfRunningFunctions} = gen_server:call(server3, {numOfRunning})
   end,
   NumOfRunningFunctions.

calcFun(PID, Func, MsgRef) ->
   ok,
   Workload = [numberOfRunningFunctions(1), numberOfRunningFunctions(2), numberOfRunningFunctions(3)],
   MinWorkload = lists:min(Workload),
   OptServer = getServerName(string:str(Workload, [MinWorkload])),
   gen_server:cast(OptServer, {calcFunc, Func, PID, MsgRef}).

%%%%%%%%%%%%%%%%%%%%%%%%
%% Internal Functions %%
%%%%%%%%%%%%%%%%%%%%%%%%

getServerName(ServerID) ->
   case ServerID of
      1 -> server1;
      2 -> server2;
      3 -> server3
   end.