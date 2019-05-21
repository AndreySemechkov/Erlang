%%%-------------------------------------------------------------------
%%% @author Sean
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. May 2019 3:26 AM
%%%-------------------------------------------------------------------
-module(super_server).
-author("Sean").

%% API
-export([invoke/0]).

invoke() ->
   process_flag(trap_exit, true),
   Pid = spawn_link(matrix_server, matrix_server_listener, []),
   register(matrix_server, Pid),
   receive
      {'EXIT', Pid, normal} -> ok;  % No crash
      {'EXIT', Pid, shutdown} -> ok; % No crash
      {'EXIT', Pid, _} -> invoke()
   end.