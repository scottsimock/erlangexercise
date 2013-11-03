-module(stats).
-export([minimum/1, maximum/1, range/1, mean/1, stdv/1]).

minimum([Current|Tail]) ->
	Operator = fun erlang:'<'/2,
	get_min_or_max(Operator, Current, Tail).

maximum([Current|Tail]) ->
	Operator = fun erlang:'>'/2,
	get_min_or_max(Operator, Current, Tail).

range(List) ->
	Largest = maximum(List),
	Smallest = minimum(List),
	[Smallest, Largest].

%% @doc Function returns the mean value of a list of integers
-spec(mean(list()) -> float()).
mean(List) ->
	sum(List) / erlang:length(List).

%% @doc Function returns the standard deviation of the list of integers
-spec(stdv(list()) -> float()).
stdv(List) -> 
	Func = fun(X, {TSum, TSumSqr}) -> { X + TSum, X * X + TSumSqr} end,
	{Sum, SumSquared} = lists:foldl(Func, {0,0}, List), 
	Length = erlang:length(List),
	CalcAAA = (Length * SumSquared) - (Sum * Sum),
	CalcBBB = CalcAAA / (Length * (Length - 1)),
	math:sqrt(CalcBBB).

sum(List) ->
	lists:foldl(fun(X,Total) -> X + Total end, 0, List).
	


get_min_or_max(Operator, Current, [Head|Tail]) ->
	IsTrue  = Operator(Current, Head),
	case IsTrue of
		true -> get_min_or_max(Operator, Current, Tail);
		false -> get_min_or_max(Operator, Head, Tail)
	end;
get_min_or_max(_, Current, []) ->
	Current.



