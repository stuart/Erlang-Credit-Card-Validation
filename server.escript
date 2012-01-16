#!/usr/local/bin/escript

main(_Args) ->
  {ok, Pid} = credit_card_validation_server:start().
