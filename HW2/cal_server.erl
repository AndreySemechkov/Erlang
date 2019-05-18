%%%-------------------------------------------------------------------
%%% @author asemetchkov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. May 2019 19:30
%%%-------------------------------------------------------------------
-module(cal_server).
-author("asemetchkov").

%% API
-export([invoker/0]).

invoker() ->
   process_flag(trap_exit, true),
   Pid = spawn_link(matrix_server, mat_server, []),
   register(Pid, matrix_server),
   receive
      {'EXIT', Pid, normal} -> ok;  % No crash
      {'EXIT', Pid, shutdown} -> ok; % No crash
      {'EXIT', Pid, _} -> invoker()
   end.







