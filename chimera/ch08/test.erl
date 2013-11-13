-module(test).
-export([result/2]).

result(T, C) ->
	case T of
	T when T > C -> g;
	T when T =:= C -> e;
       _ -> l
end.	       
