%%%-------------------------------------------------------------------
%%% @author asemetchkov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jun 2019 20:09
%%%-------------------------------------------------------------------
-module(workerServer).
-author("asemetchkov").

%% API
-behaviour(gen_server).
-export([start_link/1, init/1, handle_cast/2, handle_call/3, calcFunc/4]).

start_link(Name) ->
   gen_server:start_link({local, Name}, ?MODULE, [Name], []).

init([Name]) ->
   process_flag(trap_exit, true),
   State = {Name, 0},
   {ok, State}.

handle_cast({calcFunc, Func, PID, MsgRef}, {Name, Count}) ->
   spawn(?MODULE, calcFunc, [Name, Func, PID, MsgRef]),
   NewState = {Name, Count + 1},
   {noreply, NewState};

handle_cast({doneCalc}, {Name, Count}) ->
   NewState = {Name, Count - 1},
   {noreply, NewState}.

handle_call({numOfRunning}, _From, {Name, Count}) ->
   Reply = Count,
   NewState = {Name, Count},
   {reply, Reply, NewState}.

calcFunc(Name, Func, PID, MsgRef) ->
   Result = Func(),
   gen_server:cast(Name, {doneCalc}),
   PID ! {MsgRef, Result}.