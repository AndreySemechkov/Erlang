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
-export([start_server/0, shutdown/0, get_version/0, explanation/0]).

start_server() ->
   spawn(fun() -> restart_server() end).

restart_server() ->
   process_flag(trap_exit, true),
   Pid = spawn_link(fun() -> matrix_server_listener() end),
   register(matrix_server, Pid),
   receive
      {'EXIT', Pid, normal} -> ok;  % No crash
      {'EXIT', Pid, shutdown} -> ok; % No crash
      {'EXIT', Pid, _} -> restart_server()
   end.

matrix_server_listener() ->
  receive

    {Pid, MsgRef, {multiple, Mat1, Mat2}} ->
       multiply(Mat1, Mat2, Pid, MsgRef),
       matrix_server_listener();

    shutdown ->
       %shut down the servers
       exit(shutdown);

    {Pid, MsgRef, get_version} ->
       Pid ! {MsgRef, get_version()},
       matrix_server_listener();

    sw_upgrade ->
       ?MODULE:matrix_server_listener()

  end.


%%mult(Mat1, Mat2) ->
%%  receive
%%
%%  after
%%    10000 -> ok
%%  end.

shutdown() ->
  exit(whereis(matrix_server), shutdown).

get_version() ->
  version_1.

explanation() ->
   "".

multiply(Mat1, Mat2, Pid, MsgRef) ->
   DimX = tuple_size(Mat1),
   DimY = tuple_size(matrix:getRow(Mat2, 1)),
   InitMat = matrix:getZeroMat(DimX, DimY),
   multiply_mat(Mat1, Mat2, DimX, DimY),
   Pid ! {MsgRef, fill_matrix(InitMat, 0, DimX * DimY)}.

multiply_mat(Mat1, Mat2, DimX, DimY) ->
   Rows = tuple_to_list(Mat1),
   Cols = [matrix:getCol(Mat2, Y) || Y <- lists:seq(1, DimY)],
   Pid = self(),
   [spawn(fun() -> multiply_vec(Row, lists:nth(Row, Rows), Col, lists:nth(Col, Cols), Pid) end)
      || Row <- lists:seq(1, DimX), Col <- lists:seq(1, DimY)].

fill_matrix(Mat, Cnt, MaxCnt) when Cnt == MaxCnt ->
   Mat;
fill_matrix(Mat, Cnt, MaxCnt) ->
   receive
      {Row, Col, Res} ->
         New_Mat = matrix:setElementMat(Row, Col, Mat, Res),
         New_Cnt = Cnt + 1,
         fill_matrix(New_Mat, New_Cnt, MaxCnt)
   end.

multiply_vec(Row, RowVec, Col, ColVec, Pid) ->
   Pid ! {Row, Col, multiply_list_vec(tuple_to_list(RowVec), tuple_to_list(ColVec), 0)}.

multiply_list_vec([], [], Res) ->
   Res;
multiply_list_vec([H_vec1|T_vec1], [H_vec2|T_vec2], Res) ->
   multiply_list_vec(T_vec1, T_vec2, H_vec1 * H_vec2 + Res).