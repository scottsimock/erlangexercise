-module(cards_test).
-include_lib("eunit/include/eunit.hrl").

make_deck_does_this_create_a_full_deck_of_cards_test() ->
	Deck = cards:make_deck(),
	?assert(52 =:= erlang:length(Deck)),

	{Spades, Hearts, Clubs, Diamonds} = split_deck_into_suits(Deck),
	Length = 13,
	?assert(Length =:= erlang:length(Spades)),
	?assert(Length =:= erlang:length(Hearts)),
	?assert(Length =:= erlang:length(Clubs)),
	?assert(Length =:= erlang:length(Diamonds)),

	Expected = [2,3,4,5,6,7,8,9,10, "J", "Q", "K", "A"],
	?assert(Length =:= erlang:length(Expected)),
	assert_list(Expected, Spades),
	assert_list(Expected, Hearts),
	assert_list(Expected, Clubs),
	assert_list(Expected, Diamonds).

assert_list([EH|ExpectedList], [AH|ActualList]) ->
	?assert(EH =:= AH),
	assert_list(ExpectedList, ActualList);
assert_list([], []) -> ?assert(true).

split_deck_into_suits(Deck) ->
	F = fun(Card, SuitTuples) -> process_card(Card, SuitTuples) end,
	lists:foldl(F, {[],[],[],[]}, Deck).

process_card({Val,Suit}, {Spades,Hearts,Clubs,Diamonds}) 
	when Suit == spades ->
		{[Val] ++ Spades, Hearts, Clubs, Diamonds};

process_card({Val,Suit}, {Spades,Hearts,Clubs,Diamonds}) 
	when Suit == hearts ->
		{Spades, [Val] ++ Hearts, Clubs, Diamonds};

process_card({Val,Suit}, {Spades,Hearts,Clubs,Diamonds}) 
	when Suit == clubs ->
		{Spades, Hearts, [Val] ++ Clubs, Diamonds};

process_card({Val,Suit}, {Spades,Hearts,Clubs,Diamonds}) 
	when Suit == diamonds ->
		{Spades, Hearts, Clubs, [Val] ++ Diamonds}.



