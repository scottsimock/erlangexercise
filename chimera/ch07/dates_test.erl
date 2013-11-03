-module(dates_test).
-include_lib("eunit/include/eunit.hrl").

julian_one_test() ->
	Actual = dates:julian("2012-01-29"),
	?assert(29 =:= Actual).

julian_two_test() ->
	Actual = dates:julian("2012-03-02"),
	Expected = 31+29+2,
	?assert(Expected =:= Actual).

julian_three_test() ->
	Actual = dates:julian("2013-03-02"),
	?assert(31+28+2 =:= Actual).

julian_four_test() ->
	Actual = dates:julian("2013-12-31"),
	?assert(365 =:= Actual).

julian_five_test() ->
	Actual = dates:julian("2012-12-31"),
	?assert(366 =:= Actual).

