%% @author Scott Simock simocks@gmail.com
%% Etude 7-2: List Comprehension and Pattern Matching

-module(list_comprehension_pattern_matching).
-export([filter/1, filter_or/1]).

%% @doc Filter function reviews a list of tuples and returns those 
%%	who are male and over 40

-spec(filter(list()) -> list()).

filter(List) ->
	[ Name ||
		{Name, Gender, Age} <- List,
		Age > 40,
		Gender =:= $M
	].

%% @doc Filter_or function review a list of tuples and returns the
%%	names of people who are male OR over 40

-spec(filter_or(list()) -> list()).
filter_or(List) ->
	[ Name ||
		{Name, Gender, Age} <- List,
		(Age > 40 orelse Gender =:= $M)
	].
