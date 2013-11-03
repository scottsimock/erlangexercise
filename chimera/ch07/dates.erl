%% @author Scott Simock simocks@gmail.com
%% Etude 7-4: Using lists.split/2

-module(dates).
-export([julian/1]).

%% @doc Function calculates the days in the year based on the input date
%%	The argument is a date string in the format YYYY-MM-DD
-spec(julian(string()) -> integer()).

julian(Date) ->
	[Year,Month,Day] = string:tokens(Date, "-"),
	count_days(cast_to_integer(Year), cast_to_integer(Month), cast_to_integer(Day)).

cast_to_integer(String) ->
	{Int,_} = string:to_integer(String),
	Int.

count_days(Year, Month, Day) ->
	DaysInFeb = case is_leap_year(Year) of
		true -> 29;
		false -> 28
		end,
	DaysInMonthList = [31, DaysInFeb, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31],
	{DaysInQuestion, _} = lists:split(Month - 1, DaysInMonthList),
	lists:foldl(fun(Days, Sum) -> Days + Sum end, Day, DaysInQuestion).

is_leap_year(Year) ->
	(Year rem 4 == 0 andalso Year rem 100 /= 0) orelse (Year rem 400 == 0).
