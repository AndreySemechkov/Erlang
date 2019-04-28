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

canWin(N) when N > 2 -> not(canWin(N-2) and (canWin(N-1)));

canWin(N) when N == 1 ; N == 2 -> true.

nextMove(N) when N > 1 ->
   CanWin = canWin(N),
   case CanWin of
      true ->
         CanWin2 = not(canWin(N-1)),
         case CanWin2 of
            true -> {true, 1};
            false -> {true, 2}
         end;
      false -> false
   end;

nextMove(N) when N == 1 -> {true, 1}.

explanation() -> {'At each call to canWin(N), there are two independent recursive calls - since there are
two options for match picking (1 or 2). Therefore it is difficult to use tail recursion'}.
