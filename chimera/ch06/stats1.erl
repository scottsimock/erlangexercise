-module(stats1).
-export([minimum/1, maximum/1, range/1]).

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

get_min_or_max(Operator, Current, [Head|Tail]) ->
	IsTrue  = Operator(Current, Head),
	case IsTrue of
		true -> get_min_or_max(Operator, Current, Tail);
		false -> get_min_or_max(Operator, Head, Tail)
	end;
get_min_or_max(_, Current, []) ->
	Current.



