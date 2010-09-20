all:
	./rebar compile
	cd rel && ../rebar generate
	cd rel && tar cfpj ../policysrv.tar.bz2 policysrv

clean:
	rm -rf ebin
	rm -rf rel/policysrv
	rm -rf policysrv.tar.bz2
