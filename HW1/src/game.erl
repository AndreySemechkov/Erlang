%%%-------------------------------------------------------------------
%%% @author Sean
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. Apr 2019 2:18 AM
%%%-------------------------------------------------------------------
-module(game).
-author("Sean").

%% API
-export([canWin/1]).
-export([nextMove/1]).
-export([explanation/0]).

canWin(N) when N > 0 -> canWin(N, first).

canWin(N, Player) when N > 3 ->
   case Player of
      first -> canWin(N-2, second) orelse canWin(N-1, second);
      second -> canWin(N-2, first) orelse canWin(N-1, first)
   end;

canWin(N, Player) when N == 1 ; N == 2 ->
   case Player of
      first -> true;
      second -> false
   end;

canWin(N, Player) when N == 3 ->
   case Player of
      first -> false;
      second -> true
   end.

nextMove(N) when N > 0 ->
   case canWin(N) of
      true ->
         ModN = N rem 3,
         case ModN of
            1 -> {true, 1};
            2 -> {true, 2}
         end;
      false -> false
   end.

explanation() -> {"There are two independent recursive calls, therefore we cannot use tail recursion"}.
