%% @author Scott Simock simocks@gmail.com
%% Etude 8-1: Usng Processes to Simulate a Card Game

-module(player).
%%-export([ start/0, shuffle/1, cut/2, deal/5, play_card/5, await_play/5 ]).
-export([ start/0, shuffle/1, cut/2 ]).

%% @doc Function spawns a player process in the start state
-spec(start() -> pid()).
start() -> spawn(fun() -> await_game_start() end).

%% @doc When player is in the start state, this function waits for the next command
await_game_start() ->
	show_message("await_game_start"),
	receive
		{shuffle, Pid} ->
			shuffle(Pid);
		{cut, Pid, Deck} ->
			cut(Pid, Deck);
		_ -> io:format("ERROR: Wrong action passed to start~n")
	after 10000 ->
			await_game_start()
	end.

%% @doc Function used by dealer to create deck of cards, asks the other player to cut,
%%	then waits for the cut deck to be returned
shuffle(Pid) ->
	show_message("shuffle"),
	Deck = cards:shuffle( cards:make_deck() ),
	Pid ! {cut, self(), Deck},
	await_cut().

%% @doc Function used by other player to cut the deck in half
%%	It then passes the deck back to the dealing player and waits to be dealt cards
-spec(cut(pid(), list()) -> list()).
cut(Pid, Deck) ->
	show_message("cut"),
	Pid ! { deck_cut, self(), cards:cut(Deck) },
	await_cards_from_deal([]).

%% @doc Function used by dealer to wait for the other player to cut the cards
%%	and hand back the deck
await_cut() ->
	show_message("await_cut"),
	receive
		{deck_cut, Pid, CutDeck} ->
			deal(Pid, CutDeck, [], false);
		_ -> io:format("ERROR: Didn't receive the deal message in shuffle~n")
	after 10000 ->
			await_cut()
	end.

%% @doc Function used by other player to receive the one card at a time from the dealer
%%	When the dealer has dealt all cards, tells other_player to begin battle
await_cards_from_deal(Hand) ->
	show_message("await_cards_from_deal"),
	receive
		{card, Card} ->
			await_cards_from_deal([Card] ++ Hand);
		{lets_battle, Pid} ->
			battle(Pid, Hand, [], []);
		_ -> io:format("ERROR: Didn't reeive a card when await_cards_from_deal~n")
	after 10000 ->
			await_cards_from_deal(Hand)
	end.


%% @doc Function used by the dealer after the cards are fully dealt
%%	Here the dealer tells the other player to start playing
deal(Pid, [], Hand, _) ->
	show_message("Cards Dealt"),
	Pid ! {lets_battle, self()},
	await_battle(Pid, Hand, [], []);
%% @doc Function used by the dealer to distrubute the cards to each player
deal(Pid, [TopCard|Deck], Hand, IsMyCard) ->
	show_message("deal"),
	case IsMyCard of
		true -> 
			deal(Pid, Deck, [TopCard] ++ Hand, false);
		false -> 
			Pid ! { card, TopCard },
			deal(Pid, Deck, Hand, true);
		_ -> io:format("ERROR: Invalid case in deal~n")
	end.



%% @doc Function used by both players - the player instigating battle flips over the card first
battle(Pid, [TopCard | Hand], CardsWon, WarStack) -> %% regular battle when there are cards in Hand
	show_message("battle"),
	Pid ! {play, TopCard},
	await_battle(Pid, Hand, CardsWon, WarStack);
battle(Pid, [], [ACard|CardsWon], WarStack) -> %% battle when there are no more cards in Hand but cards in CardsWon
	Hand = cards:shuffle([ACard]++CardsWon),
	battle(Pid, Hand, [], WarStack);
battle(Pid, [], [], []) -> 
	Pid ! {champion}.


