%% @author Scott Simock simocks@gmail.com
%% Etude 7-1: Simple Higher Order Functions

-module(calculus).
-export([derivative/2]).

%% @doc Function calculates the rate of change of a function.
%%	The first argument is the function whose derivative you wish to find
%%	Second argument is the point at which you are measuring the derivative

-spec(derivative(function(),integer()) -> float()).
derivative(Func, Point) ->
	Delta = 1.0e-10,
	(Func(Point + Delta) -Func(Point)) / Delta.       
