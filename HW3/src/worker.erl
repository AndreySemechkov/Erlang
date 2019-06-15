%%%-------------------------------------------------------------------
%%% @author asemetchkov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. Jun 2019 20:09
%%%-------------------------------------------------------------------
-module(worker).
-author("asemetchkov").

%% API
-behaviour(gen_server).
-behavior(supervisor).
-export([start_link/1]).
-export([init/1, handle_cast/2, handle_call/3]).
-export([handle_info/2]).

start_link(Name) ->
  gen_server:start_link({local, Name}, ?MODULE, [Name, local], []).

init([Name, Type]) ->
  process_flag(trap_exit, true),
  {ok, {Name, Type}, 1000}.

handle_info(timeout, {Name, local}) ->
  io:format("~s is working \n",[Name]),
  {noreply, Name, 1000};

handle_info(_Info, S) -> {noreply,S,1000}.

handle_cast({cast, MsgRef}, Name) ->
  io:format("name ~s is handleing cast \n",[Name]),
  {noreply, MsgRef}.

handle_call(call, _From, Name) ->
  io:format("name ~s is handleing call \n",[Name]),
  {reply, Name, _From}.

%% handle call of num of jobs
%% handle cast of jobs perform