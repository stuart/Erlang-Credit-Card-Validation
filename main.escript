#!/usr/local/bin/escript

main(Args) ->
  true = code:add_pathz(filename:dirname(escript:script_name()) ++ "/ebin"),
  case Args of
    [] -> 
      read_input(io:get_line("> "));
    _ ->
      write_output(Args)
    end.
      
read_input(eof) -> ok;
read_input("q\n") -> ok;
read_input({error, Reason}) -> {error, Reason};
read_input(Data) ->
  write_output(string:tokens(Data, " \n")),
  read_input(io:get_line("> ")).

write_output(CardNumbers) ->
  try(io:format("~p~n", [lists:map(fun(N) -> {credit_card:type(N), N, valid(N)} end, CardNumbers)])) of
    _ -> ok
  catch
    error:badarg ->
      io:format("Invalid credit card number in: ~p~n", [CardNumbers])
  end.

valid(N) ->
  case credit_card:is_valid(N) of
    true ->
      valid;
    false -> 
      invalid
  end.