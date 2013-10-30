-module(dates).
-export([parts/1, julian/1]).

-spec(parts(list()) -> list()).

parts(DateString) ->
	[StrYear, StrMonth, StrDay] = re:split(DateString, "-", [{return, list}]),
	{Year,_} = string:to_integer(StrYear),
	{Month,_} = string:to_integer(StrMonth),
	{Day,_} = string:to_integer(StrDay),

	[Year, Month, Day].

julian(DateString) ->
	calendar:date_to_gregorian_days(DateString).
