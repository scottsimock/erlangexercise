-module(list_comprehension_pattern_matching_test).
-include_lib("eunit/include/eunit.hrl").

filter__test() ->
	People = [{"Fred", $M, 22}, {"Kim", $F, 45}, {"Hansa", $F, 30},
		{"Tran", $M, 47}, {"Cathy", $F, 32}, {"Elias", $M, 50}],
	Actual = list_comprehension_pattern_matching:filter(People),
	Expected = ["Tran","Elias"],
	?assert(Expected =:= Actual).

filter_or_test() ->
	People = [{"Fred", $M, 22}, {"Kim", $F, 45}, {"Hansa", $F, 30},
		{"Tran", $M, 47}, {"Cathy", $F, 32}, {"Elias", $M, 50}],
	Actual = list_comprehension_pattern_matching:filter_or(People),
	Expected = ["Fred", "Kim", "Tran", "Elias"],
	?assert(Expected =:= Actual).

