-module(math_functions).
-export([even/1, odd/1, filter/2 ]).


filter(Fun, List) when is_function(Fun), is_list(List) ->
	lists:filter(Fun, List).

even(X) when is_integer(X) ->
	 case (X rem 2) of
		0 -> true;
		1 -> false
	end.

odd(X) ->
	even(X) =:= false.
