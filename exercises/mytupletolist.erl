-module(mytupletolist).
-export([run/1]).

run(Tuple) 
	when is_tuple(Tuple) ->
		loop(1, erlang:tuple_size(Tuple) + 1, Tuple, []).

loop(Max, Max, Tuple, List) -> List;
loop(I, Max, Tuple, List)
	when is_integer(I) 
	and is_integer(Max) 
	and is_tuple(Tuple) 
	and is_list(List) ->
		loop(I+1, Max, Tuple,[erlang:element(I, Tuple)|List]).

