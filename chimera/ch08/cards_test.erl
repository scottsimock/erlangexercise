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

	cut_test() ->
		Deck = cards:make_deck(),
		CutDeck = cards:cut(Deck),
		?assert( lists:max(Deck) =:= lists:max(CutDeck) ).

	compare_cards_test() ->
		AACard = {"A", spades},
		BBCard = {"K", spades},
		RAA = cards:compare(AACard, BBCard),
		?assert(1 =:= RAA),

		RBB = cards:compare(BBCard, AACard),
		?assert(-1 =:= RBB),

		CCCard = {"K", heart},
		RCC = cards:compare(BBCard, CCCard),
		?assert(0 =:= RCC),
		
		DDCard = {10, heart},
		RDD = cards:compare(DDCard, CCCard),
		?assert(-1 =:= RDD).
		
		