%% @doc Fuction used by both players - SHOULD SPLIT INTO FUNCTION FOR DEALER AND FUNCTION FOR OTHER_PLAYER
await_battle(Pid, [MyCard | RestOfHand], CardsWon, WarStack) -> %% should always have at least one card in the Hand
	show_message("await_battle"),
	Hand = [MyCard] ++ RestOfHand,
	receive
		{play, TheirCard} -> %% other_player - receiving TheirCard means they went first
			battle_cards(Pid, Hand, CardsWon, WarStack, TheirCard);
		
		{win, CardsInPlay} -> %% dealer - if the other players tells that you won, that means you went first
			await_battle(Pid, Hand, CardsInPlay ++ CardsWon, []);

		{war_confirm_card_count, TheirCount} -> %% dealer - determine the number of cards to use in war
			MyCount = get_down_card_count(Hand, CardsWon),
			case TheirCount > MyCount of
				true -> Count = MyCount; 
				false -> Count = TheirCount
			end,
			send_war_cards(erlang:length(Hand), Count, Pid, Hand, CardsWon, [], true, nothing); 

		{war, CardsDown, TheirCard} -> %% other_player
			send_war_cards(erlang:length(Hand), erlang:length(CardsDown), Pid, Hand, CardsWon, WarStack, false, TheirCard);

		{champion} ->
			show_message("I am the champion")

	end;
%% @doc Fuction used by both players - shuffle CardsWon back into your hand
await_battle(Pid, [], [ACard|CardsWon], WarStack) ->
	show_message("await_battle - shuffle cardswon"),
	Hand = cards:shuffle([ACard]++CardsWon), %% shuffle in cards won
	await_battle(Pid, Hand, [], WarStack);
%% @doc Fuction used by both players - shuffle CardsWon back into your hand
await_battle(Pid, [], [], _) ->
	show_message("await_battle - gameover"),
	Pid ! {champion}.	


%% @doc Function evaluates the play
battle_cards(Pid, Hand, CardsWon, WarStack, TheirCard) ->
	[MyCard | RestOfHand] = Hand,
	Result = cards:compare(MyCard,TheirCard),
	CardsInPlay = [MyCard, TheirCard] ++ WarStack,
	case Result of
		-1 ->  %% You lost the hand
			Pid ! {win, CardsInPlay},
			battle(Pid, RestOfHand, CardsWon, []);

		0 -> %% WAR - how many cards can you play
			Count = get_down_card_count(Hand, CardsWon),
			Pid ! {war_confirm_card_count, Count},
			await_battle(Pid, RestOfHand, CardsWon, CardsInPlay);

		1 -> %% You won the hand
			battle(Pid, RestOfHand, CardsInPlay ++ CardsWon, [])
	end.

%% @doc Function used in a War to determine the number of cards to use
get_down_card_count(Hand, CardsWon) -> 
	show_message("get_donw_card_count"),
	Length = erlang:length(Hand) + erlang:length(CardsWon), %% won't exceed 52 so perf hit is ok
	get_down_card_count(Length).

get_down_card_count(Length) when Length > 3 -> 2;
get_down_card_count(Length) -> Length.


%% @doc Function used by both players to send the other the cards of war 
send_war_cards(HandLength, Count, Pid, Hand, CardsWon, WarStack, IsDealer, TheirCard) when HandLength >= Count -> %% all cards in hand
	{CardsDown, CardsInHand} = lists:split(Count, Hand),
	send_war_card_message(Pid, CardsDown, CardsInHand, CardsWon, WarStack, IsDealer, TheirCard);
send_war_cards(_, Count, Pid, Hand, CardsWon, WarStack, IsDealer, TheirCard) -> %% will need cards from CardsWon
	NewHand = Hand ++ cards:shuffle(CardsWon), %% shuffle in cardswon
	send_war_cards(erlang:length(NewHand), Count, Pid, NewHand, [], WarStack, IsDealer, TheirCard).

send_war_card_message(Pid, CardsDown, Hand, CardsWon, _, IsDealer, _) when IsDealer =:= true -> %% dealer
	[MyCard|CardsInHand] = Hand,
	Pid ! {war, CardsDown, MyCard}, 
	await_battle(Pid, CardsInHand, CardsWon, []);
send_war_card_message(Pid, CardsDown, Hand, CardsWon, WarStack, IsDealer, TheirCard) when IsDealer =:= false -> %% other_player
	battle_cards(Pid, Hand, CardsWon, CardsDown ++ WarStack, TheirCard).	



show_message(Message) ->
	io:format("~p: ~s~n", [self(),Message]).

