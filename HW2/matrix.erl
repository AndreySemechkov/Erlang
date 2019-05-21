%%%-------------------------------------------------------------------
%%% @author asemetchkov
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 18. May 2019 20:10
%%%-------------------------------------------------------------------
-module(matrix).
-author("asemetchkov").

%% API
-compile(export_all).
% generate a matrix with X rows and Y columns with zeros
getZeroMat(X,Y) ->
  list_to_tuple([list_to_tuple([0 || _Y <- lists:seq(1,Y)]) || _X <- lists:seq(1,X)]).
% return the ROW row of a Matrix in a tuple format
getRow(Mat,Row) ->
  element(Row,Mat).
% return the COL col of a Matrix in a tuple format
getCol(Mat,Col) ->
  list_to_tuple([element(Col,ColData) || ColData <- tuple_to_list(Mat)]).
% return a new Matrix which is a copy of OldMat with a NewVal as the value of Row,Col
setElementMat(Row,Col,OldMat, NewVal) ->
  setelement (Row,OldMat ,setelement (Col,element(Row,OldMat),NewVal)).

multiply(Mat1, Mat2, Pid, MsgRef) ->
   DimX = tuple_size(Mat1),
   DimY = tuple_size(getRow(Mat2, 1)),
   InitMat = getZeroMat(DimX, DimY),
   multiply_mat(Mat1, Mat2, DimX, DimY),
   Pid ! {MsgRef, fill_matrix(InitMat, 0, DimX * DimY)}.

multiply_mat(Mat1, Mat2, DimX, DimY) ->
   Rows = tuple_to_list(Mat1),
   Cols = [getCol(Mat2, Y) || Y <- lists:seq(1, DimY)],
   Pid = self(),
   [spawn(fun() -> multiply_vec(Row, lists:nth(Row, Rows), Col, lists:nth(Col, Cols), Pid) end)
      || Row <- lists:seq(1, DimX), Col <- lists:seq(1, DimY)].

fill_matrix(Mat, Cnt, MaxCnt) when Cnt == MaxCnt ->
   Mat;
fill_matrix(Mat, Cnt, MaxCnt) ->
   receive
      {Row, Col, Res} ->
         New_Mat = setElementMat(Row, Col, Mat, Res),
         New_Cnt = Cnt + 1,
         fill_matrix(New_Mat, New_Cnt, MaxCnt)
   end.


multiply_vec(Row, RowVec, Col, ColVec, Pid) ->
   Pid ! {Row, Col, multiply_list_vec(tuple_to_list(RowVec), tuple_to_list(ColVec), 0)}.

multiply_list_vec([], [], Res) ->
   Res;
multiply_list_vec([H_vec1|T_vec1], [H_vec2|T_vec2], Res) ->
   multiply_list_vec(T_vec1, T_vec2, H_vec1 * H_vec2 + Res).