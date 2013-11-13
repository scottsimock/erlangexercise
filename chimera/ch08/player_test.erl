-module(player_test).
-include_lib("eunit/include/eunit.hrl").

start_test() ->
	DealerPid = player:start(),
	OtherPid = player:start(),
	?assert(erlang:is_pid(DealerPid)),
	?assert(erlang:is_pid(OtherPid)).




	
