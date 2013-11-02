-module(calculus_test).
-include_lib("eunit/include/eunit.hrl").

derivative_one_test() ->
	Func = fun(X) -> X * X end,
	Actual = calculus:derivative(Func, 3),
	Expected = 6.000000496442226,
	?assert(Expected =:= Actual).

derivative_two_test() ->
	Func = fun(X) -> 3 * X * X + 2 * X + 1 end,
	Actual = calculus:derivative(Func, 5),
	Expected = 32.00000264769187,
       ?assert(Expected =:= Actual).

derivative_three_test() ->
	Func = fun math:sin/1,
	Actual = calculus:derivative(Func, 0),
	Expected = 1.0,
	?assert(Expected =:= Actual).
