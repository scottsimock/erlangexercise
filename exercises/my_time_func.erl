-module(my_time_func).
-export([run/2]).

run(Func, Args) when is_function(Func) ->
	StartTime = erlang:now(),
	erlang:apply(Func, Args),	
	EndTime = erlang:now(),
	{SMeg,SSec,SMic} = StartTime,
	{EMeg,ESec,EMic} = EndTime,
	{EMeg-SMeg, ESec-SSec, EMic-SMic}.
