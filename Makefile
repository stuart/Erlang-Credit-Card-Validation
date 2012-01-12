# leave these lines alone
.SUFFIXES: .erl .beam

.erl.beam:
	erlc -W -o ./ebin $<

ERL = erl -boot start_clean 

MODS = credit_card credit_card_test

compile: ${MODS:%=./src/%.beam}
	

clean:	
	rm -rf *.beam erl_crash.dump

test: compile
	
	./test.escript ebin