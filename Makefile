# leave these lines alone
.SUFFIXES: .erl .beam
QCLIB = lib/eqcmini/ebin/
ERL = erl -boot start_clean 
MODS = credit_card credit_card_test credit_card_validation_server credit_card_eqc

.erl.beam:
	erlc -W -pa $(QCLIB) -o ./ebin $<

compile: ${MODS:%=./src/%.beam}
	

clean:	
	rm -rf *.beam erl_crash.dump
	rm -rf ebin/*.beam

test: compile
	./test.escript ebin
	
quickcheck: compile
	erl -pa ebin/ -pa $(QCLIB) -eval 'eqc:module(credit_card_eqc).'
	
server: compile
	erl -pz ebin/ -eval 'credit_card_validation_server:start().'