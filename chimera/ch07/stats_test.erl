-module(stats_test).
-include_lib("eunit/include/eunit.hrl").

mean_test() ->
	List = [7, 2, 9],
	Actual = stats:mean(List),
	Expected = 6.0,
	?assert(Expected =:= Actual).

stdv_test() ->
	List = [7,2,9],
	Actual = stats:stdv(List),
	Expected = 3.605551275463989,
	?assert(Expected =:= Actual).
