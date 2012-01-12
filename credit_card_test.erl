-module(credit_card_test).
-include_lib("eunit/include/eunit.hrl").

credit_card_valid_number_test() ->
  lists:map(fun(N) -> ?assert(credit_card:is_valid(N)) end, valid_numbers()).

credit_card_invalid_number_test() ->
    lists:map(fun(N) -> ?assertNot(credit_card:is_valid(N)) end, invalid_numbers()).

amex_test() ->
  ?assertEqual(amex, credit_card:type("378282246310005")),
  ?assertEqual(amex, credit_card:type("348282246310005")).

visa_test() ->
  ?assertEqual(visa, credit_card:type("4111111111111111")),
  ?assertEqual(visa, credit_card:type("4012888888881881")).

mastercard_test() ->
  ?assertEqual(mastercard, credit_card:type("5105105105105100")),
  ?assertEqual(mastercard, credit_card:type("5512888888881881")).
  
discover_test() ->
  ?assertEqual(discover, credit_card:type("6011111111111117")).

valid_numbers() ->
  ["4111111111111111", "4012888888881881", "378282246310005", "6011111111111117", "5105105105105100"].

invalid_numbers() -> 
  ["411111111111111", "40128888888081881", "3782822406310005", "601111111111117", "510510515105100"].