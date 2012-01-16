-module (credit_card_eqc).
-include_lib("eqcmini/include/eqc.hrl").
-compile(export_all).
-author({author, "Stuart Coyle","stuart.coyle@gmail.com"}).

%% These test are actually not very valuable, since we are
%% testing an incredibly tiny proportion of the card number 
%% space.
%%
%% I just put them here as an example of Quickcheck properties.

prop_valid_number() ->
  ?FORALL(N, valid_cc_number(), credit_card:is_valid(N)).

prop_visa_card() ->
  ?FORALL(N, visa_cc_number(), credit_card:type(N) =:= visa).

prop_amex_card() ->
  ?FORALL(N, amex_cc_number(),  credit_card:type(N) =:= amex).
  
prop_mastercard_card() ->
  ?FORALL(N, mastercard_cc_number(),  credit_card:type(N) =:= mastercard).

prop_discover_card() ->
  ?FORALL(N, discover_cc_number(),  credit_card:type(N) =:= discover).
  
%% Generators
valid_cc_number() ->
  ?LET(OddDigits, vector(8,oneof(lists:seq($0, $9))),
    ?LET(EvenDigits, vector(8,oneof(lists:seq($0, $9))),
      return(chksum(EvenDigits,OddDigits))
    )).

chksum(EvenDigits,OddDigits) ->
  L1 = lists:flatten(lists:zipwith(fun(E,O) -> [E, O] end, EvenDigits, OddDigits)),
  L2 = lists:zipwith(fun(E,O) -> digital_root(O * 2) + E end, list_elements_to_int(EvenDigits), list_elements_to_int(OddDigits)),
  Checkdigit = (10 - lists:sum(L2) rem 10) rem 10,
  L1 ++ integer_to_list(Checkdigit).

list_elements_to_int(List) ->
  lists:map(fun(N) -> list_to_integer([N]) end, List).

digital_root(N) ->
  digital_root(N,0).

digital_root(0, N) ->
  N;

digital_root(N, Acc) ->
  Total = Acc + N rem 10,
  digital_root(N div 10, Total).

visa_cc_number() ->
  ?LET(Length, oneof([13,16]),
    ?SUCHTHAT(X, vector(Length, oneof(lists:seq($0, $9))), lists:nth(1, X) =:= $4)).

amex_cc_number() ->
  ?LET(Prefix, oneof(["34", "37"]), 
    Prefix ++ vector(13, oneof(lists:seq($0, $9)))).

mastercard_cc_number() ->
  ?LET(Prefix, oneof(["51","52","53","54","55"]), 
    Prefix ++ vector(14, oneof(lists:seq($0, $9)))).
  
discover_cc_number() ->
  ?LET(Prefix, return("6011"),
    Prefix ++ vector(12, oneof(lists:seq($0, $9)))).
